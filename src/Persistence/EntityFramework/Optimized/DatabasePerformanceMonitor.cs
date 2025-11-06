// <copyright file="DatabasePerformanceMonitor.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.Persistence.EntityFramework.Optimized;

using System.Collections.Concurrent;
using System.Data.Common;
using System.Diagnostics;
using System.Threading;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using Microsoft.Extensions.Logging;

/// <summary>
/// Monitors database performance and provides insights for optimization.
/// </summary>
public class DatabasePerformanceMonitor : IDbCommandInterceptor, IDisposable
{
    private readonly ILogger<DatabasePerformanceMonitor> _logger;
    private readonly ConcurrentDictionary<Guid, QueryExecution> _activeQueries = new();
    private readonly ConcurrentQueue<QueryMetrics> _queryMetrics = new();
    private readonly Timer _reportingTimer;
    private long _totalQueryCount;
    private long _slowQueryCount;
    private const int SlowQueryThresholdMs = 1000;
    private const int MaxStoredMetrics = 1000;

    /// <summary>
    /// Initializes a new instance of the <see cref="DatabasePerformanceMonitor"/> class.
    /// </summary>
    /// <param name="logger">The logger.</param>
    public DatabasePerformanceMonitor(ILogger<DatabasePerformanceMonitor> logger)
    {
        this._logger = logger;
        
        // Report performance metrics every 60 seconds
        this._reportingTimer = new Timer(this.ReportPerformanceMetrics, null, TimeSpan.FromMinutes(1), TimeSpan.FromMinutes(1));
    }

    /// <summary>
    /// Called before a command is executed.
    /// </summary>
    /// <param name="command">The command.</param>
    /// <param name="eventData">The event data.</param>
    /// <param name="result">The result.</param>
    /// <returns>The result.</returns>
    public InterceptionResult<DbDataReader> ReaderExecuting(
        DbCommand command,
        CommandEventData eventData,
        InterceptionResult<DbDataReader> result)
    {
        this.StartQueryTracking(command, eventData);
        return result;
    }

    /// <summary>
    /// Called after a command is executed.
    /// </summary>
    /// <param name="command">The command.</param>
    /// <param name="eventData">The event data.</param>
    /// <param name="result">The result.</param>
    /// <returns>The result.</returns>
    public DbDataReader ReaderExecuted(
        DbCommand command,
        CommandExecutedEventData eventData,
        DbDataReader result)
    {
        this.EndQueryTracking(command, eventData);
        return result;
    }

    /// <summary>
    /// Called before an async command is executed.
    /// </summary>
    /// <param name="command">The command.</param>
    /// <param name="eventData">The event data.</param>
    /// <param name="result">The result.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The result.</returns>
    public ValueTask<InterceptionResult<DbDataReader>> ReaderExecutingAsync(
        DbCommand command,
        CommandEventData eventData,
        InterceptionResult<DbDataReader> result,
        CancellationToken cancellationToken = default)
    {
        this.StartQueryTracking(command, eventData);
        return new ValueTask<InterceptionResult<DbDataReader>>(result);
    }

    /// <summary>
    /// Called after an async command is executed.
    /// </summary>
    /// <param name="command">The command.</param>
    /// <param name="eventData">The event data.</param>
    /// <param name="result">The result.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>The result.</returns>
    public ValueTask<DbDataReader> ReaderExecutedAsync(
        DbCommand command,
        CommandExecutedEventData eventData,
        DbDataReader result,
        CancellationToken cancellationToken = default)
    {
        this.EndQueryTracking(command, eventData);
        return new ValueTask<DbDataReader>(result);
    }

    /// <summary>
    /// Gets the current performance metrics.
    /// </summary>
    /// <returns>Current performance metrics.</returns>
    internal DatabasePerformanceMetrics GetMetrics()
    {
        var recentMetrics = this._queryMetrics.ToArray().TakeLast(100).ToArray();
        
        return new DatabasePerformanceMetrics
        {
            TotalQueries = this._totalQueryCount,
            SlowQueries = this._slowQueryCount,
            AverageExecutionTime = recentMetrics.Any() ? recentMetrics.Average(m => m.ExecutionTimeMs) : 0,
            TopSlowQueries = recentMetrics
                .Where(m => m.ExecutionTimeMs >= SlowQueryThresholdMs)
                .OrderByDescending(m => m.ExecutionTimeMs)
                .Take(10)
                .ToList(),
            MostFrequentQueries = recentMetrics
                .GroupBy(m => m.QueryPattern)
                .OrderByDescending(g => g.Count())
                .Take(10)
                .Select(g => new QueryFrequency
                {
                    QueryPattern = g.Key,
                    ExecutionCount = g.Count(),
                    AverageExecutionTime = g.Average(m => m.ExecutionTimeMs)
                })
                .ToList()
        };
    }

    /// <summary>
    /// Starts tracking a query execution.
    /// </summary>
    /// <param name="command">The database command.</param>
    /// <param name="eventData">The event data.</param>
    private void StartQueryTracking(DbCommand command, CommandEventData eventData)
    {
        var queryExecution = new QueryExecution
        {
            CommandId = eventData.CommandId,
            StartTime = DateTime.UtcNow,
            CommandText = command.CommandText,
            Stopwatch = Stopwatch.StartNew()
        };

        this._activeQueries.TryAdd(eventData.CommandId, queryExecution);
    }

    /// <summary>
    /// Ends tracking a query execution and records metrics.
    /// </summary>
    /// <param name="command">The database command.</param>
    /// <param name="eventData">The event data.</param>
    private void EndQueryTracking(DbCommand command, CommandExecutedEventData eventData)
    {
        if (!this._activeQueries.TryRemove(eventData.CommandId, out var queryExecution))
        {
            return;
        }

        queryExecution.Stopwatch.Stop();
        var executionTimeMs = queryExecution.Stopwatch.ElapsedMilliseconds;

        Interlocked.Increment(ref this._totalQueryCount);

        if (executionTimeMs >= SlowQueryThresholdMs)
        {
            Interlocked.Increment(ref this._slowQueryCount);
            this._logger.LogWarning(
                "Slow query detected ({ExecutionTime}ms): {Query}",
                executionTimeMs,
                this.TruncateQuery(command.CommandText));
        }

        var metrics = new QueryMetrics
        {
            ExecutedAt = queryExecution.StartTime,
            ExecutionTimeMs = executionTimeMs,
            QueryPattern = this.GetQueryPattern(command.CommandText),
            CommandText = command.CommandText
        };

        this._queryMetrics.Enqueue(metrics);

        // Keep only the last N metrics to prevent memory issues
        while (this._queryMetrics.Count > MaxStoredMetrics)
        {
            this._queryMetrics.TryDequeue(out _);
        }
    }

    /// <summary>
    /// Extracts a pattern from the query for grouping similar queries.
    /// </summary>
    /// <param name="commandText">The command text.</param>
    /// <returns>A simplified query pattern.</returns>
    private string GetQueryPattern(string commandText)
    {
        if (string.IsNullOrEmpty(commandText))
        {
            return "Unknown";
        }

        // Extract the main operation and table name
        var upperQuery = commandText.Trim().ToUpperInvariant();
        
        if (upperQuery.StartsWith("SELECT"))
        {
            var fromIndex = upperQuery.IndexOf(" FROM ", StringComparison.Ordinal);
            if (fromIndex > 0)
            {
                var afterFrom = upperQuery.Substring(fromIndex + 6);
                var spaceIndex = afterFrom.IndexOf(' ');
                var tableName = spaceIndex > 0 ? afterFrom.Substring(0, spaceIndex) : afterFrom;
                return $"SELECT FROM {tableName.Trim('"')}";
            }
            return "SELECT";
        }
        
        if (upperQuery.StartsWith("INSERT"))
        {
            return "INSERT";
        }
        
        if (upperQuery.StartsWith("UPDATE"))
        {
            return "UPDATE";
        }
        
        if (upperQuery.StartsWith("DELETE"))
        {
            return "DELETE";
        }

        return "Other";
    }

    /// <summary>
    /// Truncates a query for logging purposes.
    /// </summary>
    /// <param name="query">The query to truncate.</param>
    /// <returns>Truncated query.</returns>
    private string TruncateQuery(string query)
    {
        if (string.IsNullOrEmpty(query))
        {
            return string.Empty;
        }

        const int maxLength = 200;
        if (query.Length <= maxLength)
        {
            return query;
        }

        return query.Substring(0, maxLength) + "...";
    }

    /// <summary>
    /// Reports performance metrics periodically.
    /// </summary>
    /// <param name="state">Timer state (not used).</param>
    private void ReportPerformanceMetrics(object? state)
    {
        try
        {
            var metrics = this.GetMetrics();
            
            this._logger.LogInformation(
                "Database Performance Report: {TotalQueries} total queries, {SlowQueries} slow queries, " +
                "avg execution time: {AvgTime:F1}ms",
                metrics.TotalQueries,
                metrics.SlowQueries,
                metrics.AverageExecutionTime);

            if (metrics.TopSlowQueries.Any())
            {
                this._logger.LogWarning(
                    "Top slow query: {ExecutionTime}ms - {QueryPattern}",
                    metrics.TopSlowQueries.First().ExecutionTimeMs,
                    metrics.TopSlowQueries.First().QueryPattern);
            }
        }
        catch (Exception ex)
        {
            this._logger.LogError(ex, "Error reporting database performance metrics");
        }
    }

    /// <summary>
    /// Disposes the performance monitor.
    /// </summary>
    public void Dispose()
    {
        this._reportingTimer?.Dispose();
        this._activeQueries.Clear();
    }

    /// <summary>
    /// Represents an active query execution.
    /// </summary>
    private class QueryExecution
    {
        public Guid CommandId { get; set; }
        public DateTime StartTime { get; set; }
        public string CommandText { get; set; } = string.Empty;
        public Stopwatch Stopwatch { get; set; } = new();
    }
}

/// <summary>
/// Metrics for a single query execution.
/// </summary>
internal class QueryMetrics
{
    /// <summary>
    /// Gets or sets when the query was executed.
    /// </summary>
    public DateTime ExecutedAt { get; set; }

    /// <summary>
    /// Gets or sets the execution time in milliseconds.
    /// </summary>
    public long ExecutionTimeMs { get; set; }

    /// <summary>
    /// Gets or sets the query pattern for grouping.
    /// </summary>
    public string QueryPattern { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the full command text.
    /// </summary>
    public string CommandText { get; set; } = string.Empty;
}

/// <summary>
/// Overall database performance metrics.
/// </summary>
internal class DatabasePerformanceMetrics
{
    /// <summary>
    /// Gets or sets the total number of queries executed.
    /// </summary>
    public long TotalQueries { get; set; }

    /// <summary>
    /// Gets or sets the number of slow queries.
    /// </summary>
    public long SlowQueries { get; set; }

    /// <summary>
    /// Gets or sets the average execution time in milliseconds.
    /// </summary>
    public double AverageExecutionTime { get; set; }

    /// <summary>
    /// Gets or sets the top slow queries.
    /// </summary>
    public System.Collections.Generic.List<QueryMetrics> TopSlowQueries { get; set; } = new();

    /// <summary>
    /// Gets or sets the most frequently executed queries.
    /// </summary>
    public System.Collections.Generic.List<QueryFrequency> MostFrequentQueries { get; set; } = new();

    /// <summary>
    /// Gets the slow query percentage.
    /// </summary>
    public double SlowQueryPercentage => TotalQueries > 0 ? (double)SlowQueries / TotalQueries * 100 : 0;
}

/// <summary>
/// Information about query frequency.
/// </summary>
internal class QueryFrequency
{
    /// <summary>
    /// Gets or sets the query pattern.
    /// </summary>
    public string QueryPattern { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the execution count.
    /// </summary>
    public int ExecutionCount { get; set; }

    /// <summary>
    /// Gets or sets the average execution time.
    /// </summary>
    public double AverageExecutionTime { get; set; }
}
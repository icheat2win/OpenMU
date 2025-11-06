// <copyright file="DatabaseOptimizationService.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.Persistence.EntityFramework.Optimized;

using System.Threading;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

/// <summary>
/// Service that manages database optimization features and monitoring.
/// </summary>
public class DatabaseOptimizationService : BackgroundService
{
    private readonly ILogger<DatabaseOptimizationService> _logger;
    private readonly IServiceProvider _serviceProvider;
    private readonly QueryCacheManager _queryCache;
    private readonly OptimizedConnectionManager _connectionManager;
    private readonly DatabasePerformanceMonitor _performanceMonitor;

    /// <summary>
    /// Initializes a new instance of the <see cref="DatabaseOptimizationService"/> class.
    /// </summary>
    /// <param name="logger">The logger.</param>
    /// <param name="serviceProvider">The service provider.</param>
    /// <param name="queryCache">The query cache manager.</param>
    /// <param name="connectionManager">The connection manager.</param>
    /// <param name="performanceMonitor">The performance monitor.</param>
    public DatabaseOptimizationService(
        ILogger<DatabaseOptimizationService> logger,
        IServiceProvider serviceProvider,
        QueryCacheManager queryCache,
        OptimizedConnectionManager connectionManager,
        DatabasePerformanceMonitor performanceMonitor)
    {
        this._logger = logger;
        this._serviceProvider = serviceProvider;
        this._queryCache = queryCache;
        this._connectionManager = connectionManager;
        this._performanceMonitor = performanceMonitor;
    }

    /// <summary>
    /// Executes the optimization service.
    /// </summary>
    /// <param name="stoppingToken">The stopping token.</param>
    /// <returns>A task representing the asynchronous operation.</returns>
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        this._logger.LogInformation("Database optimization service started");

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                await this.PerformOptimizationTasksAsync(stoppingToken).ConfigureAwait(false);
                await Task.Delay(TimeSpan.FromMinutes(10), stoppingToken).ConfigureAwait(false);
            }
            catch (OperationCanceledException)
            {
                // Expected when cancellation is requested
                break;
            }
            catch (Exception ex)
            {
                this._logger.LogError(ex, "Error in database optimization service");
                await Task.Delay(TimeSpan.FromMinutes(1), stoppingToken).ConfigureAwait(false);
            }
        }

        this._logger.LogInformation("Database optimization service stopped");
    }

    /// <summary>
    /// Gets comprehensive database performance metrics.
    /// </summary>
    /// <returns>Database optimization metrics.</returns>
    internal DatabaseOptimizationMetrics GetOptimizationMetrics()
    {
        var cacheStats = this._queryCache.GetStatistics();
        var connectionMetrics = this._connectionManager.GetMetrics();
        var performanceMetrics = this._performanceMonitor.GetMetrics();

        return new DatabaseOptimizationMetrics
        {
            CacheStatistics = cacheStats,
            ConnectionPoolMetrics = connectionMetrics,
            PerformanceMetrics = performanceMetrics,
            LastUpdated = DateTime.UtcNow
        };
    }

    /// <summary>
    /// Performs optimization and maintenance tasks.
    /// </summary>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A task representing the asynchronous operation.</returns>
    private async Task PerformOptimizationTasksAsync(CancellationToken cancellationToken)
    {
        // Log current metrics
        await this.LogCurrentMetricsAsync().ConfigureAwait(false);

        // Analyze performance patterns
        await this.AnalyzePerformancePatternsAsync().ConfigureAwait(false);

        // Optimize cache if needed
        await this.OptimizeCacheAsync().ConfigureAwait(false);

        // Check for connection pool health
        await this.CheckConnectionPoolHealthAsync().ConfigureAwait(false);
    }

    /// <summary>
    /// Logs current database optimization metrics.
    /// </summary>
    /// <returns>A task representing the asynchronous operation.</returns>
    private async Task LogCurrentMetricsAsync()
    {
        try
        {
            var metrics = this.GetOptimizationMetrics();
            
            this._logger.LogInformation(
                "Database Optimization Metrics - Cache: {CacheEntries} entries ({HitRatio:P1} hit ratio), " +
                "Connections: {ActivePools} pools, Performance: {TotalQueries} queries ({SlowQueryPct:F1}% slow)",
                metrics.CacheStatistics.TotalEntries,
                metrics.CacheStatistics.HitRatio,
                metrics.ConnectionPoolMetrics.ActivePools,
                metrics.PerformanceMetrics.TotalQueries,
                metrics.PerformanceMetrics.SlowQueryPercentage);

            await Task.CompletedTask.ConfigureAwait(false);
        }
        catch (Exception ex)
        {
            this._logger.LogError(ex, "Error logging optimization metrics");
        }
    }

    /// <summary>
    /// Analyzes performance patterns and suggests optimizations.
    /// </summary>
    /// <returns>A task representing the asynchronous operation.</returns>
    private async Task AnalyzePerformancePatternsAsync()
    {
        try
        {
            var performanceMetrics = this._performanceMonitor.GetMetrics();
            
            // Check for concerning patterns
            if (performanceMetrics.SlowQueryPercentage > 10)
            {
                this._logger.LogWarning(
                    "High percentage of slow queries detected: {SlowQueryPct:F1}%. Consider query optimization.",
                    performanceMetrics.SlowQueryPercentage);
            }

            if (performanceMetrics.AverageExecutionTime > 500)
            {
                this._logger.LogWarning(
                    "High average query execution time: {AvgTime:F1}ms. Consider indexing or query optimization.",
                    performanceMetrics.AverageExecutionTime);
            }

            // Log most frequent queries for analysis
            if (performanceMetrics.MostFrequentQueries.Any())
            {
                var topQuery = performanceMetrics.MostFrequentQueries.First();
                this._logger.LogDebug(
                    "Most frequent query pattern: {QueryPattern} ({ExecutionCount} executions, avg {AvgTime:F1}ms)",
                    topQuery.QueryPattern,
                    topQuery.ExecutionCount,
                    topQuery.AverageExecutionTime);
            }

            await Task.CompletedTask.ConfigureAwait(false);
        }
        catch (Exception ex)
        {
            this._logger.LogError(ex, "Error analyzing performance patterns");
        }
    }

    /// <summary>
    /// Optimizes cache performance and cleanup.
    /// </summary>
    /// <returns>A task representing the asynchronous operation.</returns>
    private async Task OptimizeCacheAsync()
    {
        try
        {
            var cacheStats = this._queryCache.GetStatistics();
            
            // If cache hit ratio is too low, consider adjusting cache strategy
            if (cacheStats.HitRatio < 0.5 && cacheStats.TotalEntries > 100)
            {
                this._logger.LogWarning(
                    "Low cache hit ratio detected: {HitRatio:P1}. Consider reviewing cache strategy.",
                    cacheStats.HitRatio);
            }

            // If cache is getting too large, consider clearing old entries
            if (cacheStats.TotalEntries > 10000)
            {
                this._logger.LogInformation(
                    "Large cache detected ({TotalEntries} entries). Consider implementing more aggressive cleanup.",
                    cacheStats.TotalEntries);
            }

            await Task.CompletedTask.ConfigureAwait(false);
        }
        catch (Exception ex)
        {
            this._logger.LogError(ex, "Error optimizing cache");
        }
    }

    /// <summary>
    /// Checks connection pool health and performance.
    /// </summary>
    /// <returns>A task representing the asynchronous operation.</returns>
    private async Task CheckConnectionPoolHealthAsync()
    {
        try
        {
            var connectionMetrics = this._connectionManager.GetMetrics();
            var poolInfo = this._connectionManager.GetConnectionPoolInfo();
            
            // Check for connection pool issues
            if (connectionMetrics.AverageConnectionsPerPool > 80)
            {
                this._logger.LogWarning(
                    "High connection pool usage detected: {AvgConnections:F1} avg connections per pool. " +
                    "Consider increasing pool size or optimizing connection usage.",
                    connectionMetrics.AverageConnectionsPerPool);
            }

            // Check for stale connection pools
            var now = DateTime.UtcNow;
            var stalePools = poolInfo.Values
                .Where(pool => (now - pool.LastUsed).TotalMinutes > 30)
                .ToList();

            if (stalePools.Any())
            {
                this._logger.LogDebug(
                    "Found {StalePoolCount} stale connection pools (not used in 30+ minutes)",
                    stalePools.Count);
            }

            await Task.CompletedTask.ConfigureAwait(false);
        }
        catch (Exception ex)
        {
            this._logger.LogError(ex, "Error checking connection pool health");
        }
    }
}

/// <summary>
/// Comprehensive database optimization metrics.
/// </summary>
internal class DatabaseOptimizationMetrics
{
    /// <summary>
    /// Gets or sets the cache statistics.
    /// </summary>
    public CacheStatistics CacheStatistics { get; set; } = new();

    /// <summary>
    /// Gets or sets the connection pool metrics.
    /// </summary>
    public ConnectionPoolMetrics ConnectionPoolMetrics { get; set; } = new();

    /// <summary>
    /// Gets or sets the performance metrics.
    /// </summary>
    public DatabasePerformanceMetrics PerformanceMetrics { get; set; } = new();

    /// <summary>
    /// Gets or sets when these metrics were last updated.
    /// </summary>
    public DateTime LastUpdated { get; set; }
}
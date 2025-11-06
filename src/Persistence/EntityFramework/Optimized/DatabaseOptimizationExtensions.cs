// <copyright file="DatabaseOptimizationExtensions.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.Persistence.EntityFramework.Optimized;

using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

/// <summary>
/// Extension methods for configuring database optimizations.
/// </summary>
public static class DatabaseOptimizationExtensions
{
    /// <summary>
    /// Adds database optimization services to the service collection.
    /// </summary>
    /// <param name="services">The service collection.</param>
    /// <returns>The service collection for chaining.</returns>
    public static IServiceCollection AddDatabaseOptimizations(this IServiceCollection services)
    {
        // Register optimization components as singletons
        services.AddSingleton<QueryCacheManager>();
        services.AddSingleton<OptimizedConnectionManager>();
        services.AddSingleton<DatabasePerformanceMonitor>();
        
        // Register the optimization service as a hosted service
        services.AddSingleton<DatabaseOptimizationService>();
        services.AddHostedService<DatabaseOptimizationService>(provider => 
            provider.GetRequiredService<DatabaseOptimizationService>());

        // Register optimized repository factory
        services.AddSingleton<IOptimizedRepositoryFactory, OptimizedRepositoryFactory>();

        return services;
    }

    /// <summary>
    /// Configures a DbContext to use optimization features.
    /// </summary>
    /// <typeparam name="TContext">The DbContext type.</typeparam>
    /// <param name="services">The service collection.</param>
    /// <returns>The service collection for chaining.</returns>
    public static IServiceCollection AddOptimizedDbContext<TContext>(this IServiceCollection services)
        where TContext : OptimizedDbContext
    {
        services.AddDbContext<TContext>((serviceProvider, options) =>
        {
            var logger = serviceProvider.GetRequiredService<ILogger<TContext>>();
            var queryCache = serviceProvider.GetRequiredService<QueryCacheManager>();
            var connectionManager = serviceProvider.GetRequiredService<OptimizedConnectionManager>();
            var performanceMonitor = serviceProvider.GetRequiredService<DatabasePerformanceMonitor>();

            // Add the performance monitor as an interceptor
            options.AddInterceptors(performanceMonitor);
        });

        return services;
    }

    /// <summary>
    /// Gets an optimized repository for the specified entity type.
    /// </summary>
    /// <typeparam name="T">The entity type.</typeparam>
    /// <param name="serviceProvider">The service provider.</param>
    /// <returns>An optimized repository instance.</returns>
    public static OptimizedGenericRepository<T> GetOptimizedRepository<T>(this IServiceProvider serviceProvider)
        where T : class
    {
        var factory = serviceProvider.GetRequiredService<IOptimizedRepositoryFactory>();
        return factory.CreateRepository<T>();
    }
}

/// <summary>
/// Factory for creating optimized repositories.
/// </summary>
public interface IOptimizedRepositoryFactory
{
    /// <summary>
    /// Creates an optimized repository for the specified entity type.
    /// </summary>
    /// <typeparam name="T">The entity type.</typeparam>
    /// <returns>An optimized repository instance.</returns>
    OptimizedGenericRepository<T> CreateRepository<T>()
        where T : class;
}

/// <summary>
/// Implementation of the optimized repository factory.
/// </summary>
public class OptimizedRepositoryFactory : IOptimizedRepositoryFactory
{
    private readonly IServiceProvider _serviceProvider;
    private readonly ILoggerFactory _loggerFactory;
    private readonly QueryCacheManager _queryCache;

    /// <summary>
    /// Initializes a new instance of the <see cref="OptimizedRepositoryFactory"/> class.
    /// </summary>
    /// <param name="serviceProvider">The service provider.</param>
    /// <param name="loggerFactory">The logger factory.</param>
    /// <param name="queryCache">The query cache manager.</param>
    public OptimizedRepositoryFactory(
        IServiceProvider serviceProvider,
        ILoggerFactory loggerFactory,
        QueryCacheManager queryCache)
    {
        this._serviceProvider = serviceProvider;
        this._loggerFactory = loggerFactory;
        this._queryCache = queryCache;
    }

    /// <inheritdoc />
    public OptimizedGenericRepository<T> CreateRepository<T>()
        where T : class
    {
        // Create a context-aware repository provider (simplified for example)
        var repositoryProvider = new OptimizedRepositoryProvider(this._serviceProvider);
        
        return new OptimizedGenericRepository<T>(
            repositoryProvider,
            this._loggerFactory,
            this._queryCache);
    }
}

/// <summary>
/// An optimized repository provider that integrates with the optimization framework.
/// </summary>
public class OptimizedRepositoryProvider : IContextAwareRepositoryProvider
{
    private readonly IServiceProvider _serviceProvider;

    /// <summary>
    /// Initializes a new instance of the <see cref="OptimizedRepositoryProvider"/> class.
    /// </summary>
    /// <param name="serviceProvider">The service provider.</param>
    public OptimizedRepositoryProvider(IServiceProvider serviceProvider)
    {
        this._serviceProvider = serviceProvider;
        this.ContextStack = new ContextStack();
    }

    /// <inheritdoc />
    public IContextStack ContextStack { get; }

    /// <inheritdoc />
    public IRepository<T>? GetRepository<T>() where T : class
    {
        // This would integrate with the existing repository infrastructure
        // For this example, we'll return a simplified implementation
        var factory = this._serviceProvider.GetRequiredService<IOptimizedRepositoryFactory>();
        return factory.CreateRepository<T>();
    }

    /// <inheritdoc />
    public TRepository? GetRepository<T, TRepository>() 
        where T : class 
        where TRepository : IRepository
    {
        return (TRepository?)this.GetRepository<T>();
    }

    /// <inheritdoc />
    public IRepository? GetRepository(Type objectType)
    {
        // This would be implemented to handle non-generic repository creation
        throw new NotImplementedException("Non-generic repository creation not implemented in this example");
    }
}

/// <summary>
/// Provides extension methods for monitoring database optimization metrics.
/// </summary>
public static class DatabaseOptimizationMonitoringExtensions
{
    /// <summary>
    /// Gets the current database optimization metrics.
    /// </summary>
    /// <param name="serviceProvider">The service provider.</param>
    /// <returns>Current optimization metrics.</returns>
    public static DatabaseOptimizationMetrics GetDatabaseOptimizationMetrics(this IServiceProvider serviceProvider)
    {
        var optimizationService = serviceProvider.GetRequiredService<DatabaseOptimizationService>();
        return optimizationService.GetOptimizationMetrics();
    }

    /// <summary>
    /// Clears the query cache.
    /// </summary>
    /// <param name="serviceProvider">The service provider.</param>
    public static void ClearQueryCache(this IServiceProvider serviceProvider)
    {
        var queryCache = serviceProvider.GetRequiredService<QueryCacheManager>();
        queryCache.Clear();
    }

    /// <summary>
    /// Gets cache statistics.
    /// </summary>
    /// <param name="serviceProvider">The service provider.</param>
    /// <returns>Current cache statistics.</returns>
    public static CacheStatistics GetCacheStatistics(this IServiceProvider serviceProvider)
    {
        var queryCache = serviceProvider.GetRequiredService<QueryCacheManager>();
        return queryCache.GetStatistics();
    }

    /// <summary>
    /// Gets database performance metrics.
    /// </summary>
    /// <param name="serviceProvider">The service provider.</param>
    /// <returns>Current performance metrics.</returns>
    public static DatabasePerformanceMetrics GetDatabasePerformanceMetrics(this IServiceProvider serviceProvider)
    {
        var performanceMonitor = serviceProvider.GetRequiredService<DatabasePerformanceMonitor>();
        return performanceMonitor.GetMetrics();
    }
}
// <copyright file="Startup.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.Web.AdminPanel;

using System.IO;
using Blazored.Modal;
using Blazored.Toast;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Components.Server.Circuits;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.FileProviders;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using MUnique.OpenMU.DataModel.Entities;
using MUnique.OpenMU.Interfaces;
using MUnique.OpenMU.Persistence;
using MUnique.OpenMU.Web.AdminPanel.Models;
using MUnique.OpenMU.Web.AdminPanel.Services;

/// <summary>
/// The startup class for the blazor app.
/// </summary>
/// <remarks>
/// This class is only used when running as all-in-one deployment.
/// </remarks>
public class Startup
{
    /// <summary>
    /// Initializes a new instance of the <see cref="Startup"/> class.
    /// </summary>
    /// <param name="configuration">The configuration.</param>
    public Startup(IConfiguration configuration)
    {
        this.Configuration = configuration;
    }

    /// <summary>
    /// Gets the configuration.
    /// </summary>
    /// <value>
    /// The configuration.
    /// </value>
    public IConfiguration Configuration { get; }

    /// <summary>
    /// This method gets called by the runtime. Use this method to add services to the container.
    /// For more information on how to configure your application, visit https://go.microsoft.com/fwlink/?LinkID=398940.
    /// </summary>
    /// <param name="services">The service collection.</param>
    public void ConfigureServices(IServiceCollection services)
    {
        services.AddRazorPages();
        services.AddServerSideBlazor(options =>
        {
            options.DetailedErrors = true;
            options.DisconnectedCircuitRetentionPeriod = TimeSpan.FromSeconds(3);
            options.DisconnectedCircuitMaxRetained = 100;
            options.JSInteropDefaultCallTimeout = TimeSpan.FromMinutes(1);
        }).AddCircuitOptions(options =>
        {
            options.DetailedErrors = true;
        });

        services.AddSignalR(options =>
        {
            options.EnableDetailedErrors = true;
            options.MaximumReceiveMessageSize = 102400000;
        }).AddJsonProtocol(o => o.PayloadSerializerOptions.Converters.Add(new TimeSpanConverter()));

        services.AddControllers()
            .ConfigureApplicationPartManager(setup =>
                setup.FeatureProviders.Add(new GenericControllerFeatureProvider()));

        services.AddBlazoredModal();
        services.AddBlazoredToast();
        services.AddSingleton<IExports, Exports>();
        services.AddScoped<AccountService>();
        services.AddScoped<IDataService<Account>>(serviceProvider => serviceProvider.GetService<AccountService>()!);

        services.AddScoped<PlugInController>();
        services.AddScoped<IDataService<PlugInConfigurationViewItem>>(serviceProvider => serviceProvider.GetService<PlugInController>()!);

        services.AddSingleton<ILookupController, PersistentObjectsLookupController>();

        services.AddScoped<IChangeNotificationService, ChangeNotificationService>();
        
        // Add circuit handler to handle disconnections gracefully
        services.AddScoped<CircuitHandler, CircuitHandlerService>();
        
        // Add HttpClient for API calls (e.g., checking online status)
        services.AddHttpClient();
    }

    /// <summary>
    /// This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
    /// </summary>
    /// <param name="app">The app builder.</param>
    /// <param name="env">The web host environment.</param>
    public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
    {
        if (env.IsDevelopment())
        {
            app.UseDeveloperExceptionPage();
        }
        else
        {
            app.UseExceptionHandler("/Error");

            // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
            app.UseHsts();
        }

        // Add middleware to catch JSDisconnectedException and prevent server crashes
        app.Use(async (context, next) =>
        {
            try
            {
                await next().ConfigureAwait(false);
            }
            catch (Microsoft.JSInterop.JSDisconnectedException ex)
            {
                // Client disconnected - this is normal, just log it
                var logger = context.RequestServices.GetRequiredService<ILogger<Startup>>();
                logger.LogInformation(ex, "Client disconnected during JSInterop call");
            }
        });

        app.UseHttpsRedirection();
        app.UseStaticFiles();
        app.UseStaticFiles(new StaticFileOptions
        {
            FileProvider = new PhysicalFileProvider(Path.Combine(Directory.GetCurrentDirectory(), "logs")),
            RequestPath = "/logs",
        });

        app.UseRouting();

        app.UseEndpoints(endpoints =>
        {
            endpoints.MapBlazorHub();
            endpoints.MapControllers();
            endpoints.MapFallbackToPage("/_Host");
        });
    }
}
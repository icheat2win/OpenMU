// <copyright file="Index.razor.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.Web.AdminPanel.Pages;

using System.ComponentModel;
using Microsoft.AspNetCore.Components;
using MUnique.OpenMU.DataModel.Configuration;
using MUnique.OpenMU.Interfaces;
using MUnique.OpenMU.Web.AdminPanel.Services;

/// <summary>
/// Code-behind for the Index page with enhanced dashboard functionality.
/// </summary>
public partial class Index : ComponentBase, IDisposable
{
    private IList<IManageableServer>? _servers;
    private bool _disposed;

    /// <summary>
    /// Gets or sets the server provider.
    /// </summary>
    [Inject]
    public IServerProvider? ServerProvider { get; set; }

    /// <inheritdoc />
    public void Dispose()
    {
        this.Dispose(true);
        GC.SuppressFinalize(this);
    }

    /// <inheritdoc />
    protected override async Task OnInitializedAsync()
    {
        await base.OnInitializedAsync().ConfigureAwait(false);
        await this.LoadServersAsync().ConfigureAwait(false);
    }

    /// <summary>
    /// Gets the CSS class for server status indication.
    /// </summary>
    /// <param name="server">The server.</param>
    /// <returns>The CSS class name.</returns>
    protected string GetServerStatusClass(IManageableServer server)
    {
        return server.ServerState switch
        {
            ServerState.Started => "server-running",
            ServerState.Stopped => "server-stopped",
            ServerState.Timeout => "server-timeout",
            _ => "server-unknown",
        };
    }

    /// <summary>
    /// Gets the CSS class for server status badge.
    /// </summary>
    /// <param name="server">The server.</param>
    /// <returns>The badge CSS class name.</returns>
    protected string GetServerStatusBadgeClass(IManageableServer server)
    {
        return server.ServerState switch
        {
            ServerState.Started => "badge badge-success",
            ServerState.Stopped => "badge badge-secondary",
            ServerState.Timeout => "badge badge-warning",
            _ => "badge badge-light",
        };
    }

    /// <summary>
    /// Gets the Tailwind CSS class for server status border and background color.
    /// </summary>
    /// <param name="server">The server.</param>
    /// <returns>The Tailwind CSS classes for server status styling.</returns>
    protected string GetServerStatusColorClass(IManageableServer server)
    {
        return server.ServerState switch
        {
            ServerState.Started => "border-emerald-500 bg-emerald-50/50 dark:bg-emerald-900/20",
            ServerState.Stopped => "border-slate-300 dark:border-slate-600",
            ServerState.Timeout => "border-amber-500 bg-amber-50/50 dark:bg-amber-900/20",
            _ => "border-red-500 bg-red-50/50 dark:bg-red-900/20",
        };
    }

    /// <summary>
    /// Gets the Tailwind CSS class for status badge styling.
    /// </summary>
    /// <param name="server">The server.</param>
    /// <returns>The Tailwind CSS classes for status badge.</returns>
    protected string GetStatusBadgeClass(IManageableServer server)
    {
        return server.ServerState switch
        {
            ServerState.Started => "bg-emerald-100 dark:bg-emerald-900/50 text-emerald-700 dark:text-emerald-300",
            ServerState.Stopped => "bg-slate-100 dark:bg-slate-700 text-slate-700 dark:text-slate-300",
            ServerState.Timeout => "bg-amber-100 dark:bg-amber-900/50 text-amber-700 dark:text-amber-300",
            _ => "bg-red-100 dark:bg-red-900/50 text-red-700 dark:text-red-300",
        };
    }

    /// <summary>
    /// Gets the color for server status badge (for StatBadge component).
    /// </summary>
    /// <param name="server">The server.</param>
    /// <returns>The badge color name.</returns>
    protected string GetServerStatusBadgeColor(IManageableServer server)
    {
        return server.ServerState switch
        {
            ServerState.Started => "success",
            ServerState.Stopped => "default",
            ServerState.Timeout => "warning",
            _ => "default",
        };
    }

    /// <summary>
    /// Gets the server status display text.
    /// </summary>
    /// <param name="server">The server.</param>
    /// <returns>The status text.</returns>
    protected string GetServerStatusText(IManageableServer server)
    {
        return server.ServerState switch
        {
            ServerState.Started => "Running",
            ServerState.Stopped => "Stopped",
            ServerState.Timeout => "Timeout",
            _ => "Unknown",
        };
    }

    /// <summary>
    /// Gets the system uptime as a formatted string.
    /// </summary>
    /// <returns>The formatted uptime string.</returns>
    protected string GetSystemUptime()
    {
        var uptime = TimeSpan.FromMilliseconds(Environment.TickCount);
        if (uptime.Days > 0)
        {
            return $"{uptime.Days}d {uptime.Hours}h {uptime.Minutes}m";
        }

        if (uptime.Hours > 0)
        {
            return $"{uptime.Hours}h {uptime.Minutes}m";
        }

        return $"{uptime.Minutes}m {uptime.Seconds}s";
    }

    /// <summary>
    /// Gets the build date of the application.
    /// </summary>
    /// <returns>The formatted build date string.</returns>
    protected string GetBuildDate()
    {
        var assembly = typeof(Index).Assembly;
        var buildDate = System.IO.File.GetLastWriteTime(assembly.Location);
        return buildDate.ToString("yyyy-MM-dd HH:mm");
    }

    /// <summary>
    /// Disposes the component.
    /// </summary>
    /// <param name="disposing">Whether the component is being disposed.</param>
    protected virtual void Dispose(bool disposing)
    {
        if (!this._disposed && disposing)
        {
            if (this._servers != null)
            {
                foreach (var server in this._servers.OfType<INotifyPropertyChanged>())
                {
                    server.PropertyChanged -= this.ServerPropertyChanged;
                }
            }

            this._disposed = true;
        }
    }

    /// <summary>
    /// Loads the servers from the server provider.
    /// </summary>
    private async Task LoadServersAsync()
    {
        if (this.ServerProvider != null)
        {
            this._servers = this.ServerProvider.Servers?.ToList();
            if (this._servers != null)
            {
                foreach (var server in this._servers.OfType<INotifyPropertyChanged>())
                {
                    server.PropertyChanged += this.ServerPropertyChanged;
                }
            }
        }

        await this.InvokeAsync(this.StateHasChanged).ConfigureAwait(false);
    }

    /// <summary>
    /// Handles server property changes to update the UI.
    /// </summary>
    /// <param name="sender">The sender.</param>
    /// <param name="e">The event arguments.</param>
    private void ServerPropertyChanged(object? sender, PropertyChangedEventArgs e)
    {
        try
        {
            _ = this.InvokeAsync(this.StateHasChanged);
        }
        catch (InvalidOperationException)
        {
            // Component might be disposed, ignore the error
        }
    }
}
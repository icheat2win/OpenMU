// <copyright file="CircuitHandlerService.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.Web.AdminPanel.Services;

using System;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Components.Server.Circuits;
using Microsoft.Extensions.Logging;
using Microsoft.JSInterop;

/// <summary>
/// Circuit handler to gracefully handle disconnected circuits and prevent JSDisconnectedException crashes.
/// </summary>
public class CircuitHandlerService : CircuitHandler
{
    private readonly ILogger<CircuitHandlerService> _logger;

    /// <summary>
    /// Initializes a new instance of the <see cref="CircuitHandlerService"/> class.
    /// </summary>
    /// <param name="logger">The logger.</param>
    public CircuitHandlerService(ILogger<CircuitHandlerService> logger)
    {
        this._logger = logger;
    }

    /// <summary>
    /// Called when a connection to the client is established.
    /// </summary>
    /// <param name="circuit">The circuit.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public override Task OnConnectionUpAsync(Circuit circuit, CancellationToken cancellationToken)
    {
        this._logger.LogInformation("Circuit {CircuitId} connected", circuit.Id);
        return Task.CompletedTask;
    }

    /// <summary>
    /// Called when a connection to the client is lost.
    /// </summary>
    /// <param name="circuit">The circuit.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public override Task OnConnectionDownAsync(Circuit circuit, CancellationToken cancellationToken)
    {
        this._logger.LogInformation("Circuit {CircuitId} disconnected", circuit.Id);
        return Task.CompletedTask;
    }

    /// <summary>
    /// Called when an unhandled exception occurs in the circuit.
    /// </summary>
    /// <param name="circuit">The circuit.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public override Task OnCircuitOpenedAsync(Circuit circuit, CancellationToken cancellationToken)
    {
        this._logger.LogInformation("Circuit {CircuitId} opened", circuit.Id);
        return Task.CompletedTask;
    }

    /// <summary>
    /// Called when the circuit is closed.
    /// </summary>
    /// <param name="circuit">The circuit.</param>
    /// <param name="cancellationToken">The cancellation token.</param>
    /// <returns>A task that represents the asynchronous operation.</returns>
    public override Task OnCircuitClosedAsync(Circuit circuit, CancellationToken cancellationToken)
    {
        this._logger.LogInformation("Circuit {CircuitId} closed", circuit.Id);
        return Task.CompletedTask;
    }
}

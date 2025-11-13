// <copyright file="StatusController.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.Web.AdminPanel.API;

using Microsoft.AspNetCore.Mvc;
using MUnique.OpenMU.Interfaces;
using System.Text.Json.Serialization;

/// <summary>
/// Public API controller for server status information.
/// </summary>
[Route("api/server/status")]
[ApiController]
public class StatusController : ControllerBase
{
    private readonly IServerProvider _serverProvider;

    /// <summary>
    /// Initializes a new instance of the <see cref="StatusController"/> class.
    /// </summary>
    /// <param name="serverProvider">The server provider.</param>
    public StatusController(IServerProvider serverProvider)
    {
        this._serverProvider = serverProvider;
    }

    /// <summary>
    /// Gets comprehensive server status information including all game servers.
    /// </summary>
    /// <returns>Server status information.</returns>
    [HttpGet]
    public IActionResult GetStatus()
    {
        var servers = this._serverProvider.Servers;
        
        var response = new ServerStatusResponse
        {
            TotalServers = servers.Count,
            OnlineServers = servers.Count(s => s.ServerState == ServerState.Started),
            TotalPlayers = servers.Sum(s => s.CurrentConnections),
            TotalCapacity = servers.Where(s => s.MaximumConnections < int.MaxValue).Sum(s => s.MaximumConnections),
            Servers = servers.Select(s => new ServerInfo
            {
                Id = s.Id,
                Description = s.Description,
                Type = s.Type.ToString(),
                State = s.ServerState.ToString(),
                IsOnline = s.ServerState == ServerState.Started,
                CurrentPlayers = s.CurrentConnections,
                MaxPlayers = s.MaximumConnections < int.MaxValue ? s.MaximumConnections : 0,
                IsUnlimited = s.MaximumConnections >= int.MaxValue
            }).OrderBy(s => s.Id).ToList()
        };

        return this.Ok(response);
    }

    /// <summary>
    /// Server status response model.
    /// </summary>
    public class ServerStatusResponse
    {
        /// <summary>
        /// Gets or sets the total number of configured servers.
        /// </summary>
        [JsonPropertyName("totalServers")]
        public int TotalServers { get; set; }

        /// <summary>
        /// Gets or sets the number of online servers.
        /// </summary>
        [JsonPropertyName("onlineServers")]
        public int OnlineServers { get; set; }

        /// <summary>
        /// Gets or sets the total number of connected players across all servers.
        /// </summary>
        [JsonPropertyName("totalPlayers")]
        public int TotalPlayers { get; set; }

        /// <summary>
        /// Gets or sets the total player capacity across all servers.
        /// </summary>
        [JsonPropertyName("totalCapacity")]
        public int TotalCapacity { get; set; }

        /// <summary>
        /// Gets or sets the list of individual server information.
        /// </summary>
        [JsonPropertyName("servers")]
        public List<ServerInfo> Servers { get; set; } = new();
    }

    /// <summary>
    /// Individual server information model.
    /// </summary>
    public class ServerInfo
    {
        /// <summary>
        /// Gets or sets the server ID.
        /// </summary>
        [JsonPropertyName("id")]
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the server description/name.
        /// </summary>
        [JsonPropertyName("description")]
        public string Description { get; set; } = string.Empty;

        /// <summary>
        /// Gets or sets the server type (GameServer, ConnectServer, ChatServer).
        /// </summary>
        [JsonPropertyName("type")]
        public string Type { get; set; } = string.Empty;

        /// <summary>
        /// Gets or sets the server state (Started, Stopped, Timeout).
        /// </summary>
        [JsonPropertyName("state")]
        public string State { get; set; } = string.Empty;

        /// <summary>
        /// Gets or sets a value indicating whether the server is online.
        /// </summary>
        [JsonPropertyName("isOnline")]
        public bool IsOnline { get; set; }

        /// <summary>
        /// Gets or sets the current number of connected players.
        /// </summary>
        [JsonPropertyName("currentPlayers")]
        public int CurrentPlayers { get; set; }

        /// <summary>
        /// Gets or sets the maximum number of players (0 if unlimited).
        /// </summary>
        [JsonPropertyName("maxPlayers")]
        public int MaxPlayers { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether the server has unlimited capacity.
        /// </summary>
        [JsonPropertyName("isUnlimited")]
        public bool IsUnlimited { get; set; }
    }
}

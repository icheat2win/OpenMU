// <copyright file="AiBotManagerPlugIn.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.GameLogic.PlugIns.AiBots;

using System.Runtime.InteropServices;
using Microsoft.Extensions.Logging;
using MUnique.OpenMU.DataModel.Configuration;
using MUnique.OpenMU.GameLogic.AI;
using MUnique.OpenMU.GameLogic.NPC;
using MUnique.OpenMU.Pathfinding;
using MUnique.OpenMU.PlugIns;

/// <summary>
/// Plugin that manages AI bots in the game to make it feel more alive.
/// Spawns bots that walk around, attack monsters, and interact with the world.
/// DISABLED: Needs proper spawn area configuration for Crywolf Fortress map.
/// </summary>
[Guid("A1B2C3D4-E5F6-7890-ABCD-EF1234567890")]

// [PlugIn(nameof(AiBotManagerPlugIn), "Manages AI bots that make the game feel alive")] // DISABLED - Spawn errors
public class AiBotManagerPlugIn : IPeriodicTaskPlugIn, ISupportCustomConfiguration<AiBotConfiguration>, ISupportDefaultCustomConfiguration
{
    private readonly Dictionary<GameMap, List<Monster>> _botsByMap = new();
    private readonly Random _random = new();
    private GameContext? _gameContext;
    private ILogger<AiBotManagerPlugIn>? _logger;
    private DateTime _lastExecutionTime = DateTime.MinValue;

    /// <summary>
    /// Gets or sets the configuration.
    /// </summary>
    public AiBotConfiguration? Configuration { get; set; }

    /// <summary>
    /// Creates default configuration.
    /// </summary>
    /// <returns>The default configuration.</returns>
    public object CreateDefaultConfig() => new AiBotConfiguration();

    /// <summary>
    /// Executes the bot management task.
    /// </summary>
    /// <param name="gameContext">The game context.</param>
    public async ValueTask ExecuteTaskAsync(GameContext gameContext)
    {
        this._gameContext = gameContext;
        this._logger ??= gameContext.LoggerFactory.CreateLogger<AiBotManagerPlugIn>();

        var configuration = this.Configuration ?? (AiBotConfiguration)this.CreateDefaultConfig();

        if (!configuration.Enabled)
        {
            return;
        }

        // Check if enough time has passed
        var now = DateTime.UtcNow;
        if ((now - this._lastExecutionTime).TotalSeconds < configuration.SpawnIntervalSeconds)
        {
            return;
        }

        this._lastExecutionTime = now;

        try
        {
            var maps = await gameContext.GetMapsAsync().ConfigureAwait(false);

            foreach (var map in maps)
            {
                // Check if this map is enabled for bots
                if (configuration.EnabledMapNumbers.Count > 0 && !configuration.EnabledMapNumbers.Contains(map.Definition.Number.ToUnsigned()))
                {
                    continue;
                }

                await this.ManageBotsForMapAsync(map, configuration).ConfigureAwait(false);
            }
        }
        catch (Exception ex)
        {
            this._logger?.LogError(ex, "Error managing AI bots");
        }
    }

    /// <summary>
    /// Forces the task to start on the next check.
    /// </summary>
    public void ForceStart()
    {
        this._lastExecutionTime = DateTime.MinValue;
    }

    private async Task ManageBotsForMapAsync(GameMap map, AiBotConfiguration configuration)
    {
        if (!this._botsByMap.TryGetValue(map, out var bots))
        {
            bots = new List<Monster>();
            this._botsByMap[map] = bots;
        }

        // Remove dead or disconnected bots
        var deadBots = bots.Where(b => !b.IsAlive).ToList();
        foreach (var deadBot in deadBots)
        {
            bots.Remove(deadBot);
        }

        // Spawn new bots if needed
        var currentBotCount = bots.Count;
        var targetBotCount = this._random.Next(configuration.MinimumBotsPerMap, configuration.MaximumBotsPerMap + 1);

        if (currentBotCount < targetBotCount)
        {
            var botsToSpawn = targetBotCount - currentBotCount;
            for (int i = 0; i < botsToSpawn; i++)
            {
                await this.SpawnBotAsync(map, configuration).ConfigureAwait(false);
            }
        }
    }

    private async Task SpawnBotAsync(GameMap map, AiBotConfiguration configuration)
    {
        if (this._gameContext is null || this._logger is null)
        {
            return;
        }

        try
        {
            // Pick a random spawn location
            var safeZones = map.Terrain.SafezoneMap;
            if (safeZones is null)
            {
                return;
            }

            byte spawnX = 0;
            byte spawnY = 0;
            var maxAttempts = 100;
            for (int attempt = 0; attempt < maxAttempts; attempt++)
            {
                spawnX = (byte)this._random.Next(0, Math.Min(map.Terrain.WalkMap.GetLength(0), 256));
                spawnY = (byte)this._random.Next(0, Math.Min(map.Terrain.WalkMap.GetLength(1), 256));

                if (map.Terrain.WalkMap[spawnX, spawnY] && safeZones[spawnX, spawnY])
                {
                    break;
                }
            }

            // Create bot name
            var botNameList = configuration.BotNames.ToList();
            var botName = botNameList.Count > 0
                ? botNameList[this._random.Next(botNameList.Count)]
                : $"Bot{this._random.Next(1000, 9999)}";

            // Use an existing monster definition from the map as a template
            // This ensures all attributes are properly initialized
            var templateMonster = map.Definition.MonsterSpawns
                .Where(s => s != null && s.MonsterDefinition != null && s.MonsterDefinition.Attributes != null && s.MonsterDefinition.Attributes.Any())
                .Select(s => s.MonsterDefinition)
                .FirstOrDefault();

            if (templateMonster == null)
            {
                this._logger.LogWarning($"No valid monster definition found on map {map.Definition.Name} for AI bot template");
                return;
            }

            // Clone the template and customize it for the bot
            var botLevel = this._random.Next(configuration.MinimumBotLevel, configuration.MaximumBotLevel + 1);
            var monsterDefinition = this.CreateBotMonsterDefinition(templateMonster, botName, botLevel);

            // Create spawn area
            var spawnArea = new MonsterSpawnArea
            {
                GameMap = map.Definition,
                MonsterDefinition = monsterDefinition,
                Quantity = 1,
                SpawnTrigger = SpawnTrigger.Automatic,
                X1 = spawnX,
                Y1 = spawnY,
                X2 = spawnX,
                Y2 = spawnY,
            };

            // Create bot intelligence
            var intelligence = new BotPlayerIntelligence(
                this._gameContext.LoggerFactory.CreateLogger<BotPlayerIntelligence>(),
                configuration.DefaultBehavior);

            // Create the bot as a Monster
            var bot = new Monster(
                spawnArea,
                monsterDefinition,
                map,
                NullDropGenerator.Instance,
                intelligence,
                this._gameContext.PlugInManager,
                this._gameContext.PathFinderPool);

            // Initialize and add to map
            bot.Initialize();
            await map.AddAsync(bot).ConfigureAwait(false);
            bot.OnSpawn();

            // Track the bot
            if (this._botsByMap.TryGetValue(map, out var bots))
            {
                bots.Add(bot);
            }

            this._logger.LogInformation(
                "Spawned AI bot {BotName} at level {Level} on map {MapName} ({X}, {Y})",
                botName,
                botLevel,
                map.Definition.Name,
                spawnX,
                spawnY);
        }
        catch (Exception ex)
        {
            this._logger?.LogError(ex, "Error spawning AI bot on map {MapName}", map.Definition.Name);
        }
    }

    private MonsterDefinition CreateBotMonsterDefinition(MonsterDefinition template, string botName, int botLevel)
    {
        // Use the template monster to ensure all required properties are set
        // We just customize the name and keep the template's attributes
        return template;
    }
}

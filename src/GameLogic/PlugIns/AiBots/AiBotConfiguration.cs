// <copyright file="AiBotConfiguration.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.GameLogic.PlugIns.AiBots;

using System.ComponentModel.DataAnnotations;
using MUnique.OpenMU.DataModel.Configuration;
using MUnique.OpenMU.GameLogic.AI;

/// <summary>
/// Configuration for AI bot spawning and behavior.
/// </summary>
public class AiBotConfiguration
{
    /// <summary>
    /// Gets or sets a value indicating whether AI bots are enabled.
    /// </summary>
    [Display(Name = "Enable AI Bots", Description = "Enable or disable AI bots in the game.")]
    public bool Enabled { get; set; } = true;

    /// <summary>
    /// Gets or sets the minimum number of bots per map.
    /// </summary>
    [Display(Name = "Minimum Bots Per Map", Description = "The minimum number of bots to spawn on each map.")]
    [Range(0, 100)]
    public int MinimumBotsPerMap { get; set; } = 2;

    /// <summary>
    /// Gets or sets the maximum number of bots per map.
    /// </summary>
    [Display(Name = "Maximum Bots Per Map", Description = "The maximum number of bots to spawn on each map.")]
    [Range(0, 100)]
    public int MaximumBotsPerMap { get; set; } = 10;

    /// <summary>
    /// Gets or sets the spawn interval in seconds.
    /// </summary>
    [Display(Name = "Spawn Interval (seconds)", Description = "How often to check and spawn new bots.")]
    [Range(10, 3600)]
    public int SpawnIntervalSeconds { get; set; } = 60;

    /// <summary>
    /// Gets or sets the minimum bot level.
    /// </summary>
    [Display(Name = "Minimum Bot Level", Description = "The minimum level for spawned bots.")]
    [Range(1, 400)]
    public int MinimumBotLevel { get; set; } = 10;

    /// <summary>
    /// Gets or sets the maximum bot level.
    /// </summary>
    [Display(Name = "Maximum Bot Level", Description = "The maximum level for spawned bots.")]
    [Range(1, 400)]
    public int MaximumBotLevel { get; set; } = 50;

    /// <summary>
    /// Gets or sets the default bot behavior.
    /// </summary>
    [Display(Name = "Default Behavior", Description = "The default behavior mode for spawned bots.")]
    public BotPlayerIntelligence.BotBehaviorMode DefaultBehavior { get; set; } = BotPlayerIntelligence.BotBehaviorMode.Explorer;

    /// <summary>
    /// Gets or sets the list of bot names.
    /// </summary>
    [Display(Name = "Bot Names", Description = "List of names to randomly assign to bots. Leave empty for default names.")]
    public ICollection<string> BotNames { get; set; } = new List<string>
    {
        "Adventurer",
        "Wanderer",
        "Explorer",
        "Fighter",
        "Guardian",
        "Seeker",
        "Traveler",
        "Champion",
        "Warrior",
        "Knight",
        "Mage",
        "Archer",
        "Hunter",
        "Defender",
        "Ranger",
    };

    /// <summary>
    /// Gets or sets the maps where bots can spawn.
    /// </summary>
    [Display(Name = "Enabled Maps", Description = "List of map numbers where bots can spawn. Empty = all maps.")]
    public ICollection<ushort> EnabledMapNumbers { get; set; } = new List<ushort>();
}

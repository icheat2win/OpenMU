// <copyright file="MonsterTypeDefinition.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.DataModel.Configuration;

using MUnique.OpenMU.Annotations;

/// <summary>
/// Defines the behavior type category for a monster.
/// </summary>
public enum MonsterBehaviorType
{
    /// <summary>
    /// Standard monster behavior - attacks when provoked.
    /// </summary>
    Normal,

    /// <summary>
    /// Boss monster with enhanced AI and special mechanics.
    /// </summary>
    Boss,

    /// <summary>
    /// Event monster with special spawn conditions.
    /// </summary>
    Event,

    /// <summary>
    /// Summoned creature controlled by a player or NPC.
    /// </summary>
    Summon,

    /// <summary>
    /// Trap or environmental hazard that deals damage.
    /// </summary>
    Trap,

    /// <summary>
    /// Peaceful NPC that does not attack.
    /// </summary>
    Peaceful,

    /// <summary>
    /// Guard NPC that protects an area.
    /// </summary>
    Guard,
}

/// <summary>
/// Defines the movement pattern for a monster.
/// </summary>
public enum MonsterMovementPattern
{
    /// <summary>
    /// Random movement within spawn area.
    /// </summary>
    Random,

    /// <summary>
    /// Stationary, does not move.
    /// </summary>
    Stationary,

    /// <summary>
    /// Follows and pursues targets.
    /// </summary>
    Chase,

    /// <summary>
    /// Patrols a specific route.
    /// </summary>
    Patrol,

    /// <summary>
    /// Teleports to target location.
    /// </summary>
    Teleport,

    /// <summary>
    /// Flies or hovers above ground.
    /// </summary>
    Flying,
}

/// <summary>
/// Defines the attack pattern for a monster.
/// </summary>
public enum MonsterAttackPattern
{
    /// <summary>
    /// Melee attacks only.
    /// </summary>
    Melee,

    /// <summary>
    /// Ranged attacks only.
    /// </summary>
    Ranged,

    /// <summary>
    /// Magic/spell-based attacks.
    /// </summary>
    Magic,

    /// <summary>
    /// Combination of melee and ranged.
    /// </summary>
    Hybrid,

    /// <summary>
    /// Area of effect attacks.
    /// </summary>
    AreaOfEffect,

    /// <summary>
    /// Special attack patterns (status effects, debuffs).
    /// </summary>
    Special,

    /// <summary>
    /// Does not attack.
    /// </summary>
    None,
}

/// <summary>
/// Defines a monster type with behavioral characteristics.
/// This allows data-driven configuration of monster behavior patterns
/// rather than hardcoding behavior in monster definitions.
/// </summary>
[Cloneable]
public partial class MonsterTypeDefinition
{
    /// <summary>
    /// Gets or sets the unique identifier for this monster type.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Gets or sets the name of this monster type.
    /// Examples: "Normal Monster", "Boss Monster", "Event Monster", etc.
    /// </summary>
    public string Name { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the description of this monster type.
    /// </summary>
    public string Description { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the behavior type category for this monster type.
    /// Determines high-level AI behavior and interaction patterns.
    /// </summary>
    public MonsterBehaviorType BehaviorType { get; set; }

    /// <summary>
    /// Gets or sets the movement pattern for monsters of this type.
    /// Defines how the monster moves around the map.
    /// </summary>
    public MonsterMovementPattern MovementPattern { get; set; }

    /// <summary>
    /// Gets or sets the attack pattern for monsters of this type.
    /// Defines how the monster engages targets in combat.
    /// </summary>
    public MonsterAttackPattern AttackPattern { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether monsters of this type are aggressive.
    /// Aggressive monsters attack nearby players without provocation.
    /// </summary>
    public bool IsAggressive { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether monsters of this type respawn after death.
    /// Bosses and event monsters typically do not respawn automatically.
    /// </summary>
    public bool CanRespawn { get; set; }

    /// <summary>
    /// Gets or sets a value indicating whether monsters of this type can be targeted by players.
    /// Some environmental objects or decorative NPCs cannot be targeted.
    /// </summary>
    public bool IsTargetable { get; set; }

    /// <summary>
    /// Gets or sets the aggro multiplier for this monster type.
    /// Higher values make the monster more likely to target and pursue players.
    /// Default is 1.0 for normal behavior.
    /// </summary>
    public float AggroMultiplier { get; set; }

    /// <summary>
    /// Gets or sets the experience multiplier for killing monsters of this type.
    /// Boss monsters typically have higher multipliers.
    /// </summary>
    public float ExperienceMultiplier { get; set; }

    /// <summary>
    /// Gets or sets the drop rate multiplier for monsters of this type.
    /// Event monsters may have increased drop rates.
    /// </summary>
    public float DropRateMultiplier { get; set; }

    /// <inheritdoc/>
    public override string ToString()
    {
        return $"{this.Name} ({this.BehaviorType})";
    }
}

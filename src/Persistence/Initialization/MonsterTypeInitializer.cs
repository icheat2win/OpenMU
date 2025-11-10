// <copyright file="MonsterTypeInitializer.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.Persistence.Initialization;

using MUnique.OpenMU.DataModel.Configuration;

/// <summary>
/// Initializer for standard monster type definitions.
/// </summary>
public class MonsterTypeInitializer
{
    /// <summary>
    /// Creates the standard monster types used across all game versions.
    /// </summary>
    /// <param name="context">The persistence context.</param>
    /// <param name="gameConfiguration">The game configuration.</param>
    public static void Initialize(IContext context, GameConfiguration gameConfiguration)
    {
        var normalMonster = context.CreateNew<MonsterTypeDefinition>();
        normalMonster.Id = new Guid("00000000-0000-0000-0000-000000000001");
        normalMonster.Name = "Normal Monster";
        normalMonster.Description = "Standard monster that attacks when provoked";
        normalMonster.BehaviorType = MonsterBehaviorType.Normal;
        normalMonster.MovementPattern = MonsterMovementPattern.Random;
        normalMonster.AttackPattern = MonsterAttackPattern.Melee;
        normalMonster.IsAggressive = true;
        normalMonster.CanRespawn = true;
        normalMonster.IsTargetable = true;
        normalMonster.AggroMultiplier = 1.0f;
        normalMonster.ExperienceMultiplier = 1.0f;
        normalMonster.DropRateMultiplier = 1.0f;

        var bossMonster = context.CreateNew<MonsterTypeDefinition>();
        bossMonster.Id = new Guid("00000000-0000-0000-0000-000000000002");
        bossMonster.Name = "Boss Monster";
        bossMonster.Description = "Powerful boss with enhanced AI and mechanics";
        bossMonster.BehaviorType = MonsterBehaviorType.Boss;
        bossMonster.MovementPattern = MonsterMovementPattern.Chase;
        bossMonster.AttackPattern = MonsterAttackPattern.Hybrid;
        bossMonster.IsAggressive = true;
        bossMonster.CanRespawn = false;
        bossMonster.IsTargetable = true;
        bossMonster.AggroMultiplier = 2.0f;
        bossMonster.ExperienceMultiplier = 5.0f;
        bossMonster.DropRateMultiplier = 3.0f;

        var eventMonster = context.CreateNew<MonsterTypeDefinition>();
        eventMonster.Id = new Guid("00000000-0000-0000-0000-000000000003");
        eventMonster.Name = "Event Monster";
        eventMonster.Description = "Special event monster with increased rewards";
        eventMonster.BehaviorType = MonsterBehaviorType.Event;
        eventMonster.MovementPattern = MonsterMovementPattern.Random;
        eventMonster.AttackPattern = MonsterAttackPattern.Melee;
        eventMonster.IsAggressive = true;
        eventMonster.CanRespawn = false;
        eventMonster.IsTargetable = true;
        eventMonster.AggroMultiplier = 1.5f;
        eventMonster.ExperienceMultiplier = 2.0f;
        eventMonster.DropRateMultiplier = 2.0f;

        var summonMonster = context.CreateNew<MonsterTypeDefinition>();
        summonMonster.Id = new Guid("00000000-0000-0000-0000-000000000004");
        summonMonster.Name = "Summoned Creature";
        summonMonster.Description = "Creature summoned by a player or NPC";
        summonMonster.BehaviorType = MonsterBehaviorType.Summon;
        summonMonster.MovementPattern = MonsterMovementPattern.Chase;
        summonMonster.AttackPattern = MonsterAttackPattern.Melee;
        summonMonster.IsAggressive = false;
        summonMonster.CanRespawn = false;
        summonMonster.IsTargetable = true;
        summonMonster.AggroMultiplier = 0.5f;
        summonMonster.ExperienceMultiplier = 0.0f;
        summonMonster.DropRateMultiplier = 0.0f;

        var trapMonster = context.CreateNew<MonsterTypeDefinition>();
        trapMonster.Id = new Guid("00000000-0000-0000-0000-000000000005");
        trapMonster.Name = "Trap";
        trapMonster.Description = "Environmental hazard or trap";
        trapMonster.BehaviorType = MonsterBehaviorType.Trap;
        trapMonster.MovementPattern = MonsterMovementPattern.Stationary;
        trapMonster.AttackPattern = MonsterAttackPattern.AreaOfEffect;
        trapMonster.IsAggressive = true;
        trapMonster.CanRespawn = true;
        trapMonster.IsTargetable = false;
        trapMonster.AggroMultiplier = 0.0f;
        trapMonster.ExperienceMultiplier = 0.0f;
        trapMonster.DropRateMultiplier = 0.0f;

        var peacefulNpc = context.CreateNew<MonsterTypeDefinition>();
        peacefulNpc.Id = new Guid("00000000-0000-0000-0000-000000000006");
        peacefulNpc.Name = "Peaceful NPC";
        peacefulNpc.Description = "Non-hostile NPC that does not attack";
        peacefulNpc.BehaviorType = MonsterBehaviorType.Peaceful;
        peacefulNpc.MovementPattern = MonsterMovementPattern.Stationary;
        peacefulNpc.AttackPattern = MonsterAttackPattern.None;
        peacefulNpc.IsAggressive = false;
        peacefulNpc.CanRespawn = false;
        peacefulNpc.IsTargetable = true;
        peacefulNpc.AggroMultiplier = 0.0f;
        peacefulNpc.ExperienceMultiplier = 0.0f;
        peacefulNpc.DropRateMultiplier = 0.0f;

        var guardNpc = context.CreateNew<MonsterTypeDefinition>();
        guardNpc.Id = new Guid("00000000-0000-0000-0000-000000000007");
        guardNpc.Name = "Guard";
        guardNpc.Description = "Guard NPC that protects an area";
        guardNpc.BehaviorType = MonsterBehaviorType.Guard;
        guardNpc.MovementPattern = MonsterMovementPattern.Patrol;
        guardNpc.AttackPattern = MonsterAttackPattern.Melee;
        guardNpc.IsAggressive = false;
        guardNpc.CanRespawn = false;
        guardNpc.IsTargetable = true;
        guardNpc.AggroMultiplier = 3.0f;
        guardNpc.ExperienceMultiplier = 0.0f;
        guardNpc.DropRateMultiplier = 0.0f;

        // Add monster types to game configuration
        gameConfiguration.MonsterTypes.Add(normalMonster);
        gameConfiguration.MonsterTypes.Add(bossMonster);
        gameConfiguration.MonsterTypes.Add(eventMonster);
        gameConfiguration.MonsterTypes.Add(summonMonster);
        gameConfiguration.MonsterTypes.Add(trapMonster);
        gameConfiguration.MonsterTypes.Add(peacefulNpc);
        gameConfiguration.MonsterTypes.Add(guardNpc);
    }

    /// <summary>
    /// Gets the standard monster type by behavior type.
    /// </summary>
    /// <param name="gameConfiguration">The game configuration.</param>
    /// <param name="behaviorType">The behavior type to find.</param>
    /// <returns>The matching monster type definition, or null if not found.</returns>
    public static MonsterTypeDefinition? GetMonsterType(GameConfiguration gameConfiguration, MonsterBehaviorType behaviorType)
    {
        return gameConfiguration.MonsterTypes?.FirstOrDefault(mt => mt.BehaviorType == behaviorType);
    }
}

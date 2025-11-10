// <copyright file="MonsterTypeExtensions.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.Persistence.Initialization;

using MUnique.OpenMU.DataModel.Configuration;

/// <summary>
/// Extension methods for assigning MonsterType to MonsterDefinition instances.
/// </summary>
internal static class MonsterTypeExtensions
{
    /// <summary>
    /// Assigns a MonsterType to a MonsterDefinition by type name.
    /// </summary>
    /// <param name="monster">The monster definition to update.</param>
    /// <param name="gameConfiguration">The game configuration containing monster types.</param>
    /// <param name="typeName">The name of the monster type (Normal, Boss, Event, Summon, Trap, Destructible, PassiveNPC, VendorNPC, GateNPC).</param>
    /// <returns>The monster definition for fluent chaining.</returns>
    public static MonsterDefinition AssignMonsterType(this MonsterDefinition monster, GameConfiguration gameConfiguration, string typeName)
    {
        monster.MonsterType = gameConfiguration.MonsterTypes.FirstOrDefault(t => t.Name == typeName);
        return monster;
    }

    /// <summary>
    /// Determines and assigns the appropriate MonsterType based on NpcWindow.
    /// </summary>
    /// <param name="monster">The monster definition to update.</param>
    /// <param name="gameConfiguration">The game configuration containing monster types.</param>
    /// <returns>The monster definition for fluent chaining.</returns>
    public static MonsterDefinition AssignMonsterTypeByNpcWindow(this MonsterDefinition monster, GameConfiguration gameConfiguration)
    {
        var typeName = monster.NpcWindow switch
        {
            NpcWindow.Merchant or
            NpcWindow.Merchant1 or
            NpcWindow.VaultStorage or
            NpcWindow.ChaosMachine or
            NpcWindow.DevilSquare or
            NpcWindow.BloodCastle or
            NpcWindow.PetTrainer or
            NpcWindow.Lahap or
            NpcWindow.CastleSeniorNPC or
            NpcWindow.ElphisRefinery or
            NpcWindow.RefineStoneMaking or
            NpcWindow.RemoveJohOption or
            NpcWindow.IllusionTemple or
            NpcWindow.ChaosCardCombination or
            NpcWindow.CherryBlossomBranchesAssembly or
            NpcWindow.SeedMaster or
            NpcWindow.SeedResearcher or
            NpcWindow.StatReInitializer or
            NpcWindow.DelgadoLuckyCoinRegistration or
            NpcWindow.GuildMaster or
            NpcWindow.CombineLuckyItem => "VendorNPC",
            
            NpcWindow.LegacyQuest or
            NpcWindow.NpcDialog or
            NpcWindow.Undefined => monster.ObjectKind == NpcObjectKind.PassiveNpc ? "PassiveNPC" : "Normal",
            
            _ => "PassiveNPC",
        };

        return monster.AssignMonsterType(gameConfiguration, typeName);
    }

    /// <summary>
    /// Assigns Normal monster type (for regular monsters).
    /// </summary>
    /// <param name="monster">The monster definition to update.</param>
    /// <param name="gameConfiguration">The game configuration containing monster types.</param>
    /// <returns>The monster definition for fluent chaining.</returns>
    public static MonsterDefinition AsNormalMonster(this MonsterDefinition monster, GameConfiguration gameConfiguration)
        => monster.AssignMonsterType(gameConfiguration, "Normal");

    /// <summary>
    /// Assigns Boss monster type (for bosses).
    /// </summary>
    /// <param name="monster">The monster definition to update.</param>
    /// <param name="gameConfiguration">The game configuration containing monster types.</param>
    /// <returns>The monster definition for fluent chaining.</returns>
    public static MonsterDefinition AsBoss(this MonsterDefinition monster, GameConfiguration gameConfiguration)
        => monster.AssignMonsterType(gameConfiguration, "Boss");

    /// <summary>
    /// Assigns Event monster type (for event-specific monsters).
    /// </summary>
    /// <param name="monster">The monster definition to update.</param>
    /// <param name="gameConfiguration">The game configuration containing monster types.</param>
    /// <returns>The monster definition for fluent chaining.</returns>
    public static MonsterDefinition AsEventMonster(this MonsterDefinition monster, GameConfiguration gameConfiguration)
        => monster.AssignMonsterType(gameConfiguration, "Event");

    /// <summary>
    /// Assigns Summon monster type (for player-summoned creatures).
    /// </summary>
    /// <param name="monster">The monster definition to update.</param>
    /// <param name="gameConfiguration">The game configuration containing monster types.</param>
    /// <returns>The monster definition for fluent chaining.</returns>
    public static MonsterDefinition AsSummon(this MonsterDefinition monster, GameConfiguration gameConfiguration)
        => monster.AssignMonsterType(gameConfiguration, "Summon");
}

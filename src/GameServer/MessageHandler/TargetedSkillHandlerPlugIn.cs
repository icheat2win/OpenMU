// <copyright file="TargetedSkillHandlerPlugIn.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.GameServer.MessageHandler;

using System.Runtime.InteropServices;
using MUnique.OpenMU.GameLogic;
using MUnique.OpenMU.GameLogic.PlayerActions.Skills;
using MUnique.OpenMU.GameLogic.PlugIns;
using MUnique.OpenMU.GameLogic.Views;
using MUnique.OpenMU.Network.Packets.ClientToServer;
using MUnique.OpenMU.Network.PlugIns;
using MUnique.OpenMU.PlugIns;

/// <summary>
/// Implements the targeted skill packet handler.
/// </summary>
/// <remarks>
/// <para>
/// This handler processes client requests to use skills that target a specific entity.
/// When a player uses a skill by clicking on a target (attack skills, buff skills, heal skills),
/// the client sends this packet with the skill ID and target ID. The server validates requirements,
/// calculates effects, and applies the skill to the target.
/// </para>
/// <para>
/// <strong>Packet Structure (C3 08 19):</strong>
/// <list type="table">
///   <listheader>
///     <term>Offset</term>
///     <term>Length</term>
///     <term>Type</term>
///     <term>Description</term>
///   </listheader>
///   <item>
///     <term>0</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Packet header (0xC3)</term>
///   </item>
///   <item>
///     <term>1</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Packet size (0x08)</term>
///   </item>
///   <item>
///     <term>2</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Packet type (0x19 - Targeted Skill)</term>
///   </item>
///   <item>
///     <term>3-4</term>
///     <term>2</term>
///     <term>ushort</term>
///     <term>Skill ID (skill number from skill tree)</term>
///   </item>
///   <item>
///     <term>5-6</term>
///     <term>2</term>
///     <term>ushort</term>
///     <term>Target ID (server-assigned object identifier)</term>
///   </item>
/// </list>
/// </para>
/// <para>
/// <strong>Skill Categories:</strong>
/// <list type="table">
///   <listheader>
///     <term>Category</term>
///     <term>Target Type</term>
///     <term>Examples</term>
///   </listheader>
///   <item>
///     <term>Attack Skills</term>
///     <term>Enemy</term>
///     <term>Power Slash, Cyclone, Death Stab, Flame Strike</term>
///   </item>
///   <item>
///     <term>Buff Skills</term>
///     <term>Self or Ally</term>
///     <term>Soul Barrier, Greater Defense, Bless, Swell Life</term>
///   </item>
///   <item>
///     <term>Debuff Skills</term>
///     <term>Enemy</term>
///     <term>Weakness, Poison, Curse, Ice Storm (freeze)</term>
///   </item>
///   <item>
///     <term>Healing Skills</term>
///     <term>Self or Ally</term>
///     <term>Heal, Greater Healing, Healing Shield</term>
///   </item>
///   <item>
///     <term>Teleport Skills</term>
///     <term>Self or Ally</term>
///     <term>Teleport, Teleport Ally</term>
///   </item>
///   <item>
///     <term>Summon Skills</term>
///     <term>Self</term>
///     <term>Summon Goblin, Summon Golem, Summon Monster</term>
///   </item>
/// </list>
/// </para>
/// <para>
/// <strong>Validation and Error Conditions:</strong>
/// <list type="bullet">
///   <item><description>Player must know the skill (learned or innate)</description></item>
///   <item><description>Player must have sufficient mana/stamina/AG</description></item>
///   <item><description>Skill must not be on cooldown</description></item>
///   <item><description>Target must exist and be in range</description></item>
///   <item><description>Target must be valid for skill type (e.g., cannot attack allies, cannot heal enemies)</description></item>
///   <item><description>Player must meet skill requirements (level, stats, equipment)</description></item>
///   <item><description>Player must not be stunned, frozen, or in restricted state</description></item>
///   <item><description>For attack skills: Target must be attackable and not in safe zone</description></item>
///   <item><description>For buff skills: Target must be self or party member (class-dependent)</description></item>
/// </list>
/// </para>
/// <para>
/// <strong>Success Response:</strong> Skill animation plays, effect is applied to target.
/// Damage, healing, or status effects are calculated and applied. Mana/stamina is consumed.
/// Cooldown timer starts. Nearby players see the skill animation.
/// </para>
/// <para>
/// <strong>Failure Response:</strong> Skill cast fails and client receives error message
/// (not enough mana, target out of range, skill on cooldown, etc.).
/// </para>
/// <para>
/// <strong>Strategy Pattern:</strong> This handler uses a plugin-based strategy pattern
/// where different skills can have custom implementations (ITargetedSkillPlugin).
/// If no custom strategy exists, the default strategy handles standard targeting logic.
/// This allows flexibility for special skills with unique mechanics.
/// </para>
/// <para>
/// <strong>Target Types:</strong>
/// <list type="bullet">
///   <item><description><strong>Self:</strong> Player can target themselves (buffs, heals)</description></item>
///   <item><description><strong>Party Member:</strong> Target is in same party (heals, buffs)</description></item>
///   <item><description><strong>Monster:</strong> Target is a monster (attacks, debuffs)</description></item>
///   <item><description><strong>Player (PvP):</strong> Target is another player (PvP combat)</description></item>
///   <item><description><strong>NPC:</strong> Target is a summon or pet (commands)</description></item>
/// </list>
/// </para>
/// </remarks>
[PlugIn("TargetedSkillHandlerPlugIn", "Handler for targeted skill packets.")]
[Guid("5b07d03c-509c-4aec-972c-a99db77561f2")]
[MinimumClient(3, 0, ClientLanguage.Invariant)]
internal class TargetedSkillHandlerPlugIn : IPacketHandlerPlugIn
{
    private readonly ITargetedSkillPlugin _defaultStrategy = new TargetedSkillDefaultPlugin();

    /// <inheritdoc/>
    public virtual bool IsEncryptionExpected => true;

    /// <inheritdoc/>
    public byte Key => TargetedSkill.Code;

    /// <inheritdoc/>
    public virtual async ValueTask HandlePacketAsync(Player player, Memory<byte> packet)
    {
        TargetedSkill message = packet;

        await this.HandleAsync(player, message.SkillId, message.TargetId).ConfigureAwait(false);
    }

    /// <summary>
    /// Handles the skill request of the specified player.
    /// </summary>
    /// <param name="player">The player.</param>
    /// <param name="skillId">The skill identifier.</param>
    /// <param name="targetId">The target identifier.</param>
    protected async ValueTask HandleAsync(Player player, ushort skillId, ushort targetId)
    {
        var strategy = player.GameContext.
            PlugInManager.GetStrategy<short, ITargetedSkillPlugin>((short)skillId) ??
            this._defaultStrategy;

        // Note: The target can be the own player too, for example when using buff skills.
        if (player.GetObject(targetId) is IAttackable target)
        {
            await strategy.PerformSkillAsync(player, target, skillId).ConfigureAwait(false);
        }
    }
}
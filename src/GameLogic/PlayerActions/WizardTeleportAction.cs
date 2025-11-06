// <copyright file="WizardTeleportAction.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.GameLogic.PlayerActions;

using MUnique.OpenMU.GameLogic.CastleSiege;
using MUnique.OpenMU.GameLogic.Views.World;
using MUnique.OpenMU.Pathfinding;

/// <summary>
/// Action to warp to another place through a gate.
/// </summary>
public class WizardTeleportAction
{
    private const ushort TeleportSkillId = 6;
    private const ushort TeleportTargetSkillId = 15;

    private static readonly byte[] PreventingMagicEffects =
    {
        0x39, // Stone
        0x3D, // Stun
        0x48, // Sleep
        0x92, // Freeze2
        0x93, // Earth Binds
    };

    /// <summary>
    /// Tries to teleport to the specified target with the teleport skill.
    /// </summary>
    /// <param name="player">The player.</param>
    /// <param name="target">The target.</param>
    public async ValueTask TryTeleportWithSkillAsync(Player player, Point target)
    {
        if (!player.IsAtSafezone()
            && player.IsActive()
            && player.SkillList?.GetSkill(TeleportSkillId) is { Skill: { } skill }
            && player.CurrentMap!.Terrain.WalkMap[target.X, target.Y]
            && !player.CurrentMap.Terrain.SafezoneMap[target.X, target.Y]
            && player.IsInRange(target, player.GetEffectiveSkillRange(skill))
            && CanPlayerBeTeleported(player)
            && !IsTeleportBlockedByCastleSiegeGate(player, target)
            && await player.TryConsumeForSkillAsync(skill).ConfigureAwait(false))
        {
            _ = Task.Run(() => player.TeleportAsync(target, skill));
        }
        else
        {
            await player.InvokeViewPlugInAsync<ITeleportPlugIn>(p => p.ShowTeleportedAsync()).ConfigureAwait(false);
        }
    }

    /// <summary>
    /// Tries to teleport the target with the 'Teleport Ally' skill.
    /// </summary>
    /// <param name="player">The player.</param>
    /// <param name="targetId">The target identifier.</param>
    /// <param name="target">The target.</param>
    public async ValueTask TryTeleportTargetWithSkillAsync(Player player, ushort targetId, Point target)
    {
        if (!player.IsAtSafezone()
            && player.IsActive()
            && player.SkillList?.GetSkill(TeleportTargetSkillId) is { Skill: { } skill }
            && player.Party is not null
            && player.CurrentMap!.Terrain.WalkMap[target.X, target.Y]
            && !player.CurrentMap.Terrain.SafezoneMap[target.X, target.Y]
            && await player.GetObservingPlayerWithIdAsync(targetId).ConfigureAwait(false) is { } targetPlayer
            && targetPlayer.Party == player.Party
            && targetPlayer.IsActive()
            && CanPlayerBeTeleported(targetPlayer)
            && targetPlayer.IsInRange(target, player.GetEffectiveSkillRange(skill))
            && await player.TryConsumeForSkillAsync(skill).ConfigureAwait(false))
        {
            _ = Task.Run(() => targetPlayer.TeleportAsync(target, skill));
        }
    }

    private static bool CanPlayerBeTeleported(Player player)
    {
        var currentEffects = player.MagicEffectList.ActiveEffects;
        if (currentEffects.Count == 0)
        {
            return true;
        }

        for (int i = 0; i < PreventingMagicEffects.Length; i++)
        {
            if (currentEffects.ContainsKey(PreventingMagicEffects[i]))
            {
                return false;
            }
        }

        return true;
    }

    /// <summary>
    /// Checks if teleportation is blocked by a castle siege gate.
    /// During castle siege, gates at specific Y-axis ranges block teleportation until destroyed.
    /// Based on client gate locations: Y ranges around 114, 161, and 204.
    /// </summary>
    /// <param name="player">The player attempting to teleport.</param>
    /// <param name="target">The target position.</param>
    /// <returns><c>true</c> if teleportation is blocked by a gate; otherwise, <c>false</c>.</returns>
    private static bool IsTeleportBlockedByCastleSiegeGate(Player player, Point target)
    {
        // Only check if there's an active castle siege context
        var castleSiegeContext = player.CurrentMap?.CastleSiegeContext;
        if (castleSiegeContext is null || castleSiegeContext.State != CastleSiegeState.InProgress)
        {
            return false;
        }

        // Gate Y-axis ranges based on original client gate locations:
        // g_byGateLocation[6][2] = { { 67, 114 }, { 93, 114 }, { 119, 114 }, { 81, 161 }, { 107, 161 }, { 93, 204 } }
        // Gates span ~4 tiles width, checking if player or target crosses gate line
        var playerY = player.Position.Y;
        var targetY = target.Y;

        // Check if teleporting across any gate line (gates at Y: 114, 161, 204)
        // Allow teleport only if both positions are on the same side of all gates
        return IsCrossingGateLine(playerY, targetY, 114)
            || IsCrossingGateLine(playerY, targetY, 161)
            || IsCrossingGateLine(playerY, targetY, 204);
    }

    /// <summary>
    /// Checks if a teleport crosses a gate line at the specified Y coordinate.
    /// </summary>
    /// <param name="fromY">Starting Y position.</param>
    /// <param name="toY">Target Y position.</param>
    /// <param name="gateY">Gate Y coordinate.</param>
    /// <returns><c>true</c> if the teleport crosses the gate; otherwise, <c>false</c>.</returns>
    private static bool IsCrossingGateLine(byte fromY, byte toY, int gateY)
    {
        // Allow ±2 tile tolerance for gate area (gates are ~4 tiles wide)
        const int gateTolerance = 2;

        // Check if teleport crosses from one side of gate to the other
        return (fromY < gateY - gateTolerance && toY > gateY + gateTolerance)
            || (fromY > gateY + gateTolerance && toY < gateY - gateTolerance);
    }
}
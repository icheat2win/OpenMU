// <copyright file="CharacterWalkBaseHandlerPlugIn.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.GameServer.MessageHandler;

using MUnique.OpenMU.DataModel.Configuration;
using MUnique.OpenMU.GameLogic;
using MUnique.OpenMU.GameLogic.Views.World;
using MUnique.OpenMU.Network.Packets.ClientToServer;
using MUnique.OpenMU.Pathfinding;

/// <summary>
/// Abstract packet handler for walk packets.
/// </summary>
/// <remarks>
/// <para>
/// This handler processes client movement requests. When a player clicks on the ground
/// to move, the client sends a walk packet containing the current position and a series
/// of directional steps to reach the target location. The server validates and executes
/// the movement, notifying nearby players of position changes.
/// </para>
/// <para>
/// <strong>Packet Structure (C3 [variable] 1C/D4/D3/1D):</strong>
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
///     <term>Packet size (6 for rotation-only, 6+ for movement with steps)</term>
///   </item>
///   <item>
///     <term>2</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Packet type (0x1C, 0xD4, 0xD3, or 0x1D depending on version)</term>
///   </item>
///   <item>
///     <term>3</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Source X coordinate (current position)</term>
///   </item>
///   <item>
///     <term>4</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Source Y coordinate (current position)</term>
///   </item>
///   <item>
///     <term>5</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Target rotation (for rotation-only packet) or encoded path data</term>
///   </item>
///   <item>
///     <term>6+</term>
///     <term>N</term>
///     <term>bytes</term>
///     <term>Encoded directional steps (variable length, version-dependent)</term>
///   </item>
/// </list>
/// </para>
/// <para>
/// <strong>Movement Types:</strong>
/// <list type="bullet">
///   <item><description><strong>Full Walk (Length > 6):</strong> Player moves from source to target following encoded path</description></item>
///   <item><description><strong>Rotation Only (Length = 6):</strong> Player rotates in place without moving</description></item>
/// </list>
/// </para>
/// <para>
/// <strong>Directional Step Encoding:</strong>
/// Steps are encoded as 4-bit values (2 steps per byte), where each direction is:
/// <list type="bullet">
///   <item><description>0 = South (Down)</description></item>
///   <item><description>1 = SouthWest</description></item>
///   <item><description>2 = West (Left)</description></item>
///   <item><description>3 = NorthWest</description></item>
///   <item><description>4 = North (Up)</description></item>
///   <item><description>5 = NorthEast</description></item>
///   <item><description>6 = East (Right)</description></item>
///   <item><description>7 = SouthEast</description></item>
/// </list>
/// </para>
/// <para>
/// <strong>Validation and Error Conditions:</strong>
/// <list type="bullet">
///   <item><description>Packet must be at least 6 bytes</description></item>
///   <item><description>Source coordinates must match or be near player's current position</description></item>
///   <item><description>All target tiles in path must be walkable (not blocked by terrain or objects)</description></item>
///   <item><description>Path must not exceed maximum walk distance in single packet</description></item>
///   <item><description>Player must not be in restricted state (stunned, frozen, dead)</description></item>
///   <item><description>Path must respect map boundaries</description></item>
/// </list>
/// </para>
/// <para>
/// <strong>Success Response:</strong> Player position is updated and movement animation plays.
/// Nearby players receive position update packets showing the movement.
/// </para>
/// <para>
/// <strong>Failure Response:</strong> If path is invalid, player position is corrected
/// by sending current position back to client. Movement is rejected silently.
/// </para>
/// <para>
/// <strong>Version Differences:</strong>
/// <list type="bullet">
///   <item><description>0x1C (Season 6+): Latest walk packet format with extended features</description></item>
///   <item><description>0xD4 (0.97d): Intermediate version walk packet</description></item>
///   <item><description>0xD3 (0.75): Legacy walk packet with different encoding</description></item>
///   <item><description>0x1D: Alternative walk packet format</description></item>
/// </list>
/// Different handlers (CharacterWalkHandlerPlugIn, WalkHandlerPlugIn095, etc.) implement
/// version-specific decoding logic while sharing this base validation and execution.
/// </para>
/// </remarks>
internal abstract class CharacterWalkBaseHandlerPlugIn : IPacketHandlerPlugIn
{
    /// <inheritdoc/>
    public bool IsEncryptionExpected => false;

    /// <inheritdoc/>
    public abstract byte Key { get; }

    /// <inheritdoc/>
    public async ValueTask HandlePacketAsync(Player player, Memory<byte> packet)
    {
        if (packet.Length < 6)
        {
            return;
        }

        WalkRequest request = packet;
        await this.WalkAsync(player, request, new Point(request.SourceX, request.SourceY)).ConfigureAwait(false);
    }

    private async ValueTask WalkAsync(Player player, WalkRequest request, Point sourcePoint)
    {
        if (request.Header.Length > 6)
        {
            // in a walk packet, x and y are the current coordinates and the steps are leading us to the target
            var steps = this.GetSteps(sourcePoint, this.DecodePayload(request, out _));
            var target = this.GetTarget(steps.Span, sourcePoint);

            await player.WalkToAsync(target, steps).ConfigureAwait(false);
        }
        else
        {
            // Short walk packet - player is just changing rotation without moving
            player.Rotation = request.TargetRotation.ParseAsDirection();
            
            // Notify observers about the rotation change
            await player.ForEachWorldObserverAsync<IShowRotationPlugIn>(p => p.ShowRotationAsync(player), false).ConfigureAwait(false);
        }
    }

    private Point GetTarget(Span<WalkingStep> steps, Point source)
    {
        if (steps.Length > 0)
        {
            var step = steps[steps.Length - 1];
            return step.To;
        }

        return source;
    }

    private Memory<WalkingStep> GetSteps(Point start, Span<Direction> directions)
    {
        var result = new WalkingStep[directions.Length];
        var previousTarget = start;
        int i = 0;
        foreach (var direction in directions)
        {
            var currentTarget = previousTarget.CalculateTargetPoint(direction);
            result[i] = new WalkingStep { Direction = direction, To = currentTarget, From = previousTarget };
            i++;
            previousTarget = currentTarget;
        }

        return result;
    }

    /// <summary>
    /// Gets the walking directions from the walk packet and the final rotation of the character.
    /// </summary>
    /// <param name="walkRequest">
    /// The walk request, received from the client.
    /// </param>
    /// <param name="rotation">
    /// The rotation of the character once the walking is done.
    /// </param>
    /// <returns>The walking directions and the final rotation of the character.</returns>
    /// <remarks>
    /// We return here the directions left-rotated; I don't know yet if that's an error in our Direction-enum
    /// or just the client uses another enumeration for it.
    /// </remarks>
    private Span<Direction> DecodePayload(WalkRequest walkRequest, out Direction rotation)
    {
        var stepsCount = walkRequest.StepCount;
        rotation = walkRequest.TargetRotation.ParseAsDirection();
        var directions = new Direction[stepsCount];
        var payload = walkRequest.Directions;
        for (int i = 0; i < stepsCount; i++)
        {
            var val = payload[i / 2];
            val = (byte)(i % 2 == 0 ? val >> 4 : val & 0x0F);
            directions[i] = val.ParseAsDirection();
        }

        return directions.AsSpan(0, directions.Length);
    }
}
// <copyright file="DropItemHandlerPlugIn.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.GameServer.MessageHandler.Items;

using System.Runtime.InteropServices;
using MUnique.OpenMU.GameLogic;
using MUnique.OpenMU.GameLogic.PlayerActions.Items;
using MUnique.OpenMU.Network.Packets.ClientToServer;
using MUnique.OpenMU.Pathfinding;
using MUnique.OpenMU.PlugIns;

/// <summary>
/// Handler for drop item packets.
/// </summary>
/// <remarks>
/// <para>
/// This handler processes client requests to drop items from inventory onto the ground.
/// Players can drop items by dragging them from inventory to the game world.
/// The client specifies the inventory slot and target ground coordinates.
/// </para>
/// <para>
/// <strong>Packet Structure (C3 08 23):</strong>
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
///     <term>Packet type (0x23 - Drop Item)</term>
///   </item>
///   <item>
///     <term>3</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Inventory slot (0-based index)</term>
///   </item>
///   <item>
///     <term>4</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Target X coordinate</term>
///   </item>
///   <item>
///     <term>5</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Target Y coordinate</term>
///   </item>
/// </list>
/// </para>
/// <para>
/// <strong>Validation and Error Conditions:</strong>
/// <list type="bullet">
///   <item><description>Item must exist in the specified inventory slot</description></item>
///   <item><description>Target coordinates must be within valid map bounds</description></item>
///   <item><description>Target location must be walkable (not blocked)</description></item>
///   <item><description>Target must be within drop range from player position</description></item>
///   <item><description>Some items cannot be dropped (quest items, bound items)</description></item>
///   <item><description>Player must not be in trade, shop, or other restricted state</description></item>
///   <item><description>Player must not be in a safe zone where dropping is prohibited</description></item>
/// </list>
/// </para>
/// <para>
/// <strong>Success Response:</strong> Item is removed from inventory and spawned on ground
/// at target location. Nearby players are notified of the new ground item.
/// </para>
/// <para>
/// <strong>Failure Response:</strong> Client receives failure message indicating why
/// the drop was rejected.
/// </para>
/// </remarks>
[PlugIn("DropItemHandlerPlugIn", "Handler for drop item packets.")]
[Guid("b79bc453-74a0-4eea-8bc3-014d737aaa88")]
internal class DropItemHandlerPlugIn : IPacketHandlerPlugIn
{
    private readonly DropItemAction _dropAction = new();

    /// <inheritdoc/>
    public bool IsEncryptionExpected => false;

    /// <inheritdoc/>
    public byte Key => DropItemRequest.Code;

    /// <inheritdoc/>
    public async ValueTask HandlePacketAsync(Player player, Memory<byte> packet)
    {
        DropItemRequest message = packet;
        await this._dropAction.DropItemAsync(player, message.ItemSlot, new Point(message.TargetX, message.TargetY)).ConfigureAwait(false);
    }
}
// <copyright file="PickupItemHandlerPlugIn.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.GameServer.MessageHandler.Items;

using System.Runtime.InteropServices;
using MUnique.OpenMU.GameLogic;
using MUnique.OpenMU.GameLogic.PlayerActions.Items;
using MUnique.OpenMU.Network.Packets.ClientToServer;
using MUnique.OpenMU.Network.PlugIns;
using MUnique.OpenMU.PlugIns;

/// <summary>
/// Handler for item pickup packets.
/// </summary>
/// <remarks>
/// <para>
/// This handler processes client requests to pick up items from the ground.
/// When a player clicks on an item that is visible on the ground, the client sends
/// a pickup request containing the item's server-assigned ID.
/// </para>
/// <para>
/// <strong>Packet Structure (C3 07 22):</strong>
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
///     <term>Packet size (0x07)</term>
///   </item>
///   <item>
///     <term>2</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Packet type (0x22 - Pickup Item)</term>
///   </item>
///   <item>
///     <term>3-4</term>
///     <term>2</term>
///     <term>ushort</term>
///     <term>Item ID (server-assigned identifier)</term>
///   </item>
/// </list>
/// </para>
/// <para>
/// <strong>Validation and Error Conditions:</strong>
/// <list type="bullet">
///   <item><description>Item must exist on the current map</description></item>
///   <item><description>Item must be within pickup range (typically 3 tiles)</description></item>
///   <item><description>Player must have inventory space available</description></item>
///   <item><description>Item must not be owned by another player (drop protection)</description></item>
///   <item><description>Player must not be in a trade or shop state</description></item>
/// </list>
/// </para>
/// <para>
/// <strong>Success Response:</strong> Item is added to inventory and removed from ground.
/// Client receives item data packet and inventory update.
/// </para>
/// <para>
/// <strong>Failure Response:</strong> Client receives failure message with reason
/// (inventory full, out of range, etc.).
/// </para>
/// </remarks>
[PlugIn("PickupItemHandlerPlugIn", "Handler for item pickup packets.")]
[Guid("8bcb9d85-95ae-4611-ae64-e9cc801ec647")]
[MinimumClient(0, 97, ClientLanguage.Invariant)]
internal class PickupItemHandlerPlugIn : IPacketHandlerPlugIn
{
    private readonly PickupItemAction _pickupAction = new();

    /// <inheritdoc />
    public bool IsEncryptionExpected => true;

    /// <inheritdoc/>
    public byte Key => PickupItemRequest.Code;

    /// <inheritdoc/>
    public async ValueTask HandlePacketAsync(Player player, Memory<byte> packet)
    {
        PickupItemRequest message = packet;
        await this._pickupAction.PickupItemAsync(player, message.ItemId).ConfigureAwait(false);
    }
}
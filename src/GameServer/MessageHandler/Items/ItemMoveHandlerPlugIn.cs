// <copyright file="ItemMoveHandlerPlugIn.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.GameServer.MessageHandler.Items;

using System.Runtime.InteropServices;
using MUnique.OpenMU.GameLogic;
using MUnique.OpenMU.GameLogic.PlayerActions.Items;
using MUnique.OpenMU.GameServer.RemoteView;
using MUnique.OpenMU.GameServer.RemoteView.Inventory;
using MUnique.OpenMU.Network.Packets;
using MUnique.OpenMU.Network.Packets.ClientToServer;
using MUnique.OpenMU.PlugIns;

/// <summary>
/// Handler for item move packets.
/// </summary>
/// <remarks>
/// <para>
/// This handler processes client requests to move items between different storage areas.
/// Players can move items within inventory, between inventory and vault, to/from trade windows,
/// to/from chaos machine, and other item storage locations.
/// </para>
/// <para>
/// <strong>Packet Structure (C3 [variable] 24):</strong>
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
///     <term>Packet size (variable, depends on item data)</term>
///   </item>
///   <item>
///     <term>2</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Packet type (0x24 - Move Item)</term>
///   </item>
///   <item>
///     <term>3</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Source slot</term>
///   </item>
///   <item>
///     <term>4</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Source storage (0=Inventory, 1=Trade, 2=Vault, 3=ChaosMachine, etc.)</term>
///   </item>
///   <item>
///     <term>5</term>
///     <term>12+</term>
///     <term>bytes</term>
///     <term>Item data (serialized item, size varies by client version)</term>
///   </item>
///   <item>
///     <term>17+</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Target storage</term>
///   </item>
///   <item>
///     <term>18+</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Target slot</term>
///   </item>
/// </list>
/// </para>
/// <para>
/// <strong>Storage Types:</strong>
/// <list type="bullet">
///   <item><description>0 - Inventory: Player's main item storage</description></item>
///   <item><description>1 - Trade: Item being offered in trade window</description></item>
///   <item><description>2 - Vault: Personal vault/warehouse storage</description></item>
///   <item><description>3 - Chaos Machine: Items placed in chaos machine for crafting</description></item>
///   <item><description>4 - Personal Shop: Items placed in personal shop</description></item>
///   <item><description>5 - Pet Inventory: Dark Raven or other pet storage</description></item>
/// </list>
/// </para>
/// <para>
/// <strong>Validation and Error Conditions:</strong>
/// <list type="bullet">
///   <item><description>Source item must exist in specified source storage and slot</description></item>
///   <item><description>Target slot must have enough space for item dimensions</description></item>
///   <item><description>Storage transition must be valid (e.g., cannot move from trade to vault directly)</description></item>
///   <item><description>Player must have access to both source and target storage</description></item>
///   <item><description>Item must meet requirements for target storage (e.g., chaos machine item requirements)</description></item>
///   <item><description>Target slot must not be occupied by another item</description></item>
///   <item><description>Some operations are restricted during trade, combat, or other states</description></item>
/// </list>
/// </para>
/// <para>
/// <strong>Success Response:</strong> Item is moved from source to target location.
/// Client inventory is updated with new item positions.
/// </para>
/// <para>
/// <strong>Failure Response:</strong> Move is rejected and client receives failure notification.
/// Item remains in original location.
/// </para>
/// <para>
/// <strong>Version Compatibility:</strong> This handler supports multiple client versions
/// by dynamically determining item data size based on the client's ItemSerializer.
/// </para>
/// </remarks>
[PlugIn("ItemMoveHandlerPlugIn", "Handler for item move packets.")]
[Guid("c499c596-7711-4971-bc83-7abd9e6b5553")]
internal class ItemMoveHandlerPlugIn : IPacketHandlerPlugIn
{
    private readonly MoveItemAction _moveAction = new();

    /// <inheritdoc/>
    public bool IsEncryptionExpected => false;

    /// <inheritdoc/>
    public byte Key => ItemMoveRequest.Code;

    /// <inheritdoc/>
    public async ValueTask HandlePacketAsync(Player player, Memory<byte> packet)
    {
        ItemMoveRequest message = packet;

        // to make it compatible with multiple versions, we just handle the data which is coming after that manually
        var itemSize = 12;
        if (player is RemotePlayer remotePlayer)
        {
            itemSize = remotePlayer.ItemSerializer.NeededSpace;
        }

        var toStorage = (ItemStorageKind)packet.Span[5 + itemSize];
        byte toSlot = packet.Span[6 + itemSize];

        await this._moveAction.MoveItemAsync(player, message.FromSlot, message.FromStorage.Convert(), toSlot, toStorage.Convert()).ConfigureAwait(false);
    }
}
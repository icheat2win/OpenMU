// <copyright file="PickupItemHandlerPlugIn075.cs" company="MUnique">
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
/// Handler for item pickup packets for client version 0.75.
/// </summary>
/// <remarks>
/// <para>
/// This is the legacy version of the pickup handler for MU Online client version 0.75.
/// The packet structure and logic are identical to the newer version, but encryption
/// is not expected (IsEncryptionExpected = false).
/// </para>
/// <para>
/// <strong>Packet Structure (C3 07 22):</strong>
/// Same as <see cref="PickupItemHandlerPlugIn"/> but without encryption.
/// </para>
/// <para>
/// See <see cref="PickupItemHandlerPlugIn"/> for detailed packet structure,
/// validation rules, and response behavior.
/// </para>
/// </remarks>
[PlugIn("PickupItemHandlerPlugIn 0.75", "Handler for item pickup packets for version 0.75.")]
[Guid("185512C3-F5B7-489F-A1C1-DF07146560A4")]
[MinimumClient(0, 75, ClientLanguage.Invariant)]
internal class PickupItemHandlerPlugIn075 : IPacketHandlerPlugIn
{
    private readonly PickupItemAction _pickupAction = new();

    /// <inheritdoc />
    public bool IsEncryptionExpected => false;

    /// <inheritdoc/>
    public byte Key => PickupItemRequest.Code;

    /// <inheritdoc/>
    public async ValueTask HandlePacketAsync(Player player, Memory<byte> packet)
    {
        PickupItemRequest075 message = packet;
        await this._pickupAction.PickupItemAsync(player, message.ItemId).ConfigureAwait(false);
    }
}
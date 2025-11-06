// <copyright file="TradeAcceptHandlerPlugIn.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.GameServer.MessageHandler.Trade;

using System.Runtime.InteropServices;
using MUnique.OpenMU.GameLogic;
using MUnique.OpenMU.GameLogic.PlayerActions.Trade;
using MUnique.OpenMU.Network.Packets.ClientToServer;
using MUnique.OpenMU.PlugIns;

/// <summary>
/// Packet Handler which is called when a trade request gets answered by the player.
/// </summary>
/// <remarks>
/// <para><strong>Packet Structure:</strong></para>
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
///     <term>Packet Type (0xC1)</term>
///   </item>
///   <item>
///     <term>1</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Packet Length (0x04)</term>
///   </item>
///   <item>
///     <term>2</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Packet Code (0x37)</term>
///   </item>
///   <item>
///     <term>3</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Trade Accepted (0x00 = Declined, 0x01 = Accepted)</term>
///   </item>
/// </list>
///
/// <para><strong>Response Types:</strong></para>
/// <list type="table">
///   <listheader>
///     <term>Value</term>
///     <term>Meaning</term>
///     <term>Result</term>
///   </listheader>
///   <item>
///     <term>0x00</term>
///     <term>Declined</term>
///     <term>Trade request cancelled, both players notified</term>
///   </item>
///   <item>
///     <term>0x01</term>
///     <term>Accepted</term>
///     <term>Trade window opens for both players</term>
///   </item>
/// </list>
///
/// <para><strong>Validation Rules:</strong></para>
/// <list type="bullet">
///   <item><description>Player must have a pending trade request</description></item>
///   <item><description>Trade partner must still be online and in range</description></item>
///   <item><description>Neither player can be in another trade</description></item>
///   <item><description>Response must arrive within timeout period (~30 seconds)</description></item>
///   <item><description>Both players must still meet trade requirements (not dead, not in vendor, etc.)</description></item>
/// </list>
///
/// <para><strong>Success Response (Accepted):</strong></para>
/// <list type="bullet">
///   <item><description>Both players receive ShowTradeWindowPlugIn to open trade interface</description></item>
///   <item><description>Trade state changes from TradeRequested to TradeOpened</description></item>
///   <item><description>Both players can now add items and money to the trade</description></item>
///   <item><description>Trade window displays empty slots for items and money input fields</description></item>
/// </list>
///
/// <para><strong>Success Response (Declined):</strong></para>
/// <list type="bullet">
///   <item><description>Requester receives ShowMessagePlugIn: "[Player] declined the trade."</description></item>
///   <item><description>Trade state reset to None for both players</description></item>
///   <item><description>No trade window opens</description></item>
/// </list>
///
/// <para><strong>Failure Responses:</strong></para>
/// <list type="table">
///   <listheader>
///     <term>Condition</term>
///     <term>Response</term>
///   </listheader>
///   <item>
///     <term>No Pending Request</term>
///     <term>Silently ignored or ShowMessagePlugIn: "No trade request pending."</term>
///   </item>
///   <item>
///     <term>Partner Offline</term>
///     <term>ShowMessagePlugIn: "Trade partner is no longer available."</term>
///   </item>
///   <item>
///     <term>Inventory Full</term>
///     <term>ShowMessagePlugIn: "Not enough inventory space."</term>
///   </item>
///   <item>
///     <term>Request Timeout</term>
///     <term>ShowMessagePlugIn: "Trade request expired."</term>
///   </item>
/// </list>
/// </remarks>
[PlugIn("TradeAcceptHandlerPlugIn", "Packet Handler which is called when a trade request gets answered by the player.")]
[Guid("79014c54-17a3-4e5e-85be-3e9c6051dbef")]
internal class TradeAcceptHandlerPlugIn : IPacketHandlerPlugIn
{
    private readonly TradeAcceptAction _acceptAction = new();

    /// <inheritdoc/>
    public bool IsEncryptionExpected => false;

    /// <inheritdoc/>
    public byte Key => TradeRequestResponse.Code;

    /// <inheritdoc/>
    /// <summary>The packet looks like: 0xC1, 0x04, 0x37, 0x01.</summary>
    public async ValueTask HandlePacketAsync(Player player, Memory<byte> packet)
    {
        TradeRequestResponse message = packet;
        await this._acceptAction.HandleTradeAcceptAsync(player, message.TradeAccepted).ConfigureAwait(false);
    }
}
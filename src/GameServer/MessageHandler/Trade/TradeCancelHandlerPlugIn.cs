// <copyright file="TradeCancelHandlerPlugIn.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.GameServer.MessageHandler.Trade;

using System.Runtime.InteropServices;
using MUnique.OpenMU.GameLogic;
using MUnique.OpenMU.GameLogic.PlayerActions.Trade;
using MUnique.OpenMU.Network.Packets.ClientToServer;
using MUnique.OpenMU.PlugIns;

/// <summary>
/// Handles the trade cancel packets.
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
///     <term>Packet Length (0x03)</term>
///   </item>
///   <item>
///     <term>2</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Packet Code (0x3D)</term>
///   </item>
/// </list>
///
/// <para><strong>Cancel Scenarios:</strong></para>
/// <list type="bullet">
///   <item><description><strong>Manual Cancel:</strong> Player clicks cancel button in trade window</description></item>
///   <item><description><strong>Window Close:</strong> Player closes trade window via ESC or X button</description></item>
///   <item><description><strong>Movement Cancel:</strong> Player moves too far from trade partner (>15 tiles)</description></item>
///   <item><description><strong>State Change Cancel:</strong> Player enters invalid state (dies, enters vendor, etc.)</description></item>
///   <item><description><strong>Timeout Cancel:</strong> Trade inactive for too long (auto-cancel after ~5 minutes)</description></item>
///   <item><description><strong>Disconnect Cancel:</strong> Either player disconnects from server</description></item>
/// </list>
///
/// <para><strong>Validation Rules:</strong></para>
/// <list type="bullet">
///   <item><description>Player must be in an active trade (TradeOpened or TradeButtonPressed state)</description></item>
///   <item><description>All items in trade window must be returned to original owners</description></item>
///   <item><description>Money amounts must be returned to original owners</description></item>
///   <item><description>Both players receive notification of cancellation</description></item>
/// </list>
///
/// <para><strong>Success Response:</strong></para>
/// <list type="bullet">
///   <item><description>Both players receive TradeCancelledPlugIn notification</description></item>
///   <item><description>Trade window closes for both players</description></item>
///   <item><description>All items return to their original inventory slots</description></item>
///   <item><description>Money amounts restored to both players</description></item>
///   <item><description>Trade state reset to None for both players</description></item>
///   <item><description>Players can move and perform other actions again</description></item>
/// </list>
///
/// <para><strong>Failure Responses:</strong></para>
/// <list type="table">
///   <listheader>
///     <term>Condition</term>
///     <term>Response</term>
///   </listheader>
///   <item>
///     <term>No Active Trade</term>
///     <term>Silently ignored</term>
///   </item>
///   <item>
///     <term>Inventory Full</term>
///     <term>Items dropped to ground or trade paused until space available</term>
///   </item>
/// </list>
///
/// <para><strong>Automatic Cancel Triggers:</strong></para>
/// <list type="bullet">
///   <item><description>Distance between players exceeds 15 tiles</description></item>
///   <item><description>Either player dies or enters dead state</description></item>
///   <item><description>Either player opens NPC vendor window</description></item>
///   <item><description>Either player enters portal or warps to different map</description></item>
///   <item><description>Either player logs out or disconnects</description></item>
///   <item><description>Server shutdown or maintenance mode</description></item>
/// </list>
/// </remarks>
[PlugIn("TradeCancelHandlerPlugIn", "Handles the trade cancel packets.")]
[Guid("13c7ba03-0ec2-4f41-bc0a-30fb9a035240")]
internal class TradeCancelHandlerPlugIn : IPacketHandlerPlugIn
{
    private readonly TradeCancelAction _cancelHandler = new();

    /// <inheritdoc/>
    public bool IsEncryptionExpected => false;

    /// <inheritdoc/>
    public byte Key => TradeCancel.Code;

    /// <inheritdoc/>
    public async ValueTask HandlePacketAsync(Player player, Memory<byte> packet)
    {
        await this._cancelHandler.CancelTradeAsync(player).ConfigureAwait(false);
    }
}
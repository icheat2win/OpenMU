// <copyright file="TradeMoneyHandlerPlugIn.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.GameServer.MessageHandler.Trade;

using System.Runtime.InteropServices;
using MUnique.OpenMU.GameLogic;
using MUnique.OpenMU.GameLogic.PlayerActions.Trade;
using MUnique.OpenMU.Network.Packets.ClientToServer;
using MUnique.OpenMU.PlugIns;

/// <summary>
/// Handles the trade money packets.
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
///     <term>Packet Length (0x07)</term>
///   </item>
///   <item>
///     <term>2</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Packet Code (0x3A)</term>
///   </item>
///   <item>
///     <term>3</term>
///     <term>4</term>
///     <term>uint</term>
///     <term>Money Amount (0 to 2,000,000,000 Zen)</term>
///   </item>
/// </list>
///
/// <para><strong>Money System Rules:</strong></para>
/// <list type="bullet">
///   <item><description><strong>Maximum Amount:</strong> 2,000,000,000 Zen per trade (uint max / 2)</description></item>
///   <item><description><strong>Minimum Amount:</strong> 0 Zen (can trade items without money)</description></item>
///   <item><description><strong>Real-time Updates:</strong> Money changes visible to both players immediately</description></item>
///   <item><description><strong>Validation:</strong> Amount must not exceed player's current money balance</description></item>
///   <item><description><strong>Button Reset:</strong> Changing money resets trade button to unpressed state</description></item>
/// </list>
///
/// <para><strong>Validation Rules:</strong></para>
/// <list type="bullet">
///   <item><description>Player must be in TradeOpened state (trade window open)</description></item>
///   <item><description>Amount must not exceed player's current money (player.Money >= Amount)</description></item>
///   <item><description>Amount must be non-negative (>= 0)</description></item>
///   <item><description>Amount must not cause overflow when added to partner's money</description></item>
///   <item><description>Both players must have pressed trade button again after money change</description></item>
///   <item><description>Trade partner must still be in range and online</description></item>
/// </list>
///
/// <para><strong>Success Response:</strong></para>
/// <list type="bullet">
///   <item><description>Both players receive TradeMoneySetPlugIn with updated amount</description></item>
///   <item><description>Money amount displayed in trade window for both players</description></item>
///   <item><description>If trade button was pressed, it resets to unpressed state</description></item>
///   <item><description>Both players must re-confirm trade after money change</description></item>
///   <item><description>Money not actually transferred until trade completion</description></item>
/// </list>
///
/// <para><strong>Failure Responses:</strong></para>
/// <list type="table">
///   <listheader>
///     <term>Condition</term>
///     <term>Response</term>
///   </listheader>
///   <item>
///     <term>Insufficient Money</term>
///     <term>ShowMessagePlugIn: "Not enough money." + Trade cancelled</term>
///   </item>
///   <item>
///     <term>Not In Trade</term>
///     <term>Silently ignored</term>
///   </item>
///   <item>
///     <term>Overflow Risk</term>
///     <term>ShowMessagePlugIn: "Money amount too large." + Trade cancelled</term>
///   </item>
///   <item>
///     <term>Negative Amount</term>
///     <term>Silently clamped to 0 or trade cancelled</term>
///   </item>
/// </list>
///
/// <para><strong>Trade Completion Money Transfer:</strong></para>
/// <list type="bullet">
///   <item><description>Money amounts locked when both players press trade button</description></item>
///   <item><description>Atomic transaction: both money transfers succeed or both fail</description></item>
///   <item><description>Player A money: (Current - OfferAmount + ReceiveAmount)</description></item>
///   <item><description>Player B money: (Current - OfferAmount + ReceiveAmount)</description></item>
///   <item><description>If either transfer would cause overflow, trade is cancelled</description></item>
/// </list>
/// </remarks>
[PlugIn("TradeMoneyHandlerPlugIn", "Handles the trade money packets.")]
[Guid("3c18f0ca-4ad8-4e07-a111-0acbe81256ca")]
internal class TradeMoneyHandlerPlugIn : IPacketHandlerPlugIn
{
    private readonly TradeMoneyAction _tradeAction = new();

    /// <inheritdoc/>
    public bool IsEncryptionExpected => false;

    /// <inheritdoc/>
    public byte Key => SetTradeMoney.Code;

    /// <inheritdoc/>
    public async ValueTask HandlePacketAsync(Player player, Memory<byte> packet)
    {
        SetTradeMoney message = packet;
        await this._tradeAction.TradeMoneyAsync(player, message.Amount).ConfigureAwait(false);
    }
}
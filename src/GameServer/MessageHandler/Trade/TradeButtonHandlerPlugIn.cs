// <copyright file="TradeButtonHandlerPlugIn.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.GameServer.MessageHandler.Trade;

using System.Runtime.InteropServices;
using MUnique.OpenMU.GameLogic;
using MUnique.OpenMU.GameLogic.PlayerActions.Trade;
using MUnique.OpenMU.Network.Packets.ClientToServer;
using MUnique.OpenMU.PlugIns;
using TradeButtonState = MUnique.OpenMU.GameLogic.Views.Trade.TradeButtonState;

/// <summary>
/// Handles the trade button packets.
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
///     <term>Packet Code (0x3C)</term>
///   </item>
///   <item>
///     <term>3</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Button State (TradeButtonState enum value)</term>
///   </item>
/// </list>
///
/// <para><strong>Trade Button States:</strong></para>
/// <list type="table">
///   <listheader>
///     <term>Value</term>
///     <term>State</term>
///     <term>Meaning</term>
///   </listheader>
///   <item>
///     <term>0x00</term>
///     <term>Unchecked</term>
///     <term>Player unpressed trade button (changed items/money)</term>
///   </item>
///   <item>
///     <term>0x01</term>
///     <term>Checked</term>
///     <term>Player pressed trade button (ready to complete)</term>
///   </item>
///   <item>
///     <term>0x02</term>
///     <term>Red</term>
///     <term>Both players ready, final confirmation (Season 6+)</term>
///   </item>
/// </list>
///
/// <para><strong>Trade Confirmation Flow:</strong></para>
/// <list type="number">
///   <item><description><strong>Initial:</strong> Both buttons unchecked (Unchecked)</description></item>
///   <item><description><strong>Player A Ready:</strong> Player A presses button (Checked), button turns yellow/gray</description></item>
///   <item><description><strong>Player B Ready:</strong> Player B presses button (Checked)</description></item>
///   <item><description><strong>Final Check (S6+):</strong> Both buttons turn red (Red state), requires final click</description></item>
///   <item><description><strong>Completion:</strong> Trade executes when both in final confirmation</description></item>
///   <item><description><strong>Reset:</strong> Any item/money change resets both buttons to Unchecked</description></item>
/// </list>
///
/// <para><strong>Validation Rules:</strong></para>
/// <list type="bullet">
///   <item><description>Player must be in TradeOpened state</description></item>
///   <item><description>Items and money must not have changed since last button press</description></item>
///   <item><description>Both players must have enough inventory space for received items</description></item>
///   <item><description>Money transfer must not cause overflow for either player</description></item>
///   <item><description>Trade partner must still be online and in range</description></item>
///   <item><description>Items must still be valid and not expired/deleted</description></item>
/// </list>
///
/// <para><strong>Success Response (Button Pressed):</strong></para>
/// <list type="bullet">
///   <item><description>Both players receive TradeButtonStateChangePlugIn with updated button states</description></item>
///   <item><description>If only one ready: waiting for partner to press button</description></item>
///   <item><description>If both ready (pre-S6): trade completes immediately</description></item>
///   <item><description>If both ready (S6+): buttons turn red, require final confirmation</description></item>
/// </list>
///
/// <para><strong>Success Response (Trade Complete):</strong></para>
/// <list type="bullet">
///   <item><description>Items transferred atomically between players</description></item>
///   <item><description>Money transferred atomically between players</description></item>
///   <item><description>Both players receive TradeFinishedPlugIn notification</description></item>
///   <item><description>Trade window closes for both players</description></item>
///   <item><description>Inventory and money updated for both players</description></item>
///   <item><description>Trade state reset to None</description></item>
/// </list>
///
/// <para><strong>Failure Responses:</strong></para>
/// <list type="table">
///   <listheader>
///     <term>Condition</term>
///     <term>Response</term>
///   </listheader>
///   <item>
///     <term>Inventory Full</term>
///     <term>ShowMessagePlugIn: "Not enough inventory space." + Trade cancelled</term>
///   </item>
///   <item>
///     <term>Money Overflow</term>
///     <term>ShowMessagePlugIn: "Cannot receive that much money." + Trade cancelled</term>
///   </item>
///   <item>
///     <term>Item Changed</term>
///     <term>Button reset to Unchecked, ShowMessagePlugIn: "Trade items changed."</term>
///   </item>
///   <item>
///     <term>Partner Disconnected</term>
///     <term>Trade cancelled, items/money returned</term>
///   </item>
/// </list>
///
/// <para><strong>Version Differences:</strong></para>
/// <list type="bullet">
///   <item><description><strong>Pre-Season 6:</strong> Two-state button (Unchecked/Checked), completes immediately when both checked</description></item>
///   <item><description><strong>Season 6+:</strong> Three-state button (Unchecked/Checked/Red), requires double confirmation</description></item>
///   <item><description>Red state provides extra protection against accidental trades</description></item>
/// </list>
/// </remarks>
[PlugIn("TradeButtonHandlerPlugIn", "Handles the trade button packets.")]
[Guid("4e70bdec-c890-4e7d-93a9-1801f821f322")]
internal class TradeButtonHandlerPlugIn : IPacketHandlerPlugIn
{
    private readonly TradeButtonAction _buttonAction = new();

    /// <inheritdoc/>
    public bool IsEncryptionExpected => false;

    /// <inheritdoc/>
    public byte Key => TradeButtonStateChange.Code;

    /// <inheritdoc/>
    public async ValueTask HandlePacketAsync(Player player, Memory<byte> packet)
    {
        TradeButtonStateChange message = packet;
        if (packet.Length < 4)
        {
            return;
        }

        await this._buttonAction.TradeButtonChangedAsync(player, (TradeButtonState)message.NewState).ConfigureAwait(false);
    }
}
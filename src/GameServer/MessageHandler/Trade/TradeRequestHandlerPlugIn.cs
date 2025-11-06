// <copyright file="TradeRequestHandlerPlugIn.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.GameServer.MessageHandler.Trade;

using System.Runtime.InteropServices;
using MUnique.OpenMU.GameLogic;
using MUnique.OpenMU.GameLogic.PlayerActions.Trade;
using MUnique.OpenMU.GameLogic.Views;
using MUnique.OpenMU.Interfaces;
using MUnique.OpenMU.Network.Packets.ClientToServer;
using MUnique.OpenMU.PlugIns;

/// <summary>
/// Handles the trade request packets.
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
///     <term>Packet Length (0x05)</term>
///   </item>
///   <item>
///     <term>2</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Packet Code (0x36)</term>
///   </item>
///   <item>
///     <term>3</term>
///     <term>2</term>
///     <term>ushort</term>
///     <term>Target Player ID (visible player's object ID)</term>
///   </item>
/// </list>
///
/// <para><strong>Trade System Overview:</strong></para>
/// <list type="number">
///   <item><description><strong>Request Phase:</strong> Player A sends trade request to Player B (this handler)</description></item>
///   <item><description><strong>Accept Phase:</strong> Player B accepts or rejects the request (TradeAcceptHandlerPlugIn)</description></item>
///   <item><description><strong>Negotiation Phase:</strong> Both players add items and money (TradeMoneyHandlerPlugIn)</description></item>
///   <item><description><strong>Confirmation Phase:</strong> Both players press trade button (TradeButtonHandlerPlugIn)</description></item>
///   <item><description><strong>Completion Phase:</strong> Items and money exchanged, trade window closes</description></item>
///   <item><description><strong>Cancel:</strong> Either player can cancel at any time (TradeCancelHandlerPlugIn)</description></item>
/// </list>
///
/// <para><strong>Validation Rules:</strong></para>
/// <list type="bullet">
///   <item><description>Target player must be in visible range (~15 tiles)</description></item>
///   <item><description>Both players must not already be in a trade</description></item>
///   <item><description>Both players must not be in restricted states (dead, vendor window open, etc.)</description></item>
///   <item><description>Target player ID must be valid and correspond to an online player</description></item>
///   <item><description>Players cannot trade with themselves</description></item>
///   <item><description>Both players must be on the same map</description></item>
///   <item><description>Trade requests may have cooldown to prevent spam</description></item>
/// </list>
///
/// <para><strong>Success Response:</strong></para>
/// <list type="bullet">
///   <item><description>Sender receives trade window open notification (waiting for partner response)</description></item>
///   <item><description>Target receives trade request dialog via ShowTradeRequestPlugIn</description></item>
///   <item><description>Target has limited time to accept/reject (~30 seconds timeout)</description></item>
///   <item><description>Both players' trade flags set to prevent duplicate trades</description></item>
/// </list>
///
/// <para><strong>Failure Responses:</strong></para>
/// <list type="table">
///   <listheader>
///     <term>Condition</term>
///     <term>Response</term>
///   </listheader>
///   <item>
///     <term>Target Not Found</term>
///     <term>ShowMessagePlugIn: "Trade partner not found."</term>
///   </item>
///   <item>
///     <term>Already In Trade</term>
///     <term>ShowMessagePlugIn: "You are already trading."</term>
///   </item>
///   <item>
///     <term>Target Busy</term>
///     <term>ShowMessagePlugIn: "[Player] is busy."</term>
///   </item>
///   <item>
///     <term>Out Of Range</term>
///     <term>ShowMessagePlugIn: "Target is too far away."</term>
///   </item>
///   <item>
///     <term>Trade Declined</term>
///     <term>ShowMessagePlugIn: "[Player] declined the trade."</term>
///   </item>
///   <item>
///     <term>Request Timeout</term>
///     <term>Trade request automatically canceled after timeout</term>
///   </item>
/// </list>
///
/// <para><strong>Trade States:</strong></para>
/// <list type="bullet">
///   <item><description><strong>None:</strong> No active trade</description></item>
///   <item><description><strong>TradeRequested:</strong> Request sent, waiting for response</description></item>
///   <item><description><strong>TradeOpened:</strong> Both accepted, trade window open</description></item>
///   <item><description><strong>TradeButtonPressed:</strong> Player pressed trade button (ready to complete)</description></item>
///   <item><description><strong>TradeFinished:</strong> Trade completed successfully</description></item>
///   <item><description><strong>TradeCancelled:</strong> Trade cancelled by either player</description></item>
/// </list>
/// </remarks>
[PlugIn("TradeRequestHandlerPlugIn", "Handles the trade request packets.")]
[Guid("f2b8c4c0-2e9d-4f1f-8c42-76b0312e4021")]
internal class TradeRequestHandlerPlugIn : IPacketHandlerPlugIn
{
    private readonly TradeRequestAction _requestAction = new();

    /// <inheritdoc/>
    public bool IsEncryptionExpected => true;

    /// <inheritdoc/>
    public byte Key => TradeRequest.Code;

    /// <inheritdoc/>
    public async ValueTask HandlePacketAsync(Player player, Memory<byte> packet)
    {
        TradeRequest message = packet;
        var partner = await player.GetObservingPlayerWithIdAsync(message.PlayerId).ConfigureAwait(false);
        if (partner is null)
        {
            await player.InvokeViewPlugInAsync<IShowMessagePlugIn>(p => p.ShowMessageAsync("Trade partner not found.", MessageType.BlueNormal)).ConfigureAwait(false);
            return;
        }

        await this._requestAction.RequestTradeAsync(player, partner).ConfigureAwait(false);
    }
}
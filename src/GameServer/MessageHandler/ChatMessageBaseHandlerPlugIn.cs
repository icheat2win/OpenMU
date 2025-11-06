// <copyright file="ChatMessageBaseHandlerPlugIn.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.GameServer.MessageHandler;

using MUnique.OpenMU.GameLogic;
using MUnique.OpenMU.GameLogic.PlayerActions;
using MUnique.OpenMU.GameLogic.PlayerActions.Chat;
using MUnique.OpenMU.Network.Packets.ClientToServer;

/// <summary>
/// Base class for a chat message handler.
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
///     <term>Packet Length (Variable)</term>
///   </item>
///   <item>
///     <term>2</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Packet Code (0x00 = Public Chat, 0x02 = Whisper)</term>
///   </item>
///   <item>
///     <term>3</term>
///     <term>10</term>
///     <term>string</term>
///     <term>Receiver Name (null-terminated, only used for whispers)</term>
///   </item>
///   <item>
///     <term>13</term>
///     <term>Variable</term>
///     <term>string</term>
///     <term>Message Text (null-terminated, max ~60 characters)</term>
///   </item>
/// </list>
///
/// <para><strong>Chat Types:</strong></para>
/// <list type="table">
///   <listheader>
///     <term>Type</term>
///     <term>Code</term>
///     <term>Receiver Name</term>
///     <term>Broadcast Scope</term>
///   </listheader>
///   <item>
///     <term>Public Chat</term>
///     <term>0x00</term>
///     <term>Ignored</term>
///     <term>All players in visible range (~15 tiles)</term>
///   </item>
///   <item>
///     <term>Whisper</term>
///     <term>0x02</term>
///     <term>Target player name</term>
///     <term>Only the specified receiver</term>
///   </item>
///   <item>
///     <term>Guild Chat</term>
///     <term>Handled separately</term>
///     <term>N/A</term>
///     <term>All guild members online</term>
///   </item>
///   <item>
///     <term>Party Chat</term>
///     <term>Handled separately</term>
///     <term>N/A</term>
///     <term>All party members</term>
///   </item>
///   <item>
///     <term>Alliance Chat</term>
///     <term>Handled separately</term>
///     <term>N/A</term>
///     <term>All alliance members online</term>
///   </item>
/// </list>
///
/// <para><strong>Validation Rules:</strong></para>
/// <list type="bullet">
///   <item><description>Message length must not exceed maximum allowed characters (~60)</description></item>
///   <item><description>Player must not be muted or chat-banned</description></item>
///   <item><description>Player must not be in a restricted state (e.g., dead, trading)</description></item>
///   <item><description>For whispers: receiver name must be valid and player must be online</description></item>
///   <item><description>Rate limiting: prevents chat spam (configurable cooldown)</description></item>
///   <item><description>Message must not contain only whitespace</description></item>
///   <item><description>Message encoding: UTF-8 or ASCII depending on client version</description></item>
/// </list>
///
/// <para><strong>Success Response:</strong></para>
/// <list type="bullet">
///   <item><description>Public Chat: Message broadcast to all nearby players via ShowMessagePlugIn</description></item>
///   <item><description>Whisper: Message sent to receiver via ShowMessagePlugIn, sender receives confirmation</description></item>
///   <item><description>Message includes sender name, message text, and chat type indicator</description></item>
/// </list>
///
/// <para><strong>Failure Responses:</strong></para>
/// <list type="table">
///   <listheader>
///     <term>Condition</term>
///     <term>Response</term>
///   </listheader>
///   <item>
///     <term>Player Muted</term>
///     <term>ShowMessagePlugIn with "You are muted" message</term>
///   </item>
///   <item>
///     <term>Receiver Not Found</term>
///     <term>ShowMessagePlugIn with "[Receiver] is not online" message</term>
///   </item>
///   <item>
///     <term>Message Too Long</term>
///     <term>Silently truncated or rejected</term>
///   </item>
///   <item>
///     <term>Rate Limited</term>
///     <term>ShowMessagePlugIn with "Chat too fast" warning</term>
///   </item>
///   <item>
///     <term>Empty Message</term>
///     <term>Silently ignored</term>
///   </item>
/// </list>
///
/// <para><strong>Version Differences:</strong></para>
/// <list type="bullet">
///   <item><description>Season 6+: Supports UTF-8 encoding for international characters</description></item>
///   <item><description>0.97d: ASCII encoding only, limited character set</description></item>
///   <item><description>0.75: ASCII encoding, no special character support</description></item>
/// </list>
///
/// <para><strong>Event Publishing:</strong></para>
/// <list type="bullet">
///   <item><description>ChatMessageReceivedEvent: Published for all chat messages (logging, moderation)</description></item>
///   <item><description>Event includes sender, receiver, message text, timestamp, chat type</description></item>
///   <item><description>Can be used by plugins for: chat filtering, profanity detection, logging, bot detection</description></item>
/// </list>
/// </remarks>
internal abstract class ChatMessageBaseHandlerPlugIn : IPacketHandlerPlugIn
{
    /// <inheritdoc/>
    public bool IsEncryptionExpected => false;

    /// <inheritdoc/>
    public abstract byte Key { get; }

    /// <summary>
    /// Gets a value indicating whether this instance is handling whisper messages.
    /// </summary>
    protected abstract bool IsWhisper { get; }

    /// <inheritdoc/>
    public async ValueTask HandlePacketAsync(Player player, Memory<byte> packet)
    {
        if (player.GameContext is not IGameServerContext gameServerContext)
        {
            return;
        }

        var messageAction = new ChatMessageAction(gameServerContext.EventPublisher);
        WhisperMessage message = packet;
        await messageAction.ChatMessageAsync(player, message.ReceiverName, message.Message, this.IsWhisper).ConfigureAwait(false);
    }
}
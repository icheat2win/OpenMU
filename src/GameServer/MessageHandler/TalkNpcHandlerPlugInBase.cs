// <copyright file="TalkNpcHandlerPlugInBase.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.GameServer.MessageHandler;

using MUnique.OpenMU.GameLogic;
using MUnique.OpenMU.GameLogic.NPC;
using MUnique.OpenMU.GameLogic.PlayerActions;
using MUnique.OpenMU.Network.Packets.ClientToServer;

/// <summary>
/// Handler for talk npc request packets.
/// </summary>
/// <remarks>
/// <para>
/// This handler processes client requests to interact with NPCs. When a player
/// double-clicks or otherwise interacts with an NPC, the client sends this packet
/// to initiate dialog or access NPC services (shop, vault, quest, etc.).
/// </para>
/// <para>
/// <strong>Packet Structure (C3 05 30):</strong>
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
///     <term>Packet size (0x05)</term>
///   </item>
///   <item>
///     <term>2</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Packet type (0x30 - Talk to NPC)</term>
///   </item>
///   <item>
///     <term>3-4</term>
///     <term>2</term>
///     <term>ushort</term>
///     <term>NPC ID (server-assigned object identifier)</term>
///   </item>
/// </list>
/// </para>
/// <para>
/// <strong>NPC Types and Responses:</strong>
/// <list type="table">
///   <listheader>
///     <term>NPC Type</term>
///     <term>Window Opened</term>
///     <term>Description</term>
///   </listheader>
///   <item>
///     <term>Merchant</term>
///     <term>Shop Window</term>
///     <term>Opens NPC shop with buy/sell functionality</term>
///   </item>
///   <item>
///     <term>Vault Keeper</term>
///     <term>Vault Window</term>
///     <term>Opens personal vault for item storage</term>
///   </item>
///   <item>
///     <term>Quest NPC</term>
///     <term>Quest Dialog</term>
///     <term>Shows quest information and accept/complete options</term>
///   </item>
///   <item>
///     <term>Guild Master</term>
///     <term>Guild Window</term>
///     <term>Opens guild creation/management interface</term>
///   </item>
///   <item>
///     <term>Pet Trainer</term>
///     <term>Pet Window</term>
///     <term>Opens pet training and evolution interface</term>
///   </item>
///   <item>
///     <term>Chaos Goblin</term>
///     <term>Chaos Machine</term>
///     <term>Opens item crafting/mixing interface</term>
///   </item>
///   <item>
///     <term>Castle Siege NPC</term>
///     <term>Siege Management</term>
///     <term>Opens castle siege registration/status interface</term>
///   </item>
///   <item>
///     <term>Warp Gate</term>
///     <term>Warp List</term>
///     <term>Shows available warp destinations</term>
///   </item>
/// </list>
/// </para>
/// <para>
/// <strong>Validation and Error Conditions:</strong>
/// <list type="bullet">
///   <item><description>NPC must exist on the current map with the specified ID</description></item>
///   <item><description>NPC must be within interaction range (typically 5 tiles)</description></item>
///   <item><description>Player must not be in combat, trade, or other restricted state</description></item>
///   <item><description>Player must meet NPC requirements (level, class, quest state)</description></item>
///   <item><description>Some NPCs are only accessible during specific events or times</description></item>
/// </list>
/// </para>
/// <para>
/// <strong>Success Response:</strong> Server sends appropriate window opening packet
/// based on NPC type. Client displays the corresponding UI (shop, vault, dialog, etc.).
/// </para>
/// <para>
/// <strong>Failure Response:</strong> If NPC is not found or player cannot interact,
/// no response is sent or an error message is displayed.
/// </para>
/// <para>
/// <strong>Implementation Notes:</strong> This base class is inherited by version-specific
/// handlers (TalkNpcHandlerPlugIn, TalkNpcHandlerPlugIn075) which differ only in
/// encryption expectations.
/// </para>
/// </remarks>
internal abstract class TalkNpcHandlerPlugInBase : IPacketHandlerPlugIn
{
    /// <inheritdoc/>
    public virtual bool IsEncryptionExpected => false;

    /// <inheritdoc/>
    public byte Key => TalkToNpcRequest.Code;

    /// <summary>
    /// Gets the talk NPC action.
    /// </summary>
    protected abstract TalkNpcAction TalkNpcAction { get; }

    /// <inheritdoc/>
    public async ValueTask HandlePacketAsync(Player player, Memory<byte> packet)
    {
        TalkToNpcRequest message = packet;
        if (player.CurrentMap?.GetObject(message.NpcId) is NonPlayerCharacter npc)
        {
            await this.TalkNpcAction.TalkToNpcAsync(player, npc).ConfigureAwait(false);
        }
    }
}
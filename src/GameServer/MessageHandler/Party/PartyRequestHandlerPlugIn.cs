// <copyright file="PartyRequestHandlerPlugIn.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.GameServer.MessageHandler.Party;

using System.Runtime.InteropServices;
using MUnique.OpenMU.GameLogic;
using MUnique.OpenMU.GameLogic.PlayerActions.Party;
using MUnique.OpenMU.Network.Packets.ClientToServer;
using MUnique.OpenMU.PlugIns;

/// <summary>
/// Handler for party request packets.
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
///     <term>Packet Code (0x40)</term>
///   </item>
///   <item>
///     <term>3</term>
///     <term>2</term>
///     <term>ushort</term>
///     <term>Target Player ID (visible player's object ID)</term>
///   </item>
/// </list>
///
/// <para><strong>Party System Overview:</strong></para>
/// <list type="bullet">
///   <item><description><strong>Maximum Size:</strong> 5 players per party</description></item>
///   <item><description><strong>Leader:</strong> First player who creates the party</description></item>
///   <item><description><strong>Experience Sharing:</strong> Bonus experience when hunting together</description></item>
///   <item><description><strong>Item Distribution:</strong> Random or round-robin item drops</description></item>
///   <item><description><strong>Health Bars:</strong> Party members can see each other's HP/Mana</description></item>
///   <item><description><strong>Party Chat:</strong> Private chat channel for party members</description></item>
/// </list>
///
/// <para><strong>Validation Rules:</strong></para>
/// <list type="bullet">
///   <item><description>Target player must be in visible range (~15 tiles)</description></item>
///   <item><description>Requester must not already be in a full party (5 members)</description></item>
///   <item><description>Target must not already be in a party or have pending invite</description></item>
///   <item><description>Target player ID must be valid and correspond to online player</description></item>
///   <item><description>Cannot invite yourself to a party</description></item>
///   <item><description>Both players must be on the same server</description></item>
///   <item><description>May have cooldown to prevent invite spam</description></item>
/// </list>
///
/// <para><strong>Success Response:</strong></para>
/// <list type="bullet">
///   <item><description>Target receives party invite dialog via ShowPartyRequestPlugIn</description></item>
///   <item><description>Invite includes requester's name and party size</description></item>
///   <item><description>Target has limited time to respond (~30 seconds timeout)</description></item>
///   <item><description>If accepted: target joins requester's party or new party created</description></item>
///   <item><description>All party members receive updated party list</description></item>
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
///     <term>ShowMessagePlugIn: "Player not found."</term>
///   </item>
///   <item>
///     <term>Party Full</term>
///     <term>ShowMessagePlugIn: "Party is full."</term>
///   </item>
///   <item>
///     <term>Target In Party</term>
///     <term>ShowMessagePlugIn: "[Player] is already in a party."</term>
///   </item>
///   <item>
///     <term>Invite Declined</term>
///     <term>ShowMessagePlugIn: "[Player] declined the party invitation."</term>
///   </item>
///   <item>
///     <term>Invite Timeout</term>
///     <term>Party request automatically cancelled</term>
///   </item>
/// </list>
/// </remarks>
[PlugIn("PartyRequestHandlerPlugIn", "Handler for party request packets.")]
[Guid("759d5b1a-a2f9-4de8-a03e-023a4810111d")]
internal class PartyRequestHandlerPlugIn : IPacketHandlerPlugIn
{
    private readonly PartyRequestAction _action = new();

    /// <inheritdoc/>
    public bool IsEncryptionExpected => false;

    /// <inheritdoc/>
    public byte Key => PartyInviteRequest.Code;

    /// <inheritdoc/>
    public async ValueTask HandlePacketAsync(Player player, Memory<byte> packet)
    {
        PartyInviteRequest message = packet;
        var toRequest = await player.GetObservingPlayerWithIdAsync(message.TargetPlayerId).ConfigureAwait(false);
        if (toRequest is null)
        {
            return;
        }

        await this._action.HandlePartyRequestAsync(player, toRequest).ConfigureAwait(false);
    }
}
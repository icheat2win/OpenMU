// <copyright file="PartyResponseHandlerPlugIn.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.GameServer.MessageHandler.Party;

using System.Runtime.InteropServices;
using MUnique.OpenMU.GameLogic;
using MUnique.OpenMU.GameLogic.PlayerActions.Party;
using MUnique.OpenMU.Network.Packets.ClientToServer;
using MUnique.OpenMU.PlugIns;

/// <summary>
/// Handler for party response packets.
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
///     <term>Packet Code (0x41)</term>
///   </item>
///   <item>
///     <term>3</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Accepted (0x00 = Declined, 0x01 = Accepted)</term>
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
///     <term>Party invite rejected, requester notified</term>
///   </item>
///   <item>
///     <term>0x01</term>
///     <term>Accepted</term>
///     <term>Player joins party, all members notified</term>
///   </item>
/// </list>
///
/// <para><strong>Party Formation Logic:</strong></para>
/// <list type="bullet">
///   <item><description><strong>First Member:</strong> If requester not in party, create new party with requester as leader</description></item>
///   <item><description><strong>Join Existing:</strong> If requester in party, add acceptor to existing party</description></item>
///   <item><description><strong>Leader Assignment:</strong> First player (requester) becomes permanent party leader</description></item>
///   <item><description><strong>Member Limit:</strong> Maximum 5 members total per party</description></item>
///   <item><description><strong>Party ID:</strong> Unique identifier assigned to party for tracking</description></item>
/// </list>
///
/// <para><strong>Validation Rules:</strong></para>
/// <list type="bullet">
///   <item><description>Player must have a pending party invite</description></item>
///   <item><description>Invite must not be expired (~30 seconds timeout)</description></item>
///   <item><description>Party must not be full (less than 5 members)</description></item>
///   <item><description>Player must not already be in another party</description></item>
///   <item><description>Requester must still be online</description></item>
/// </list>
///
/// <para><strong>Success Response (Accepted):</strong></para>
/// <list type="bullet">
///   <item><description>All party members receive ShowPartyMemberListPlugIn with updated roster</description></item>
///   <item><description>New member receives party UI activation</description></item>
///   <item><description>Party health bars enabled for all members</description></item>
///   <item><description>Experience sharing activated (bonus XP calculation)</description></item>
///   <item><description>Party chat channel becomes available</description></item>
///   <item><description>Requester receives ShowMessagePlugIn: "[Player] joined the party."</description></item>
/// </list>
///
/// <para><strong>Success Response (Declined):</strong></para>
/// <list type="bullet">
///   <item><description>Requester receives ShowMessagePlugIn: "[Player] declined the party invitation."</description></item>
///   <item><description>Invite cleared from both players</description></item>
///   <item><description>No party state changes</description></item>
/// </list>
///
/// <para><strong>Failure Responses:</strong></para>
/// <list type="table">
///   <listheader>
///     <term>Condition</term>
///     <term>Response</term>
///   </listheader>
///   <item>
///     <term>No Pending Invite</term>
///     <term>Silently ignored or ShowMessagePlugIn: "No party invite pending."</term>
///   </item>
///   <item>
///     <term>Party Full</term>
///     <term>ShowMessagePlugIn: "Party is full." + invite cancelled</term>
///   </item>
///   <item>
///     <term>Already In Party</term>
///     <term>ShowMessagePlugIn: "You are already in a party."</term>
///   </item>
///   <item>
///     <term>Requester Offline</term>
///     <term>ShowMessagePlugIn: "Player is no longer available."</term>
///   </item>
///   <item>
///     <term>Invite Expired</term>
///     <term>ShowMessagePlugIn: "Party invite expired."</term>
///   </item>
/// </list>
/// </remarks>
[PlugIn("PartyResponseHandlerPlugIn", "Handler for party response packets.")]
[Guid("bd1e7c33-a80e-439f-b8e2-b2c22a68126b")]
internal class PartyResponseHandlerPlugIn : IPacketHandlerPlugIn
{
    private readonly PartyResponseAction _action = new();

    /// <inheritdoc/>
    public bool IsEncryptionExpected => false;

    /// <inheritdoc/>
    public byte Key => PartyInviteResponse.Code;

    /// <inheritdoc/>
    public async ValueTask HandlePacketAsync(Player player, Memory<byte> packet)
    {
        PartyInviteResponse message = packet;
        await this._action.HandleResponseAsync(player, message.Accepted).ConfigureAwait(false);
    }
}
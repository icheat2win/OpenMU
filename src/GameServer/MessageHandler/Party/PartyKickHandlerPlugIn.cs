// <copyright file="PartyKickHandlerPlugIn.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.GameServer.MessageHandler.Party;

using System.Runtime.InteropServices;
using MUnique.OpenMU.GameLogic;
using MUnique.OpenMU.GameLogic.PlayerActions.Party;
using MUnique.OpenMU.Network.Packets.ClientToServer;
using MUnique.OpenMU.PlugIns;

/// <summary>
/// Handler for party kick packets.
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
///     <term>Packet Code (0x43)</term>
///   </item>
///   <item>
///     <term>3</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Player Index (0-4, position in party list)</term>
///   </item>
/// </list>
///
/// <para><strong>Party Kick Rules:</strong></para>
/// <list type="bullet">
///   <item><description><strong>Authority:</strong> Only party leader can kick members</description></item>
///   <item><description><strong>Self-Kick:</strong> Leader cannot kick themselves (must leave party instead)</description></item>
///   <item><description><strong>Index-Based:</strong> Uses player's position (0-4) in party list, not player ID</description></item>
///   <item><description><strong>Notification:</strong> All party members notified when someone is kicked</description></item>
///   <item><description><strong>State Cleanup:</strong> Kicked player's party state reset immediately</description></item>
/// </list>
///
/// <para><strong>Validation Rules:</strong></para>
/// <list type="bullet">
///   <item><description>Kicker must be the party leader</description></item>
///   <item><description>Player index must be valid (0-4)</description></item>
///   <item><description>Target player must exist in party at that index</description></item>
///   <item><description>Cannot kick yourself (use party leave instead)</description></item>
///   <item><description>Party must still be active</description></item>
/// </list>
///
/// <para><strong>Success Response:</strong></para>
/// <list type="bullet">
///   <item><description>Kicked player receives ShowPartyKickedPlugIn notification</description></item>
///   <item><description>Kicked player's party UI disabled, health bars removed</description></item>
///   <item><description>All remaining party members receive updated party list via ShowPartyMemberListPlugIn</description></item>
///   <item><description>Party experience sharing recalculated for remaining members</description></item>
///   <item><description>If only 1 member remains: party automatically disbanded</description></item>
/// </list>
///
/// <para><strong>Failure Responses:</strong></para>
/// <list type="table">
///   <listheader>
///     <term>Condition</term>
///     <term>Response</term>
///   </listheader>
///   <item>
///     <term>Not Party Leader</term>
///     <term>ShowMessagePlugIn: "Only the party leader can kick members."</term>
///   </item>
///   <item>
///     <term>Invalid Index</term>
///     <term>Silently ignored or ShowMessagePlugIn: "Invalid party member."</term>
///   </item>
///   <item>
///     <term>Not In Party</term>
///     <term>ShowMessagePlugIn: "You are not in a party."</term>
///   </item>
///   <item>
///     <term>Cannot Kick Self</term>
///     <term>ShowMessagePlugIn: "Use leave party to exit."</term>
///   </item>
/// </list>
///
/// <para><strong>Party Disbanding:</strong></para>
/// <list type="bullet">
///   <item><description>If kick reduces party to 1 member: party automatically disbanded</description></item>
///   <item><description>Last remaining member receives party disbanded notification</description></item>
///   <item><description>Party ID cleared from all former members</description></item>
///   <item><description>Party experience bonus deactivated</description></item>
/// </list>
/// </remarks>
[PlugIn("PartyKickHandlerPlugIn", "Handler for party kick packets.")]
[Guid("26d0fef9-8171-4098-87ae-030054163509")]
internal class PartyKickHandlerPlugIn : IPacketHandlerPlugIn
{
    private readonly PartyKickAction _action = new();

    /// <inheritdoc/>
    public bool IsEncryptionExpected => false;

    /// <inheritdoc/>
    public byte Key => (byte)PacketType.PartyKick;

    /// <inheritdoc/>
    public async ValueTask HandlePacketAsync(Player player, Memory<byte> packet)
    {
        PartyPlayerKickRequest message = packet;
        await this._action.KickPlayerAsync(player, message.PlayerIndex).ConfigureAwait(false);
    }
}
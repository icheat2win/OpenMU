// <copyright file="PartyListRequestHandlerPlugIn.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.GameServer.MessageHandler.Party;

using System.Runtime.InteropServices;
using MUnique.OpenMU.GameLogic;
using MUnique.OpenMU.GameLogic.PlayerActions.Party;
using MUnique.OpenMU.Network.Packets.ClientToServer;
using MUnique.OpenMU.PlugIns;

/// <summary>
/// Handler for party list request packets.
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
///     <term>Packet Code (0x42)</term>
///   </item>
/// </list>
///
/// <para><strong>Purpose:</strong></para>
/// <list type="bullet">
///   <item><description>Requests full party member list from server</description></item>
///   <item><description>Typically sent when opening party UI or joining party</description></item>
///   <item><description>Refreshes party member information (HP, Mana, position)</description></item>
///   <item><description>Updates after party composition changes (join, leave, kick)</description></item>
/// </list>
///
/// <para><strong>Party Member Information:</strong></para>
/// <list type="table">
///   <listheader>
///     <term>Field</term>
///     <term>Description</term>
///   </listheader>
///   <item>
///     <term>Name</term>
///     <term>Character name (max 10 characters)</term>
///   </item>
///   <item>
///     <term>Index</term>
///     <term>Position in party (0-4)</term>
///   </item>
///   <item>
///     <term>Map</term>
///     <term>Current map number</term>
///   </item>
///   <item>
///     <term>Coordinates</term>
///     <term>X, Y position on map</term>
///   </item>
///   <item>
///     <term>HP/Max HP</term>
///     <term>Current and maximum health points</term>
///   </item>
///   <item>
///     <term>SD/Max SD</term>
///     <term>Current and maximum shield points</term>
///   </item>
/// </list>
///
/// <para><strong>Validation Rules:</strong></para>
/// <list type="bullet">
///   <item><description>Player must be in a party</description></item>
///   <item><description>Party must be active</description></item>
///   <item><description>Request rate may be limited to prevent spam</description></item>
/// </list>
///
/// <para><strong>Success Response:</strong></para>
/// <list type="bullet">
///   <item><description>Server sends ShowPartyMemberListPlugIn with all party members</description></item>
///   <item><description>Response includes all party member details listed above</description></item>
///   <item><description>Members listed in order with leader at index 0</description></item>
///   <item><description>Client updates party UI with current member states</description></item>
///   <item><description>Health bars updated with current HP/SD values</description></item>
/// </list>
///
/// <para><strong>Failure Responses:</strong></para>
/// <list type="table">
///   <listheader>
///     <term>Condition</term>
///     <term>Response</term>
///   </listheader>
///   <item>
///     <term>Not In Party</term>
///     <term>Empty party list or ShowMessagePlugIn: "You are not in a party."</term>
///   </item>
///   <item>
///     <term>Party Disbanded</term>
///     <term>Empty party list sent to clear UI</term>
///   </item>
/// </list>
///
/// <para><strong>Auto-Refresh Triggers:</strong></para>
/// <list type="bullet">
///   <item><description>Member joins or leaves party</description></item>
///   <item><description>Member changes map</description></item>
///   <item><description>Member's HP/SD changes significantly</description></item>
///   <item><description>Player opens party window</description></item>
///   <item><description>Periodic refresh every few seconds for HP/SD updates</description></item>
/// </list>
/// </remarks>
[PlugIn("PartyListRequestHandlerPlugIn", "Handler for party list request packets.")]
[Guid("2650e346-69ef-4a9e-82ba-5f0b9591a548")]
internal class PartyListRequestHandlerPlugIn : IPacketHandlerPlugIn
{
    private readonly PartyListRequestAction _action = new();

    /// <inheritdoc/>
    public bool IsEncryptionExpected => false;

    /// <inheritdoc/>
    public byte Key => PartyListRequest.Code;

    /// <inheritdoc/>
    public async ValueTask HandlePacketAsync(Player player, Memory<byte> packet)
    {
        await this._action.RequestPartyListAsync(player).ConfigureAwait(false);
    }
}
// <copyright file="GuildInfoRequestHandlerPlugIn.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.GameServer.MessageHandler.Guild;

using System.Runtime.InteropServices;
using MUnique.OpenMU.GameLogic;
using MUnique.OpenMU.GameLogic.PlayerActions.Guild;
using MUnique.OpenMU.Network.Packets.ClientToServer;
using MUnique.OpenMU.PlugIns;

/// <summary>
/// Handler for guild info request packets.
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
///     <term>Packet Code (0x66)</term>
///   </item>
///   <item>
///     <term>3</term>
///     <term>4</term>
///     <term>uint</term>
///     <term>Guild ID (unique guild identifier)</term>
///   </item>
/// </list>
///
/// <para><strong>Guild Information Included:</strong></para>
/// <list type="table">
///   <listheader>
///     <term>Field</term>
///     <term>Description</term>
///   </listheader>
///   <item>
///     <term>Guild ID</term>
///     <term>Unique identifier for the guild</term>
///   </item>
///   <item>
///     <term>Guild Name</term>
///     <term>Name of the guild (max 8 characters)</term>
///   </item>
///   <item>
///     <term>Guild Emblem</term>
///     <term>4x4 pixel emblem data (16 bytes)</term>
///   </item>
///   <item>
///     <term>Guild Master</term>
///     <term>Character name of Guild Master</term>
///   </item>
///   <item>
///     <term>Total Members</term>
///     <term>Current number of guild members</term>
///   </item>
///   <item>
///     <term>Guild Score</term>
///     <term>Guild ranking/score points</term>
///   </item>
///   <item>
///     <term>Notice</term>
///     <term>Guild notice message (max 60 characters)</term>
///   </item>
///   <item>
///     <term>Alliance</term>
///     <term>Alliance guild ID (if in alliance)</term>
///   </item>
/// </list>
///
/// <para><strong>Request Scenarios:</strong></para>
/// <list type="bullet">
///   <item><description><strong>View Own Guild:</strong> Player opens guild info window (G key)</description></item>
///   <item><description><strong>View Other Guild:</strong> Player targets guild member and requests guild info</description></item>
///   <item><description><strong>Castle Owner:</strong> Viewing castle-owning guild information</description></item>
///   <item><description><strong>Alliance Info:</strong> Viewing allied guild details</description></item>
/// </list>
///
/// <para><strong>Validation Rules:</strong></para>
/// <list type="bullet">
///   <item><description>Guild ID must be valid and exist in database</description></item>
///   <item><description>Guild must be active (not deleted)</description></item>
///   <item><description>Request rate may be limited to prevent spam</description></item>
/// </list>
///
/// <para><strong>Success Response:</strong></para>
/// <list type="bullet">
///   <item><description>Server sends ShowGuildInfoPlugIn with all guild details</description></item>
///   <item><description>Guild emblem displayed in info window</description></item>
///   <item><description>Member list shown if requester is guild member</description></item>
///   <item><description>Guild notice displayed to all members</description></item>
///   <item><description>Alliance information shown if applicable</description></item>
/// </list>
///
/// <para><strong>Failure Responses:</strong></para>
/// <list type="table">
///   <listheader>
///     <term>Condition</term>
///     <term>Response</term>
///   </listheader>
///   <item>
///     <term>Invalid Guild ID</term>
///     <term>ShowMessagePlugIn: "Guild not found."</term>
///   </item>
///   <item>
///     <term>Guild Deleted</term>
///     <term>ShowMessagePlugIn: "Guild no longer exists."</term>
///   </item>
/// </list>
/// </remarks>
[PlugIn("GuildInfoRequestHandlerPlugIn", "Handler for guild info request packets.")]
[Guid("cfea6fcb-0cf4-4c11-8730-3d25ec08b6b0")]
internal class GuildInfoRequestHandlerPlugIn : IPacketHandlerPlugIn
{
    private readonly GuildInfoRequestAction _requestAction = new();

    /// <inheritdoc/>
    public bool IsEncryptionExpected => false;

    /// <inheritdoc/>
    public byte Key => GuildInfoRequest.Code;

    /// <inheritdoc/>
    public async ValueTask HandlePacketAsync(Player player, Memory<byte> packet)
    {
        GuildInfoRequest request = packet;
        await this._requestAction.RequestGuildInfoAsync(player, request.GuildId).ConfigureAwait(false);
    }
}
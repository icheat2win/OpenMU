// <copyright file="GuildRequestHandlerPlugIn.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.GameServer.MessageHandler.Guild;

using System.Runtime.InteropServices;
using MUnique.OpenMU.GameLogic;
using MUnique.OpenMU.GameLogic.PlayerActions.Guild;
using MUnique.OpenMU.Network.Packets.ClientToServer;
using MUnique.OpenMU.PlugIns;

/// <summary>
/// Handler for guild requests.
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
///     <term>Packet Code (0x50)</term>
///   </item>
///   <item>
///     <term>3</term>
///     <term>2</term>
///     <term>ushort</term>
///     <term>Guild Master Player ID (visible player object ID)</term>
///   </item>
/// </list>
///
/// <para><strong>Guild Join Request Process:</strong></para>
/// <list type="number">
///   <item><description><strong>Step 1:</strong> Requestor targets Guild Master and sends join request (this handler)</description></item>
///   <item><description><strong>Step 2:</strong> Guild Master receives join request dialog with requestor's name</description></item>
///   <item><description><strong>Step 3:</strong> Guild Master accepts or declines (GuildRequestAnswerHandlerPlugIn)</description></item>
///   <item><description><strong>Step 4:</strong> If accepted, requestor joins guild as regular member</description></item>
/// </list>
///
/// <para><strong>Validation Rules:</strong></para>
/// <list type="bullet">
///   <item><description>Target player must be a Guild Master (not just any guild member)</description></item>
///   <item><description>Target Guild Master must be in visible range</description></item>
///   <item><description>Requestor must not already be in a guild</description></item>
///   <item><description>Guild must not be full (max members: typically 80)</description></item>
///   <item><description>Target player ID must be valid and online</description></item>
///   <item><description>Requestor cannot join their own guild (if they are Guild Master)</description></item>
/// </list>
///
/// <para><strong>Success Response:</strong></para>
/// <list type="bullet">
///   <item><description>Guild Master receives ShowGuildJoinRequestPlugIn with requestor's name</description></item>
///   <item><description>Request dialog shows requestor character name and level</description></item>
///   <item><description>Guild Master has limited time to respond (~30 seconds)</description></item>
///   <item><description>Requestor waits for Guild Master's decision</description></item>
/// </list>
///
/// <para><strong>Failure Responses:</strong></para>
/// <list type="table">
///   <listheader>
///     <term>Condition</term>
///     <term>Response</term>
///   </listheader>
///   <item>
///     <term>Target Not Guild Master</term>
///     <term>ShowMessagePlugIn: "Target is not a Guild Master."</term>
///   </item>
///   <item>
///     <term>Already In Guild</term>
///     <term>ShowMessagePlugIn: "You are already in a guild."</term>
///   </item>
///   <item>
///     <term>Guild Full</term>
///     <term>ShowMessagePlugIn: "Guild is full."</term>
///   </item>
///   <item>
///     <term>Target Not Found</term>
///     <term>ShowMessagePlugIn: "Guild Master not found."</term>
///   </item>
///   <item>
///     <term>Request Declined</term>
///     <term>ShowMessagePlugIn: "Guild Master declined your request."</term>
///   </item>
/// </list>
/// </remarks>
[PlugIn("GuildRequestHandlerPlugIn", "Handler for guild requests.")]
[Guid("733b8b1d-7e39-4c5a-b134-d1aac2e33216")]
internal class GuildRequestHandlerPlugIn : IPacketHandlerPlugIn
{
    private readonly GuildRequestAction _requestAction = new();

    /// <inheritdoc/>
    public bool IsEncryptionExpected => false;

    /// <inheritdoc/>
    public byte Key => GuildJoinRequest.Code;

    /// <inheritdoc/>
    public async ValueTask HandlePacketAsync(Player player, Memory<byte> packet)
    {
        GuildJoinRequest request = packet;
        await this._requestAction.RequestGuildAsync(player, request.GuildMasterPlayerId).ConfigureAwait(false);
    }
}
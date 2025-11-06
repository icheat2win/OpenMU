// <copyright file="GuildCreateHandlerPlugIn.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.GameServer.MessageHandler.Guild;

using System.Runtime.InteropServices;
using MUnique.OpenMU.GameLogic;
using MUnique.OpenMU.GameLogic.PlayerActions.Guild;
using MUnique.OpenMU.Network.Packets.ClientToServer;
using MUnique.OpenMU.Network.PlugIns;
using MUnique.OpenMU.PlugIns;

/// <summary>
/// Handler for guild create packets.
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
///     <term>Packet Length (0x22)</term>
///   </item>
///   <item>
///     <term>2</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Packet Code (0x55)</term>
///   </item>
///   <item>
///     <term>3</term>
///     <term>8</term>
///     <term>string</term>
///     <term>Guild Name (null-terminated, max 8 characters)</term>
///   </item>
///   <item>
///     <term>11</term>
///     <term>16</term>
///     <term>byte[]</term>
///     <term>Guild Emblem (4x4 grid, 4 bits per pixel)</term>
///   </item>
/// </list>
///
/// <para><strong>Guild Creation Requirements:</strong></para>
/// <list type="bullet">
///   <item><description><strong>Level:</strong> Guild Master must be level 100+ (configurable)</description></item>
///   <item><description><strong>Zen Cost:</strong> Typically 1,000,000 Zen (configurable)</description></item>
///   <item><description><strong>Not In Guild:</strong> Player must not already be in a guild</description></item>
///   <item><description><strong>Unique Name:</strong> Guild name must be unique on server</description></item>
///   <item><description><strong>Name Format:</strong> 3-8 alphanumeric characters, no special symbols</description></item>
///   <item><description><strong>Location:</strong> Must be near Guild Master NPC to create</description></item>
/// </list>
///
/// <para><strong>Guild Name Validation:</strong></para>
/// <list type="bullet">
///   <item><description>Length: 3-8 characters</description></item>
///   <item><description>Allowed: Letters (A-Z, a-z) and numbers (0-9)</description></item>
///   <item><description>Not allowed: Spaces, special characters, profanity</description></item>
///   <item><description>Case-insensitive uniqueness check</description></item>
///   <item><description>Reserved names blocked (Admin, GM, etc.)</description></item>
/// </list>
///
/// <para><strong>Guild Emblem Format:</strong></para>
/// <list type="bullet">
///   <item><description>Size: 4x4 grid of pixels (16 pixels total)</description></item>
///   <item><description>Color Depth: 4 bits per pixel (16 colors from palette)</description></item>
///   <item><description>Data Size: 16 bytes (2 pixels per byte, packed)</description></item>
///   <item><description>Palette: Standard MU Online color palette</description></item>
///   <item><description>Displayed on guild member names and castle flags</description></item>
/// </list>
///
/// <para><strong>Success Response:</strong></para>
/// <list type="bullet">
///   <item><description>Guild created in database with unique ID</description></item>
///   <item><description>Player assigned as Guild Master with full permissions</description></item>
///   <item><description>Zen cost deducted from player</description></item>
///   <item><description>Player receives ShowGuildCreateResultPlugIn (success message)</description></item>
///   <item><description>Guild emblem saved and visible to all players</description></item>
///   <item><description>Player's name displays with guild prefix</description></item>
/// </list>
///
/// <para><strong>Failure Responses:</strong></para>
/// <list type="table">
///   <listheader>
///     <term>Condition</term>
///     <term>Response</term>
///   </listheader>
///   <item>
///     <term>Insufficient Level</term>
///     <term>ShowMessagePlugIn: "You must be level 100 to create a guild."</term>
///   </item>
///   <item>
///     <term>Insufficient Money</term>
///     <term>ShowMessagePlugIn: "Not enough Zen to create guild."</term>
///   </item>
///   <item>
///     <term>Already In Guild</term>
///     <term>ShowMessagePlugIn: "You are already in a guild."</term>
///   </item>
///   <item>
///     <term>Name Taken</term>
///     <term>ShowMessagePlugIn: "Guild name is already in use."</term>
///   </item>
///   <item>
///     <term>Invalid Name</term>
///     <term>ShowMessagePlugIn: "Invalid guild name."</term>
///   </item>
///   <item>
///     <term>Too Far From NPC</term>
///     <term>ShowMessagePlugIn: "You must be near the Guild Master NPC."</term>
///   </item>
/// </list>
/// </remarks>
[PlugIn(nameof(GuildCreateHandlerPlugIn), "Handler for guild create packets.")]
[Guid("0aae71c1-72df-47d6-af88-cddc5d5c7311")]
[MinimumClient(1, 0, ClientLanguage.Invariant)]
internal class GuildCreateHandlerPlugIn : IPacketHandlerPlugIn
{
    private readonly GuildCreateAction _createAction = new();

    /// <inheritdoc/>
    public bool IsEncryptionExpected => false;

    /// <inheritdoc/>
    public byte Key => GuildCreateRequest.Code;

    /// <inheritdoc/>
    public async ValueTask HandlePacketAsync(Player player, Memory<byte> packet)
    {
        GuildCreateRequest request = packet;
        await this._createAction.CreateGuildAsync(player, request.GuildName, request.GuildEmblem.ToArray()).ConfigureAwait(false);
    }
}
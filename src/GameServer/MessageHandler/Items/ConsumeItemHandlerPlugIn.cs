// <copyright file="ConsumeItemHandlerPlugIn.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.GameServer.MessageHandler.Items;

using System.Runtime.InteropServices;
using MUnique.OpenMU.GameLogic;
using MUnique.OpenMU.GameLogic.PlayerActions.ItemConsumeActions;
using MUnique.OpenMU.Network.Packets.ClientToServer;
using MUnique.OpenMU.Network.PlugIns;
using MUnique.OpenMU.PlugIns;

/// <summary>
/// Handler for item consume packets.
/// </summary>
/// <remarks>
/// <para>
/// This handler processes client requests to consume (use) items from inventory.
/// Consumable items include potions (HP/MP/SD recovery), scrolls (skill learning),
/// jewels (item upgrading), fruits (stat modification), and other usable items.
/// </para>
/// <para>
/// <strong>Packet Structure (C3 08 26):</strong>
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
///     <term>Packet size (0x08)</term>
///   </item>
///   <item>
///     <term>2</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Packet type (0x26 - Consume Item)</term>
///   </item>
///   <item>
///     <term>3</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Source item slot (item being consumed)</term>
///   </item>
///   <item>
///     <term>4</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Target item slot (for jewels/upgrade items, otherwise 0xFF)</term>
///   </item>
///   <item>
///     <term>5</term>
///     <term>1</term>
///     <term>byte</term>
///     <term>Fruit consumption type (0=Add points, 1=Remove points, 0xFF=N/A)</term>
///   </item>
/// </list>
/// </para>
/// <para>
/// <strong>Item Categories and Behavior:</strong>
/// <list type="table">
///   <listheader>
///     <term>Item Type</term>
///     <term>Target Slot</term>
///     <term>Effect</term>
///   </listheader>
///   <item>
///     <term>Potions</term>
///     <term>0xFF (none)</term>
///     <term>Restore HP, MP, or SD immediately</term>
///   </item>
///   <item>
///     <term>Scrolls</term>
///     <term>0xFF (none)</term>
///     <term>Learn skill if requirements met</term>
///   </item>
///   <item>
///     <term>Jewels (Bless, Soul, etc.)</term>
///     <term>Target item slot</term>
///     <term>Upgrade target item (+level, +options, etc.)</term>
///   </item>
///   <item>
///     <term>Fruits</term>
///     <term>0xFF (none)</term>
///     <term>Add or remove stat points based on fruit type</term>
///   </item>
///   <item>
///     <term>Town Portal Scroll</term>
///     <term>0xFF (none)</term>
///     <term>Teleport player to safe zone</term>
///   </item>
///   <item>
///     <term>Antidote</term>
///     <term>0xFF (none)</term>
///     <term>Remove poison effect</term>
///   </item>
/// </list>
/// </para>
/// <para>
/// <strong>Validation and Error Conditions:</strong>
/// <list type="bullet">
///   <item><description>Item must exist in specified source slot</description></item>
///   <item><description>Item must be consumable (have ItemConsumeHandler registered)</description></item>
///   <item><description>Player must meet item requirements (level, class, stats)</description></item>
///   <item><description>For jewels: Target item must exist and be upgradeable</description></item>
///   <item><description>For scrolls: Player must not already know the skill</description></item>
///   <item><description>For fruits: Player must have stat points to modify</description></item>
///   <item><description>Cannot consume items during trade, PvP combat, or other restricted states</description></item>
///   <item><description>Some items have cooldowns between uses</description></item>
/// </list>
/// </para>
/// <para>
/// <strong>Success Response:</strong> Item is consumed (removed or quantity decreased).
/// Effect is applied (stat change, skill learned, item upgraded, etc.).
/// Client receives success notification and updated stats/inventory.
/// </para>
/// <para>
/// <strong>Failure Response:</strong> Consumption fails and client receives error message
/// with reason (requirements not met, upgrade failed, etc.).
/// </para>
/// <para>
/// <strong>Fruit Consumption Types:</strong>
/// <list type="bullet">
///   <item><description>AddPoints (0): Increase stat by fruit amount (e.g., +10 Strength)</description></item>
///   <item><description>RemovePoints (1): Decrease stat and refund level-up points</description></item>
/// </list>
/// </para>
/// </remarks>
[PlugIn(nameof(ConsumeItemHandlerPlugIn), "Handler for item consume packets.")]
[Guid("53992288-0d11-49df-98a3-2912b7616558")]
[MinimumClient(5, 0, ClientLanguage.Invariant)]
internal class ConsumeItemHandlerPlugIn : IPacketHandlerPlugIn
{
    private readonly ItemConsumeAction _consumeAction = new();

    /// <inheritdoc/>
    public bool IsEncryptionExpected => false;

    /// <inheritdoc/>
    public byte Key => ConsumeItemRequest.Code;

    /// <inheritdoc/>
    public async ValueTask HandlePacketAsync(Player player, Memory<byte> packet)
    {
        ConsumeItemRequest message = packet;
        await this._consumeAction.HandleConsumeRequestAsync(player, message.ItemSlot, message.TargetSlot, Convert(message.FruitConsumption)).ConfigureAwait(false);
    }

    private static FruitUsage Convert(ConsumeItemRequest.FruitUsage fruitConsumption)
    {
        return fruitConsumption switch
        {
            ConsumeItemRequest.FruitUsage.AddPoints => FruitUsage.AddPoints,
            ConsumeItemRequest.FruitUsage.RemovePoints => FruitUsage.RemovePoints,
            _ => FruitUsage.Undefined,
        };
    }
}
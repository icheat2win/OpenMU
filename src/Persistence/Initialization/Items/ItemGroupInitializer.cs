// <copyright file="ItemGroupInitializer.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.Persistence.Initialization.Items;

using MUnique.OpenMU.DataModel.Configuration;
using MUnique.OpenMU.DataModel.Configuration.Items;

/// <summary>
/// Initializes the standard item groups.
/// </summary>
public class ItemGroupInitializer
{
    private readonly IContext context;
    private readonly GameConfiguration gameConfiguration;

    /// <summary>
    /// Initializes a new instance of the <see cref="ItemGroupInitializer"/> class.
    /// </summary>
    /// <param name="context">The context.</param>
    /// <param name="gameConfiguration">The game configuration.</param>
    public ItemGroupInitializer(IContext context, GameConfiguration gameConfiguration)
    {
        this.context = context;
        this.gameConfiguration = gameConfiguration;
    }

    /// <summary>
    /// Initializes all standard item groups.
    /// </summary>
    public void Initialize()
    {
        this.CreateItemGroup(0, "Swords", "One-handed and two-handed sword weapons.", "00000000-0000-0000-0001-000000000000");
        this.CreateItemGroup(1, "Axes", "One-handed and two-handed axe weapons.", "00000000-0000-0000-0001-000000000001");
        this.CreateItemGroup(2, "Scepters", "Magic scepter weapons for magic gladiators.", "00000000-0000-0000-0001-000000000002");
        this.CreateItemGroup(3, "Spears", "One-handed and two-handed spear and lance weapons.", "00000000-0000-0000-0001-000000000003");
        this.CreateItemGroup(4, "Bows", "Bow and crossbow weapons, including arrows and bolts.", "00000000-0000-0000-0001-000000000004");
        this.CreateItemGroup(5, "Staff", "Magic staff weapons for dark wizards and summoners.", "00000000-0000-0000-0001-000000000005");
        this.CreateItemGroup(6, "Shields", "Defensive shields that can be equipped in the left hand.", "00000000-0000-0000-0001-000000000006");
        this.CreateItemGroup(7, "Helms", "Head armor pieces providing defense and additional stats.", "00000000-0000-0000-0001-000000000007");
        this.CreateItemGroup(8, "Armor", "Body armor pieces providing primary defense.", "00000000-0000-0000-0001-000000000008");
        this.CreateItemGroup(9, "Pants", "Leg armor pieces providing defense and movement stats.", "00000000-0000-0000-0001-000000000009");
        this.CreateItemGroup(10, "Gloves", "Hand armor pieces providing defense and attack bonuses.", "00000000-0000-0000-0001-00000000000A");
        this.CreateItemGroup(11, "Boots", "Foot armor pieces providing defense and movement speed.", "00000000-0000-0000-0001-00000000000B");
        this.CreateItemGroup(12, "Orbs", "Wings, orbs, and other special equipment items.", "00000000-0000-0000-0001-00000000000C");
        this.CreateItemGroup(13, "Misc1", "Pets, rings, pendants, and miscellaneous items.", "00000000-0000-0000-0001-00000000000D");
        this.CreateItemGroup(14, "Misc2", "Potions, scrolls, and other consumable items.", "00000000-0000-0000-0001-00000000000E");
        this.CreateItemGroup(15, "Scrolls", "Spell scrolls and special event items.", "00000000-0000-0000-0001-00000000000F");
    }

    private void CreateItemGroup(byte number, string name, string description, string guidString)
    {
        var itemGroup = this.context.CreateNew<ItemGroupDefinition>();
        itemGroup.Id = new Guid(guidString);
        itemGroup.Number = number;
        itemGroup.Name = name;
        itemGroup.Description = description;
        itemGroup.GameConfiguration = this.gameConfiguration;
        this.gameConfiguration.ItemGroups.Add(itemGroup);
    }
}

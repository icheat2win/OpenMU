// <copyright file="ItemGroupDefinition.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.DataModel.Configuration.Items;

using MUnique.OpenMU.Annotations;

/// <summary>
/// Defines an item group category.
/// Item groups categorize items into logical types (weapons, armor, consumables, etc.).
/// </summary>
[Cloneable]
public partial class ItemGroupDefinition
{
    /// <summary>
    /// Gets or sets the identifier of this item group.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Gets or sets the numeric identifier of the item group (0-15).
    /// This corresponds to the byte value used in <see cref="ItemDefinition.Group"/>.
    /// </summary>
    public byte Number { get; set; }

    /// <summary>
    /// Gets or sets the name of the item group.
    /// Examples: "Swords", "Axes", "Helms", "Armor", "Potions", "Scrolls".
    /// </summary>
    public string Name { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets a description of this item group.
    /// Describes the types of items that belong to this category.
    /// </summary>
    public string Description { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the game configuration this item group belongs to.
    /// </summary>
    [Required]
    public virtual GameConfiguration GameConfiguration { get; set; } = null!;

    /// <inheritdoc />
    public override string ToString()
    {
        return $"{this.Number}: {this.Name}";
    }
}

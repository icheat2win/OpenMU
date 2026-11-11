// <copyright file="FixPhantomAndDestroyArmorNamesPlugIn.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.Persistence.Initialization.Updates;

using System.Runtime.InteropServices;
using MUnique.OpenMU.Interfaces;
using MUnique.OpenMU.Persistence.Initialization.Properties;
using MUnique.OpenMU.PlugIns;

/// <summary>
/// This update swaps the names of the armor sets number 47 and 48 back to the ones of the client data:
/// number 47 is the Phantom set and number 48 is the Destroy set. It also corrects the spelling of "Destory".
/// Names which were changed by an administrator are kept.
/// </summary>
[PlugIn]
[Display(Name = nameof(PlugInResources.FixPhantomAndDestroyArmorNamesPlugIn_Name), Description = nameof(PlugInResources.FixPhantomAndDestroyArmorNamesPlugIn_Description), ResourceType = typeof(PlugInResources))]
[Guid("6D1C8B3E-2F47-4A95-B0E8-93A7C5D41F62")]
public class FixPhantomAndDestroyArmorNamesPlugIn : UpdatePlugInBase
{
    /// <summary>
    /// The plug in name.
    /// </summary>
    internal const string PlugInName = "Fix Phantom and Destroy armor names";

    /// <summary>
    /// The plug in description.
    /// </summary>
    internal const string PlugInDescription = "Swaps the names of the armor sets number 47 (Phantom) and 48 (Destroy), as in the client data, and corrects the spelling of 'Destory'.";

    private const short PhantomNumber = 47;

    private const short DestroyNumber = 48;

    private static readonly (byte Group, string Part, Func<LocalizedString> Phantom, Func<LocalizedString> Destroy)[] Parts =
    [
        (8, "Armor", () => LocalizedString.FromResource(() => ItemNames.PhantomArmor), () => LocalizedString.FromResource(() => ItemNames.DestroyArmor)),
        (9, "Pants", () => LocalizedString.FromResource(() => ItemNames.PhantomPants), () => LocalizedString.FromResource(() => ItemNames.DestroyPants)),
        (10, "Gloves", () => LocalizedString.FromResource(() => ItemNames.PhantomGloves), () => LocalizedString.FromResource(() => ItemNames.DestroyGloves)),
        (11, "Boots", () => LocalizedString.FromResource(() => ItemNames.PhantomBoots), () => LocalizedString.FromResource(() => ItemNames.DestroyBoots)),
    ];

    /// <inheritdoc />
    public override string DataInitializationKey => VersionSeasonSix.DataInitialization.Id;

    /// <inheritdoc />
    public override string Name => PlugInName;

    /// <inheritdoc />
    public override string Description => PlugInDescription;

    /// <inheritdoc />
    public override bool IsMandatory => true;

    /// <inheritdoc />
    public override DateTime CreatedAt => new(2026, 11, 11, 21, 0, 0, DateTimeKind.Utc);

    /// <inheritdoc />
    protected override ValueTask ApplyAsync(IContext context, GameConfiguration gameConfiguration)
    {
        foreach (var (group, part, phantom, destroy) in Parts)
        {
            // The old names: number 47 was called "Destory" (the gloves "Destroy"), number 48 "Phantom".
            var oldPhantomName = group == 10 ? "Destroy Gloves" : $"Destory {part}";
            RenameItem(gameConfiguration, group, PhantomNumber, oldPhantomName, phantom);
            RenameItem(gameConfiguration, group, DestroyNumber, $"Phantom {part}", destroy);
        }

        foreach (var set in gameConfiguration.ItemSetGroups)
        {
            var number = set.Items.Select(i => i.ItemDefinition).FirstOrDefault(d => d?.Group == 8)?.Number;
            var (oldPrefix, newKey) = number switch
            {
                PhantomNumber => ("Destory", "PhantomArmor"),
                DestroyNumber => ("Phantom", "DestroyArmor"),
                _ => (null, null),
            };

            if (oldPrefix is null || newKey is null)
            {
                continue;
            }

            var oldName = set.SetLevel > 0 ? $"{oldPrefix} Defense Bonus (Level {set.SetLevel})" : $"{oldPrefix} Defense Rate Bonus";
            if (set.Name.ValueInNeutralLanguage == oldName)
            {
                var key = newKey + (set.SetLevel > 0 ? $"DefenseBonusLevel{set.SetLevel}" : "DefenseRateBonus");
                set.Name = ArmorSetNames.ResourceManager.GetLocalizedString(key);
            }
        }

        return ValueTask.CompletedTask;
    }

    private static void RenameItem(GameConfiguration gameConfiguration, byte group, short number, string oldName, Func<LocalizedString> newName)
    {
        if (gameConfiguration.Items.FirstOrDefault(i => i.Group == group && i.Number == number) is { } item
            && item.Name.ValueInNeutralLanguage == oldName)
        {
            item.Name = newName();
        }
    }
}

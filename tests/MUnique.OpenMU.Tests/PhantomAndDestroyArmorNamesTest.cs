// <copyright file="PhantomAndDestroyArmorNamesTest.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.Tests;

using Microsoft.Extensions.Logging.Abstractions;
using MUnique.OpenMU.DataModel.Configuration;
using MUnique.OpenMU.DataModel.Configuration.Items;
using MUnique.OpenMU.Persistence;
using MUnique.OpenMU.Persistence.Initialization.Updates;
using MUnique.OpenMU.Persistence.Initialization.VersionSeasonSix;
using MUnique.OpenMU.Persistence.InMemory;

/// <summary>
/// Tests the names of the armor sets number 47 (Phantom) and 48 (Destroy) of season 6.
/// </summary>
[TestFixture]
public class PhantomAndDestroyArmorNamesTest
{
    private static readonly string[] Parts = ["Armor", "Pants", "Gloves", "Boots"];

    private IContext _context = null!;

    private GameConfiguration _gameConfiguration = null!;

    /// <summary>
    /// Initializes the season 6 configuration data.
    /// </summary>
    [OneTimeSetUp]
    public async ValueTask SetupAsync()
    {
        var contextProvider = new InMemoryPersistenceContextProvider();
        await new DataInitialization(contextProvider, new NullLoggerFactory()).CreateInitialDataAsync(0, false).ConfigureAwait(false);
        this._context = contextProvider.CreateNewConfigurationContext();
        this._gameConfiguration = (await this._context.GetAsync<GameConfiguration>().ConfigureAwait(false)).First();
    }

    /// <summary>
    /// Number 47 is the Phantom set and number 48 the Destroy set, as in the client data.
    /// </summary>
    [Test]
    public void ItemsAreNamedAsInTheClient()
    {
        this.AssertNewNames();
    }

    /// <summary>
    /// The update swaps the old names of an existing configuration.
    /// </summary>
    [Test]
    public async ValueTask UpdateFixesOldNamesAsync()
    {
        for (byte group = 8; group <= 11; group++)
        {
            var part = Parts[group - 8];
            this.Item(group, 47).Name = group == 10 ? "Destroy Gloves" : $"Destory {part}";
            this.Item(group, 48).Name = $"Phantom {part}";
        }

        foreach (var (set, number) in this.Sets())
        {
            var prefix = number == 47 ? "Destory" : "Phantom";
            set.Name = set.SetLevel > 0 ? $"{prefix} Defense Bonus (Level {set.SetLevel})" : $"{prefix} Defense Rate Bonus";
        }

        await new FixPhantomAndDestroyArmorNamesPlugIn().ApplyUpdateAsync(this._context, this._gameConfiguration).ConfigureAwait(false);

        this.AssertNewNames();
    }

    /// <summary>
    /// The update doesn't change the names of a configuration which already has the new names.
    /// </summary>
    [Test]
    public async ValueTask UpdateIsIdempotentAsync()
    {
        await new FixPhantomAndDestroyArmorNamesPlugIn().ApplyUpdateAsync(this._context, this._gameConfiguration).ConfigureAwait(false);
        await new FixPhantomAndDestroyArmorNamesPlugIn().ApplyUpdateAsync(this._context, this._gameConfiguration).ConfigureAwait(false);

        this.AssertNewNames();
    }

    /// <summary>
    /// The update keeps names which were changed by an administrator.
    /// </summary>
    [Test]
    public async ValueTask UpdateKeepsCustomNamesAsync()
    {
        var item = this.Item(8, 48);
        var originalName = item.Name;
        item.Name = "My Armor";
        try
        {
            await new FixPhantomAndDestroyArmorNamesPlugIn().ApplyUpdateAsync(this._context, this._gameConfiguration).ConfigureAwait(false);
            Assert.That(item.Name.ValueInNeutralLanguage, Is.EqualTo("My Armor"));
        }
        finally
        {
            item.Name = originalName;
        }
    }

    private void AssertNewNames()
    {
        Assert.Multiple(() =>
        {
            for (byte group = 8; group <= 11; group++)
            {
                var part = Parts[group - 8];
                Assert.That(this.Item(group, 47).Name.ValueInNeutralLanguage, Is.EqualTo($"Phantom {part}"));
                Assert.That(this.Item(group, 48).Name.ValueInNeutralLanguage, Is.EqualTo($"Destroy {part}"));
            }

            var sets = this.Sets().ToList();
            Assert.That(sets, Has.Count.EqualTo(14));
            foreach (var (set, number) in sets)
            {
                var prefix = number == 47 ? "Phantom" : "Destroy";
                var expected = set.SetLevel > 0 ? $"{prefix} Defense Bonus (Level {set.SetLevel})" : $"{prefix} Defense Rate Bonus";
                Assert.That(set.Name.ValueInNeutralLanguage, Is.EqualTo(expected));
                Assert.That(set.Name.SourceKey, Does.StartWith($"ArmorSetNames/{prefix}Armor"));
            }
        });
    }

    private ItemDefinition Item(byte group, short number)
    {
        return this._gameConfiguration.Items.Single(i => i.Group == group && i.Number == number);
    }

    private IEnumerable<(ItemSetGroup Set, short Number)> Sets()
    {
        foreach (var set in this._gameConfiguration.ItemSetGroups)
        {
            if (set.Items.Select(i => i.ItemDefinition).FirstOrDefault(d => d?.Group == 8)?.Number is { } number and (47 or 48))
            {
                yield return (set, number);
            }
        }
    }
}

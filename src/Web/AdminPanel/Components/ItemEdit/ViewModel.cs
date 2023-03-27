﻿// <copyright file="ViewModel.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.Web.AdminPanel.Components.ItemEdit;

using System.ComponentModel;
using System.Runtime.CompilerServices;
using MUnique.OpenMU.DataModel;
using MUnique.OpenMU.DataModel.Configuration.Items;
using MUnique.OpenMU.DataModel.Entities;
using MUnique.OpenMU.Persistence;
using Nito.AsyncEx.Synchronous;
using Nito.Disposables.Internals;

/// <summary>
/// The view model for an <see cref="Item"/>.
/// </summary>
public class ViewModel : INotifyPropertyChanged
{
    private readonly IContext _persistenceContext;

    /// <summary>
    /// Initializes a new instance of the <see cref="ViewModel"/> class.
    /// </summary>
    /// <param name="item">The item.</param>
    /// <param name="persistenceContext">The persistence context.</param>
    public ViewModel(Item item, IContext persistenceContext)
    {
        this._persistenceContext = persistenceContext;
        this.Item = item;
        this.ExcellentOptions = new ItemOptionList(ItemOptionTypes.Excellent, item, persistenceContext);
        this.WingOptions = new ItemOptionList(ItemOptionTypes.Wing, item, persistenceContext);
        this.Sockets = new List<SocketViewModel>(
            Enumerable.Range(1, this.Definition?.MaximumSockets ?? 0)
                .Select(i => new SocketViewModel(item, this._persistenceContext, i, this.PossibleSocketOptions)));
    }

    /// <inheritdoc />
    public event PropertyChangedEventHandler? PropertyChanged;

    /// <summary>
    /// Gets the item.
    /// </summary>
    public Item Item { get; }

    /// <summary>
    /// Gets or sets the item slot.
    /// </summary>
    public byte ItemSlot
    {
        get => this.Item.ItemSlot;
        set
        {
            if (value == this.Item.ItemSlot)
            {
                return;
            }

            this.Item.ItemSlot = value;
            this.OnPropertyChanged();
        }
    }

    /// <summary>
    /// Gets or sets the definition.
    /// </summary>
    public ItemDefinition? Definition
    {
        get => this.Item.Definition;
        set
        {
            if (this.Definition == value)
            {
                return;
            }

            this.Item.Definition = value;
            this.OnDefinitionChanged();
            this.OnPropertyChanged();
        }
    }

    /// <summary>
    /// Gets or sets the level.
    /// </summary>
    public byte Level
    {
        get => this.Item.Level;
        set
        {
            if (this.Item.Level == value)
            {
                return;
            }

            // todo: check if level is valid
            this.Item.Level = value;
            this.OnPropertyChanged();
        }
    }

    /// <summary>
    /// Gets or sets the amount for items which are not wearable.
    /// </summary>
    public byte Amount
    {
        get => (byte)this.Durability;
        set => this.Durability = value;
    }

    /// <summary>
    /// Gets or sets the durability.
    /// </summary>
    public double Durability
    {
        get => this.Item.Durability;
        set
        {
            if (Math.Abs(this.Item.Durability - value) < 0.0001)
            {
                return;
            }

            // todo: check if durability is valid
            this.Item.Durability = value;
            this.OnPropertyChanged();
        }
    }

    /// <summary>
    /// Gets or sets a value indicating whether this item has skill.
    /// </summary>
    public bool HasSkill
    {
        get => this.Item.HasSkill;
        set
        {
            if (this.Item.HasSkill == value)
            {
                return;
            }

            this.Item.HasSkill = value;
            this.OnPropertyChanged();
        }
    }

    /// <summary>
    /// Gets or sets a value indicating whether this item has luck.
    /// </summary>
    public bool HasLuck
    {
        get => this.Item.ItemOptions.Any(io => io.ItemOption?.OptionType == ItemOptionTypes.Luck);
        set
        {
            if (this.HasLuck == value)
            {
                return;
            }

            if (!value)
            {
                if (this.Item.ItemOptions.FirstOrDefault(io => io.ItemOption?.OptionType == ItemOptionTypes.Luck) is { } optionLink)
                {
                    this.Item.ItemOptions.Remove(optionLink);
                    this._persistenceContext.DeleteAsync(optionLink).AsTask().WaitAndUnwrapException();
                }
            }
            else if (value && this.PossibleLuckOption is { } luckOption)
            {
                var optionLink = this._persistenceContext.CreateNew<ItemOptionLink>();
                optionLink.ItemOption = luckOption;
                this.Item.ItemOptions.Add(optionLink);
            }

            this.OnPropertyChanged();
        }
    }

    /// <summary>
    /// Gets the possible luck option.
    /// </summary>
    public IncreasableItemOption? PossibleLuckOption
    {
        get
        {
            return this.Definition?.PossibleItemOptions
                .SelectMany(p => p.PossibleOptions)
                .FirstOrDefault(o => o.OptionType == ItemOptionTypes.Luck);
        }
    }

    /// <summary>
    /// Gets the normal option link, if available.
    /// </summary>
    public ItemOptionLink? NormalOptionLink => this.Item.ItemOptions.FirstOrDefault(io => io.ItemOption?.OptionType == ItemOptionTypes.Option);

    /// <summary>
    /// Gets or sets the normal option, if assigned.
    /// </summary>
    public IncreasableItemOption? NormalOption
    {
        get => this.NormalOptionLink?.ItemOption;
        set
        {
            if (this.NormalOption == value)
            {
                return;
            }

            if (value is null)
            {
                if (this.NormalOptionLink is { } optionLink)
                {
                    this.Item.ItemOptions.Remove(optionLink);
                    this._persistenceContext.DeleteAsync(optionLink).AsTask().WaitAndUnwrapException();
                }
            }
            else
            {
                var optionLink = this.NormalOptionLink;
                if (optionLink is null)
                {
                    optionLink = this._persistenceContext.CreateNew<ItemOptionLink>();
                    this.Item.ItemOptions.Add(optionLink);
                }

                optionLink.ItemOption = value;
            }
        }
    }

    /// <summary>
    /// Gets or sets a value indicating whether this item has a "normal" option.
    /// It comes to action when there is just one possible option.
    /// </summary>
    public bool HasOption
    {
        get => this.NormalOption is { };
        set
        {
            if (this.HasOption == value)
            {
                return;
            }

            this.NormalOption = value ? this.PossibleNormalOptions.FirstOrDefault() : null;

            this.OnPropertyChanged();
        }
    }

    /// <summary>
    /// Gets or sets the socket count.
    /// </summary>
    public int SocketCount
    {
        get => this.Item.SocketCount;
        set
        {
            if (this.Item.SocketCount == value)
            {
                return;
            }

            this.Item.SocketCount = Math.Min(value, this.Item.Definition?.MaximumSockets ?? 0);
            for (int i = this.Item.SocketCount; i < this.Item.Definition?.MaximumSockets; i++)
            {
                this.Sockets[i].Option = null;
            }

            this.OnPropertyChanged();
        }
    }

    /// <summary>
    /// Gets or sets the socket view items.
    /// </summary>
    public List<SocketViewModel> Sockets { get; set; }

    /// <summary>
    /// Gets or sets the pet experience.
    /// </summary>
    public int PetExperience
    {
        get => this.Item.PetExperience;
        set
        {
            if (this.Item.PetExperience == value)
            {
                return;
            }

            this.Item.PetExperience = this.Item.IsTrainablePet() ? value : 0;
            this.OnPropertyChanged();
        }
    }

    /// <summary>
    /// Gets or sets the excellent options.
    /// </summary>
    public IList<IncreasableItemOption> ExcellentOptions { get; set; }

    /// <summary>
    /// Gets or sets the wing options.
    /// </summary>
    public IList<IncreasableItemOption> WingOptions { get; set; }

    /// <summary>
    /// Gets or sets the ancient set.
    /// </summary>
    public ItemSetGroup? AncientSet
    {
        get => this.ItemSetGroups.FirstOrDefault(io => io.AncientSetDiscriminator > 0)?.ItemSetGroup;
        set
        {
            if (this.AncientSet == value)
            {
                return;
            }

            if (value is null)
            {
                foreach (var isg in this.PossibleAncientSetItems)
                {
                    this.Item.ItemSetGroups.Remove(isg);
                }

                if (this.AncientBonus is { } optionLink)
                {
                    this.ItemOptions.Remove(optionLink);
                    this._persistenceContext.DeleteAsync(optionLink).AsTask().WaitAndUnwrapException();
                }
            }
            else
            {
                var itemOfSet = value.Items.First(ios => ios.ItemDefinition == this.Definition);
                this.ItemSetGroups.Add(itemOfSet);

                if (itemOfSet.BonusOption is { } bonusOption)
                {
                    var optionLink = this._persistenceContext.CreateNew<ItemOptionLink>();
                    optionLink.ItemOption = bonusOption;
                    optionLink.Level = 1;
                    this.ItemOptions.Add(optionLink);
                }
            }
        }
    }

    /// <summary>
    /// Gets the ancient bonus.
    /// </summary>
    public ItemOptionLink? AncientBonus => this.ItemOptions.FirstOrDefault(io => io.ItemOption?.OptionType == ItemOptionTypes.AncientBonus);

    /// <summary>
    /// Gets the possible ancient sets for this item.
    /// </summary>
    [Browsable(false)]
    public IEnumerable<ItemSetGroup> PossibleAncientSets
    {
        get
        {
            return this.PossibleAncientSetItems
                .Select(isg => isg.ItemSetGroup)
                .WhereNotNull()
                .Where(isg => isg.Items.Any(it => it.ItemDefinition == this.Item.Definition));
        }
    }

    /// <summary>
    /// Gets the possible excellent options.
    /// </summary>
    public IEnumerable<ItemOptionDefinition> PossibleExcellentOptions
    {
        get
        {
            return this.Definition?.PossibleItemOptions
                .Where(iod => iod.PossibleOptions.Any(po => po.OptionType == ItemOptionTypes.Excellent))
                ?? Enumerable.Empty<ItemOptionDefinition>();
        }
    }

    /// <summary>
    /// Gets the possible wing options.
    /// </summary>
    public IEnumerable<ItemOptionDefinition> PossibleWingOptions
    {
        get
        {
            return this.Definition?.PossibleItemOptions
                       .Where(iod => iod.PossibleOptions.Any(po => po.OptionType == ItemOptionTypes.Wing))
                   ?? Enumerable.Empty<ItemOptionDefinition>();
        }
    }

    /// <summary>
    /// Gets the possible normal options.
    /// </summary>
    public IEnumerable<IncreasableItemOption> PossibleNormalOptions
    {
        get
        {
            return this.Definition?.PossibleItemOptions
                       .Where(iod => iod.PossibleOptions.Any(po => po.OptionType == ItemOptionTypes.Option))
                       .SelectMany(iod => iod.PossibleOptions)
                   ?? Enumerable.Empty<IncreasableItemOption>();
        }
    }

    /// <summary>
    /// Gets the possible socket options.
    /// </summary>
    public IEnumerable<SocketOptionViewModel> PossibleSocketOptions
    {
        get
        {
            return this.Definition?.PossibleItemOptions
                       .Where(iod => iod.PossibleOptions.Any(po => po.OptionType == ItemOptionTypes.SocketOption))
                       .SelectMany(iod => iod.PossibleOptions.Select(o => new SocketOptionViewModel(iod, o)))
                   ?? Enumerable.Empty<SocketOptionViewModel>();
        }
    }

    /// <summary>
    /// Gets the item options.
    /// </summary>
    public ICollection<ItemOptionLink> ItemOptions => this.Item.ItemOptions;

    /// <summary>
    /// Gets the item set groups.
    /// </summary>
    public ICollection<ItemOfItemSet> ItemSetGroups => this.Item.ItemSetGroups;

    /// <summary>
    /// Gets the possible ancient set items.
    /// </summary>
    private IEnumerable<ItemOfItemSet> PossibleAncientSetItems
    {
        get
        {
            return this.ItemSetGroups
                .Where(isg => isg.AncientSetDiscriminator > 0);
        }
    }

    private void OnPropertyChanged([CallerMemberName] string? propertyName = null)
    {
        this.PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }

    /// <summary>
    /// Called when the <see cref="Definition"/> has been changed.
    /// </summary>
    private void OnDefinitionChanged()
    {
        if (this.Definition is not { } definition)
        {
            return;
        }

        if (definition.MaximumItemLevel < this.Level)
        {
            this.Level = 0;
        }

        // check item options

        // pet experience

        // socket count

        // skill

        // durability

        // level
    }
}
// <copyright file="MuItemStorage.razor.cs" company="MUnique">
// Licensed under the MIT License. See LICENSE file in the project root for full license information.
// </copyright>

namespace MUnique.OpenMU.Web.ItemEditor;

using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;

/// <summary>
/// Component for a item box.
/// </summary>
public partial class MuItemStorage
{
    private StorageViewModel? _viewModel;
    private ItemViewModel? _selectedItemModel;

    /// <summary>
    /// Gets or sets the selected item.
    /// </summary>
    [Parameter]
    public Item? SelectedItem
    {
        get => this._selectedItemModel?.Item;
        set
        {
            this._selectedItemModel = value is null ? null : this._viewModel?.Items.FirstOrDefault(item => item.Item == value);
            _ = this.InvokeAsync(this.StateHasChanged);
        }
    }

    /// <summary>
    /// Gets or sets the type of the storage.
    /// </summary>
    [Parameter]
    public StorageType StorageType { get; set; }

    /// <summary>
    /// Gets or sets the number of extensions.
    /// </summary>
    [Parameter]
    public byte NumberOfExtensions { get; set; }

    /// <summary>
    /// Gets or sets the index of the extension.
    /// </summary>
    [Parameter]
    public byte ExtensionIndex { get; set; }

    /// <summary>
    /// Gets or sets the callback when the selected item changed.
    /// </summary>
    [Parameter]
    public EventCallback<Item?> SelectedItemChanged { get; set; }

    /// <summary>
    /// Sets the selected item.
    /// </summary>
    /// <param name="viewModel">The view model.</param>
    public async Task SetSelectedItemAsync(ItemViewModel viewModel)
    {
        this._selectedItemModel = viewModel;
        if (this.SelectedItemChanged.HasDelegate)
        {
            await this.SelectedItemChanged.InvokeAsync(viewModel.Item).ConfigureAwait(true);
        }
    }

    /// <inheritdoc />
    protected override void OnParametersSet()
    {
        base.OnParametersSet();
        if (this.Value is { } value)
        {
            this._viewModel ??= value.CreateViewModel(this.StorageType, this.NumberOfExtensions, this.ExtensionIndex);
        }
    }

    /// <inheritdoc />
    protected override bool TryParseValueFromString(string? value, out ItemStorage result, out string validationErrorMessage)
    {
        result = null!;
        validationErrorMessage = string.Empty;
        return false;
    }

    private async Task OnItemMovedAsync()
    {
        if (this.SelectedItemChanged.HasDelegate)
        {
            await this.SelectedItemChanged.InvokeAsync(this.SelectedItem).ConfigureAwait(true);
        }
    }

    private bool IsCellOccupied(byte cellSlot)
    {
        if (this._viewModel?.Items == null)
        {
            return false;
        }

        // Check if any item occupies this cell
        foreach (var item in this._viewModel.Items)
        {
            if (item.Item.Definition == null)
            {
                continue;
            }

            var itemSlot = item.Item.ItemSlot;
            
            // For equipped items (slot >= 0xC0), just check the single slot
            if (itemSlot >= InventoryConstants.FirstEquippableItemSlotIndex)
            {
                if (itemSlot == cellSlot)
                {
                    return true;
                }
                continue;
            }

            // For inventory items, check all occupied cells based on width×height
            var itemX = (byte)(itemSlot % InventoryConstants.RowSize);
            var itemY = (byte)(itemSlot / InventoryConstants.RowSize);
            var width = item.Item.Definition.Width;
            var height = item.Item.Definition.Height;

            var cellX = (byte)(cellSlot % InventoryConstants.RowSize);
            var cellY = (byte)(cellSlot / InventoryConstants.RowSize);

            // Check if cell is within the item's bounds
            if (cellX >= itemX && cellX < (itemX + width) &&
                cellY >= itemY && cellY < (itemY + height))
            {
                return true;
            }
        }

        return false;
    }

    private void OnCellDragOver(DragEventArgs e, bool isOccupied)
    {
        if (isOccupied)
        {
            e.DataTransfer.DropEffect = "none";
        }
        else
        {
            e.DataTransfer.DropEffect = "move";
        }
    }

    private void OnCellDragLeave(DragEventArgs e)
    {
        // Remove highlight - handled by CSS
    }

    private async Task OnCellDropAsync(DragEventArgs e, byte targetSlot, bool isOccupied)
    {
        var draggedItem = MuItem.GetDraggedItem();
        if (draggedItem == null)
        {
            return;
        }

        // Check if the item can be placed at this position
        if (!CanPlaceItemAt(targetSlot, draggedItem.Item))
        {
            return;
        }

        // Move the dragged item to the target slot
        draggedItem.Item.ItemSlot = targetSlot;

        MuItem.ClearDraggedItem();

        await this.OnItemMovedAsync().ConfigureAwait(true);
    }

    private bool CanPlaceItemAt(byte targetSlot, Item item)
    {
        if (item.Definition == null)
        {
            return false;
        }

        var targetX = (byte)(targetSlot % InventoryConstants.RowSize);
        var targetY = (byte)(targetSlot / InventoryConstants.RowSize);
        var width = item.Definition.Width;
        var height = item.Definition.Height;

        // Check if item would go out of bounds
        if (targetX + width > InventoryConstants.RowSize)
        {
            return false;
        }

        if (targetY + height > (this._viewModel?.Rows ?? 0))
        {
            return false;
        }

        // Check if any cell in the target area is occupied by another item
        for (byte dy = 0; dy < height; dy++)
        {
            for (byte dx = 0; dx < width; dx++)
            {
                var checkSlot = (byte)((targetY + dy) * InventoryConstants.RowSize + (targetX + dx));
                
                // Check if this cell is occupied by a different item
                if (IsCellOccupiedByOtherItem(checkSlot, item))
                {
                    return false;
                }
            }
        }

        return true;
    }

    private bool IsCellOccupiedByOtherItem(byte cellSlot, Item itemToPlace)
    {
        if (this._viewModel?.Items == null)
        {
            return false;
        }

        foreach (var item in this._viewModel.Items)
        {
            // Skip the item we're trying to place
            if (item.Item == itemToPlace)
            {
                continue;
            }

            if (item.Item.Definition == null)
            {
                continue;
            }

            var itemSlot = item.Item.ItemSlot;

            // For equipped items (not in inventory grid)
            if (itemSlot >= InventoryConstants.FirstEquippableItemSlotIndex)
            {
                if (itemSlot == cellSlot)
                {
                    return true;
                }
                continue;
            }

            // For inventory items, check all cells occupied by width × height
            var itemX = (byte)(itemSlot % InventoryConstants.RowSize);
            var itemY = (byte)(itemSlot / InventoryConstants.RowSize);
            var width = item.Item.Definition.Width;
            var height = item.Item.Definition.Height;

            for (byte dy = 0; dy < height; dy++)
            {
                for (byte dx = 0; dx < width; dx++)
                {
                    var occupiedSlot = (byte)((itemY + dy) * InventoryConstants.RowSize + (itemX + dx));
                    if (occupiedSlot == cellSlot)
                    {
                        return true;
                    }
                }
            }
        }

        }
        }

        return false;
    }
}
```
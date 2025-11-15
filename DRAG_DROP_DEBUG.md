# Drag & Drop Debugging Guide

## Enhanced Logging Added

The JavaScript drag & drop implementation now includes comprehensive logging with emoji indicators:

### Log Categories

- 🎮 **Initialization**: Script loading and setup
- 🖱️ **Mouse Events**: MouseDown, MouseMove, MouseUp
- 📦 **Item Data**: Item extraction and properties
- 🔍 **Validation**: Placement checks and collision detection
- 🎨 **Visual Feedback**: Drop zone creation and highlighting
- 🚀 **Movement**: Item positioning and slot updates
- ⌨️ **Keyboard Simulation**: WASD key event generation
- 🔄 **State Updates**: Class and position changes
- ❌ **Cancellation**: Drag cancellation events
- 🧹 **Cleanup**: Resource cleanup and state reset
- ⚠️ **Warnings**: Issues or missing elements

## How to Debug

1. **Open Browser Developer Console** (F12)
2. **Navigate to Character Edit page**
3. **Look for initialization logs**:
   ```
   🎮 InventoryDragDrop script loaded, readyState: ...
   🎮 DOM already loaded, initializing InventoryDragDrop immediately
   🎮 InventoryDragDrop: Constructor called
   🎮 InventoryDragDrop: Initializing...
   🎮 InventoryDragDrop: Setting up event listeners
   🎮 InventoryDragDrop: Event listeners attached
   🎮 InventoryDragDrop: Initialization complete
   ```

4. **Try to drag an item** and watch for:
   ```
   🖱️ MouseDown: Item clicked! <div class="...">
   🖱️ MouseDown: Original position: { left: ..., top: ... }
   🖱️ MouseDown: Added dragging-js class, cursor set to grabbing
   📦 extractItemData: { width: 1, height: 2, col: 0, row: 0 }
   🎨 showDropZones: Creating drop zone overlay
   🎨 showDropZones: Storage has 8 rows
   🎨 showDropZones: Created 64 drop zone cells
   ```

5. **Move the mouse** and watch for:
   ```
   🖱️ MouseMove: Grid position: { col: 3, row: 2, x: ..., y: ... }
   ```

6. **Release the mouse** and watch for:
   ```
   🖱️ MouseUp: Drop attempt starting
   🖱️ MouseUp: Target position: { targetCol: 3, targetRow: 2, targetSlot: 19 }
   🔍 canPlaceItem: Checking placement at { targetCol: 3, targetRow: 2 }
   ✅ MouseUp: Drop is valid, moving item to slot 19
   🚀 moveItemToSlot: Moving to slot 19
   ⌨️ simulateKeyboardMoves: Generated key sequence: dddsss
   🧹 cleanup: Removing drag state
   ```

## Common Issues to Look For

### Script Not Loading
- Missing: `🎮 InventoryDragDrop script loaded`
- **Solution**: Check if script tag is in _Host.cshtml
- **URL**: `/_content/MUnique.OpenMU.Web.ItemEditor/js/inventory-drag-drop.js`

### No Mouse Events
- Missing: `🖱️ MouseDown` logs when clicking items
- **Solution**: Check if `.mu-item-selector` elements exist
- **Verify**: Inspect element has the correct CSS class

### Drop Zones Not Created
- Missing: `🎨 showDropZones: Created X drop zone cells`
- **Solution**: Check if `.mu-item-storage` container exists
- **Verify**: Storage has correct `storage-rows4/8/15` class

### Collision Detection Issues
- Look for: `❌ canPlaceItem: Collision detected with item at ...`
- **Check**: All items have correct `c_X`, `r_X`, `w_X`, `h_X` classes

### State Not Updating
- Missing: `⌨️ simulateKeyboardMoves` and `⌨️ executeKeySequence` logs
- **Solution**: Check if Blazor keyboard handlers are working
- **Test**: Try manual WASD keyboard navigation first

## Quick Test Checklist

- [ ] Open browser console (F12)
- [ ] Navigate to Character Edit page
- [ ] See initialization logs (🎮)
- [ ] Click on an inventory item
- [ ] See mousedown logs (🖱️)
- [ ] See drop zones created (🎨)
- [ ] Move mouse over inventory
- [ ] See mousemove logs (🖱️) occasionally
- [ ] See visual green/red highlights
- [ ] Release mouse on valid spot
- [ ] See mouseup and movement logs (🚀, ⌨️)
- [ ] Item moves to new position

## Expected Console Output for Successful Drag

```
🎮 InventoryDragDrop script loaded, readyState: complete
🎮 DOM already loaded, initializing InventoryDragDrop immediately
🎮 InventoryDragDrop: Constructor called
🎮 InventoryDragDrop: Initializing...
🎮 InventoryDragDrop: Setting up event listeners
🎮 InventoryDragDrop: Event listeners attached
🎮 InventoryDragDrop: Initialization complete
🖱️ MouseDown: Item clicked! <div class="mu-item-selector...">
🖱️ MouseDown: Original position: {left: "0px", top: "0px"}
🖱️ MouseDown: Added dragging-js class, cursor set to grabbing
📦 extractItemData: {width: 1, height: 2, col: 0, row: 0, element: div.mu-item-selector}
🖱️ MouseDown: Item data extracted: {width: 1, height: 2, col: 0, row: 0, element: div.mu-item-selector}
🎨 showDropZones: Creating drop zone overlay
🎨 showDropZones: Storage has 8 rows
🎨 showDropZones: Created 64 drop zone cells
🖱️ MouseDown: Drop zones shown
🖱️ MouseMove: Grid position: {col: 2, row: 3, x: 105, y: 147}
🖱️ MouseUp: Drop attempt starting
🖱️ MouseUp: Target position: {targetCol: 2, targetRow: 3, targetSlot: 26}
🔍 canPlaceItem: Checking placement at {targetCol: 2, targetRow: 3}
🔍 canPlaceItem: Item size: {width: 1, height: 2, storageRows: 8}
🔍 canPlaceItem: Checking collisions with 12 items
✅ canPlaceItem: Placement is valid
✅ MouseUp: Drop is valid, moving item to slot 26
🚀 moveItemToSlot: Moving to slot 26
🚀 moveItemToSlot: Target grid position {targetCol: 2, targetRow: 3}
🔄 updatePositionClasses: {col: 2, row: 3}
🔄 updatePositionClasses: New classes: mu-item-selector c_2 r_3 w_1 h_2 dragging-js
⌨️ simulateKeyboardMoves: Generated key sequence: ddsss
⌨️ executeKeySequence: Dispatching key d
⌨️ executeKeySequence: Dispatching key d
⌨️ executeKeySequence: Dispatching key s
⌨️ executeKeySequence: Dispatching key s
⌨️ executeKeySequence: Dispatching key s
🧹 cleanup: Removing drag state
```

## Commit Info

- **Commit**: 3d251f04d
- **Message**: "feat: Add comprehensive logging to JavaScript drag & drop for debugging"
- **Files Changed**: inventory-drag-drop.js (+88 lines logging)

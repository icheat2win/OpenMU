// Modern Drag & Drop for MU Online Inventory
// Provides smooth, intuitive item dragging with visual feedback

class InventoryDragDrop {
    constructor() {
        this.draggedElement = null;
        this.draggedItem = null;
        this.originalPosition = null;
        this.dropZones = [];
        this.cellSize = 42;
        this.gridColumns = 8;
        this.debug = true; // Enable detailed logging
        
        console.log('🎮 InventoryDragDrop: Constructor called');
        this.init();
    }

    init() {
        console.log('🎮 InventoryDragDrop: Initializing...');
        this.setupEventListeners();
        this.createDropZoneOverlay();
        console.log('🎮 InventoryDragDrop: Initialization complete');
    }

    setupEventListeners() {
        console.log('🎮 InventoryDragDrop: Setting up event listeners');
        // Use event delegation for better performance
        document.addEventListener('mousedown', (e) => this.handleMouseDown(e));
        document.addEventListener('mousemove', (e) => this.handleMouseMove(e));
        document.addEventListener('mouseup', (e) => this.handleMouseUp(e));
        console.log('🎮 InventoryDragDrop: Event listeners attached');
    }

    handleMouseDown(e) {
        // Find if we clicked on an item
        const itemElement = e.target.closest('.mu-item-selector');
        if (!itemElement) {
            if (this.debug && e.target.closest('.mu-item-storage')) {
                console.log('🖱️ MouseDown: Clicked in inventory but not on item', e.target);
            }
            return;
        }
        
        console.log('🖱️ MouseDown: Item clicked!', itemElement);

        // Prevent default drag behavior
        e.preventDefault();

        this.draggedElement = itemElement;
        this.originalPosition = {
            left: itemElement.style.left,
            top: itemElement.style.top
        };
        
        console.log('🖱️ MouseDown: Original position:', this.originalPosition);

        // Add dragging class for visual feedback
        itemElement.classList.add('dragging-js');
        document.body.style.cursor = 'grabbing';
        console.log('🖱️ MouseDown: Added dragging-js class, cursor set to grabbing');

        // Extract item data from classes
        this.draggedItem = this.extractItemData(itemElement);
        console.log('🖱️ MouseDown: Item data extracted:', this.draggedItem);

        // Removed drop zone overlay - drag & drop works without visual grid
        console.log('🖱️ MouseDown: Ready to drag (no overlay needed)');
    }

    handleMouseMove(e) {
        if (!this.draggedElement) return;

        e.preventDefault();

        // Move the element with the mouse
        const storage = this.draggedElement.closest('.mu-item-storage');
        if (!storage) {
            if (this.debug) console.log('⚠️ MouseMove: No storage container found');
            return;
        }

        const rect = storage.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;

        // Calculate grid position
        const col = Math.floor(x / this.cellSize);
        const row = Math.floor(y / this.cellSize);
        
        if (this.debug && Math.random() < 0.1) { // Log 10% of moves to avoid spam
            console.log('🖱️ MouseMove: Grid position:', { col, row, x, y });
        }

        // Move the item visually to follow the mouse (snap to grid)
        this.draggedElement.style.left = `${col * this.cellSize}px`;
        this.draggedElement.style.top = `${row * this.cellSize}px`;
        this.draggedElement.style.position = 'absolute';
        this.draggedElement.style.zIndex = '1000';

        // Show visual feedback on the dragged item
        this.updateDragVisual(col, row, storage);
    }

    handleMouseUp(e) {
        if (!this.draggedElement) return;

        console.log('🖱️ MouseUp: Drop attempt starting');
        e.preventDefault();

        const storage = this.draggedElement.closest('.mu-item-storage');
        if (!storage) {
            console.log('⚠️ MouseUp: No storage container, canceling drag');
            this.cancelDrag();
            return;
        }

        const rect = storage.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;

        const targetCol = Math.floor(x / this.cellSize);
        const targetRow = Math.floor(y / this.cellSize);
        const targetSlot = targetRow * this.gridColumns + targetCol;
        
        console.log('🖱️ MouseUp: Target position:', { targetCol, targetRow, targetSlot });

        // Check if drop is valid
        if (this.canPlaceItem(targetCol, targetRow, storage)) {
            console.log('✅ MouseUp: Drop is valid, moving item to slot', targetSlot);
            // Call Blazor interop to update the item position
            this.moveItemToSlot(targetSlot);
        } else {
            console.log('❌ MouseUp: Drop is invalid, canceling drag');
            // Invalid drop - return to original position
            this.cancelDrag();
        }

        this.cleanup();
    }

    extractItemData(element) {
        const classes = element.className.split(' ');
        let width = 1, height = 1, col = 0, row = 0;

        classes.forEach(cls => {
            if (cls.startsWith('w_')) width = parseInt(cls.substring(2));
            if (cls.startsWith('h_')) height = parseInt(cls.substring(2));
            if (cls.startsWith('c_')) col = parseInt(cls.substring(2));
            if (cls.startsWith('r_')) row = parseInt(cls.substring(2));
        });
        
        const itemData = { width, height, col, row, element };
        console.log('📦 extractItemData:', itemData);
        return itemData;
    }

    canPlaceItem(targetCol, targetRow, storage) {
        console.log('🔍 canPlaceItem: Checking placement at', { targetCol, targetRow });
        if (!this.draggedItem) {
            console.log('⚠️ canPlaceItem: No draggedItem data');
            return false;
        }

        const { width, height } = this.draggedItem;
        const storageRows = this.getStorageRows(storage);
        
        console.log('🔍 canPlaceItem: Item size:', { width, height, storageRows });

        // Check bounds
        if (targetCol < 0 || targetCol + width > this.gridColumns) {
            console.log('❌ canPlaceItem: Out of bounds (column)', { targetCol, width, gridColumns: this.gridColumns });
            return false;
        }
        if (targetRow < 0 || targetRow + height > storageRows) {
            console.log('❌ canPlaceItem: Out of bounds (row)', { targetRow, height, storageRows });
            return false;
        }

        // Check collisions with other items
        const allItems = storage.querySelectorAll('.mu-item-selector');
        console.log('🔍 canPlaceItem: Checking collisions with', allItems.length, 'items');
        
        for (const item of allItems) {
            if (item === this.draggedElement) continue;

            const itemData = this.extractItemData(item);
            
            // Rectangle collision detection
            if (this.rectanglesOverlap(
                targetCol, targetRow, width, height,
                itemData.col, itemData.row, itemData.width, itemData.height
            )) {
                console.log('❌ canPlaceItem: Collision detected with item at', { col: itemData.col, row: itemData.row });
                return false;
            }
        }

        console.log('✅ canPlaceItem: Placement is valid');
        return true;
    }

    rectanglesOverlap(x1, y1, w1, h1, x2, y2, w2, h2) {
        return !(x1 + w1 <= x2 || x1 >= x2 + w2 || y1 + h1 <= y2 || y1 >= y2 + h2);
    }

    getStorageRows(storage) {
        if (storage.classList.contains('storage-rows4')) return 4;
        if (storage.classList.contains('storage-rows8')) return 8;
        if (storage.classList.contains('storage-rows15')) return 15;
        return 8; // default
    }

    updateDragVisual(col, row, storage) {
        // Check if the drop would be valid
        const isValid = this.canPlaceItem(col, row, storage);
        
        // Update the dragged item's visual appearance with stronger glow
        if (isValid) {
            // Green glow for valid placement
            this.draggedElement.style.boxShadow = '0 0 30px 8px rgba(124, 252, 0, 0.9), inset 0 0 20px rgba(124, 252, 0, 0.3)';
            this.draggedElement.style.border = '3px solid rgba(124, 252, 0, 1)';
            this.draggedElement.style.backgroundColor = 'rgba(124, 252, 0, 0.2)';
        } else {
            // Red glow for invalid placement
            this.draggedElement.style.boxShadow = '0 0 30px 8px rgba(255, 0, 0, 0.9), inset 0 0 20px rgba(255, 0, 0, 0.3)';
            this.draggedElement.style.border = '3px solid rgba(255, 0, 0, 1)';
            this.draggedElement.style.backgroundColor = 'rgba(255, 0, 0, 0.2)';
        }
    }

    moveItemToSlot(targetSlot) {
        console.log('🚀 moveItemToSlot: Moving to slot', targetSlot);
        // Update visual position immediately for smooth UX
        if (this.draggedElement) {
            const targetCol = targetSlot % this.gridColumns;
            const targetRow = Math.floor(targetSlot / this.gridColumns);
            
            console.log('🚀 moveItemToSlot: Target grid position', { targetCol, targetRow });
            
            // Update position classes
            this.updatePositionClasses(this.draggedElement, targetCol, targetRow);
            
            // Also update the parent MuItem div
            const parentItem = this.draggedElement.previousElementSibling;
            if (parentItem && parentItem.classList.contains('mu-item')) {
                this.updatePositionClasses(parentItem, targetCol, targetRow);
            }
            
            // Trigger keyboard navigation to update Blazor state
            // Simulate the item movement using the existing keyboard navigation system
            const currentSlot = this.draggedItem.row * this.gridColumns + this.draggedItem.col;
            const colDiff = targetCol - this.draggedItem.col;
            const rowDiff = targetRow - this.draggedItem.row;
            
            // Use setTimeout to allow UI to update first
            setTimeout(() => {
                // Trigger moves via keyboard events which Blazor already handles
                this.simulateKeyboardMoves(colDiff, rowDiff);
            }, 50);
        }
    }

    simulateKeyboardMoves(colDiff, rowDiff) {
        if (!this.draggedElement) return;
        
        const moveSequence = [];
        
        // Move horizontally first
        if (colDiff > 0) {
            for (let i = 0; i < colDiff; i++) {
                moveSequence.push('d'); // Move right
            }
        } else if (colDiff < 0) {
            for (let i = 0; i < Math.abs(colDiff); i++) {
                moveSequence.push('a'); // Move left
            }
        }
        
        // Then move vertically
        if (rowDiff > 0) {
            for (let i = 0; i < rowDiff; i++) {
                moveSequence.push('s'); // Move down
            }
        } else if (rowDiff < 0) {
            for (let i = 0; i < Math.abs(rowDiff); i++) {
                moveSequence.push('w'); // Move up
            }
        }
        
        console.log('⌨️ simulateKeyboardMoves: Generated key sequence:', moveSequence.join(''));
        
        // Execute moves sequentially with small delays
        this.executeKeySequence(moveSequence, 0);
    }

    executeKeySequence(sequence, index) {
        if (index >= sequence.length || !this.draggedElement) return;
        
        const key = sequence[index];
        const keyEvent = new KeyboardEvent('keydown', {
            key: key,
            bubbles: true,
            cancelable: true
        });
        
        console.log('⌨️ executeKeySequence: Dispatching key', sequence[index]);
        this.draggedElement.dispatchEvent(keyEvent);
        
        // Continue with next key after short delay
        setTimeout(() => {
            this.executeKeySequence(sequence, index + 1);
        }, 10);
    }

    updatePositionClasses(element, col, row) {
        console.log('🔄 updatePositionClasses:', { col, row });
        // Remove old position classes
        const classes = element.className.split(' ');
        const newClasses = classes.filter(c => !c.startsWith('c_') && !c.startsWith('r_'));
        
        // Add new position classes
        newClasses.push(`c_${col}`, `r_${row}`);
        element.className = newClasses.join(' ');
        console.log('🔄 updatePositionClasses: New classes:', element.className);
    }

    cancelDrag() {
        console.log('❌ cancelDrag: Reverting to original position');
        if (this.draggedElement && this.originalPosition) {
            this.draggedElement.style.left = this.originalPosition.left;
            this.draggedElement.style.top = this.originalPosition.top;
        }
    }

    cleanup() {
        console.log('🧹 cleanup: Removing drag state');
        if (this.draggedElement) {
            this.draggedElement.classList.remove('dragging-js');
            // Remove visual feedback styling
            this.draggedElement.style.boxShadow = '';
            this.draggedElement.style.border = '';
            this.draggedElement.style.backgroundColor = '';
            this.draggedElement.style.zIndex = '';
        }

        document.body.style.cursor = '';
        
        // Remove drop zone overlay
        const overlays = document.querySelectorAll('.drop-zone-overlay-js');
        overlays.forEach(overlay => overlay.remove());

        this.draggedElement = null;
        this.draggedItem = null;
        this.originalPosition = null;
    }
}

// Initialize when DOM is ready
console.log('🎮 InventoryDragDrop script loaded, readyState:', document.readyState);
console.log('🎮 Script location: inventory-drag-drop.js');

// Add a visible alert to confirm script is loading
console.warn('⚡ DRAG & DROP SCRIPT LOADED - Check console for logs');

if (document.readyState === 'loading') {
    console.log('🎮 Waiting for DOMContentLoaded...');
    document.addEventListener('DOMContentLoaded', () => {
        console.log('🎮 DOMContentLoaded fired, initializing InventoryDragDrop');
        console.log('🎮 Looking for .mu-item-selector elements...');
        const items = document.querySelectorAll('.mu-item-selector');
        console.log('🎮 Found', items.length, 'item selector elements');
        
        window.inventoryDragDrop = new InventoryDragDrop();
        console.warn('✅ InventoryDragDrop instance created and attached to window');
    });
} else {
    console.log('🎮 DOM already loaded, initializing InventoryDragDrop immediately');
    console.log('🎮 Looking for .mu-item-selector elements...');
    const items = document.querySelectorAll('.mu-item-selector');
    console.log('🎮 Found', items.length, 'item selector elements');
    
    window.inventoryDragDrop = new InventoryDragDrop();
    console.warn('✅ InventoryDragDrop instance created and attached to window');
}


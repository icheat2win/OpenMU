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
        
        this.init();
    }

    init() {
        this.setupEventListeners();
        this.createDropZoneOverlay();
    }

    setupEventListeners() {
        // Use event delegation for better performance
        document.addEventListener('mousedown', (e) => this.handleMouseDown(e));
        document.addEventListener('mousemove', (e) => this.handleMouseMove(e));
        document.addEventListener('mouseup', (e) => this.handleMouseUp(e));
    }

    handleMouseDown(e) {
        // Find if we clicked on an item
        const itemElement = e.target.closest('.mu-item-selector');
        if (!itemElement) return;

        // Prevent default drag behavior
        e.preventDefault();

        this.draggedElement = itemElement;
        this.originalPosition = {
            left: itemElement.style.left,
            top: itemElement.style.top
        };

        // Add dragging class for visual feedback
        itemElement.classList.add('dragging-js');
        document.body.style.cursor = 'grabbing';

        // Extract item data from classes
        this.draggedItem = this.extractItemData(itemElement);

        // Show drop zones
        this.showDropZones();
    }

    handleMouseMove(e) {
        if (!this.draggedElement) return;

        e.preventDefault();

        // Move the element with the mouse
        const storage = this.draggedElement.closest('.mu-item-storage');
        if (!storage) return;

        const rect = storage.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;

        // Calculate grid position
        const col = Math.floor(x / this.cellSize);
        const row = Math.floor(y / this.cellSize);

        // Update drop zone highlights
        this.updateDropZoneHighlights(col, row);

        // Optional: Move the item visually (can be disabled for less distraction)
        // this.draggedElement.style.left = `${col * this.cellSize}px`;
        // this.draggedElement.style.top = `${row * this.cellSize}px`;
    }

    handleMouseUp(e) {
        if (!this.draggedElement) return;

        e.preventDefault();

        const storage = this.draggedElement.closest('.mu-item-storage');
        if (!storage) {
            this.cancelDrag();
            return;
        }

        const rect = storage.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;

        const targetCol = Math.floor(x / this.cellSize);
        const targetRow = Math.floor(y / this.cellSize);
        const targetSlot = targetRow * this.gridColumns + targetCol;

        // Check if drop is valid
        if (this.canPlaceItem(targetCol, targetRow, storage)) {
            // Call Blazor interop to update the item position
            this.moveItemToSlot(targetSlot);
        } else {
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

        return { width, height, col, row, element };
    }

    canPlaceItem(targetCol, targetRow, storage) {
        if (!this.draggedItem) return false;

        const { width, height } = this.draggedItem;
        const storageRows = this.getStorageRows(storage);

        // Check bounds
        if (targetCol < 0 || targetCol + width > this.gridColumns) return false;
        if (targetRow < 0 || targetRow + height > storageRows) return false;

        // Check collisions with other items
        const allItems = storage.querySelectorAll('.mu-item-selector');
        for (const item of allItems) {
            if (item === this.draggedElement) continue;

            const itemData = this.extractItemData(item);
            
            // Rectangle collision detection
            if (this.rectanglesOverlap(
                targetCol, targetRow, width, height,
                itemData.col, itemData.row, itemData.width, itemData.height
            )) {
                return false;
            }
        }

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

    showDropZones() {
        const storage = this.draggedElement?.closest('.mu-item-storage');
        if (!storage) return;

        const storageRows = this.getStorageRows(storage);
        
        // Create drop zone overlay if it doesn't exist
        let overlay = storage.querySelector('.drop-zone-overlay-js');
        if (!overlay) {
            overlay = document.createElement('div');
            overlay.className = 'drop-zone-overlay-js';
            overlay.style.cssText = `
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                pointer-events: none;
                z-index: 60;
            `;
            storage.appendChild(overlay);
        }

        overlay.innerHTML = '';

        // Create grid cells
        for (let row = 0; row < storageRows; row++) {
            for (let col = 0; col < this.gridColumns; col++) {
                const cell = document.createElement('div');
                cell.className = 'drop-zone-cell-js';
                cell.dataset.col = col;
                cell.dataset.row = row;
                cell.style.cssText = `
                    position: absolute;
                    left: ${col * this.cellSize}px;
                    top: ${row * this.cellSize}px;
                    width: ${this.cellSize}px;
                    height: ${this.cellSize}px;
                    transition: background-color 0.1s ease, box-shadow 0.1s ease;
                `;
                overlay.appendChild(cell);
            }
        }
    }

    updateDropZoneHighlights(hoveredCol, hoveredRow) {
        const overlay = this.draggedElement?.closest('.mu-item-storage')?.querySelector('.drop-zone-overlay-js');
        if (!overlay) return;

        const cells = overlay.querySelectorAll('.drop-zone-cell-js');
        const storage = this.draggedElement.closest('.mu-item-storage');

        cells.forEach(cell => {
            const col = parseInt(cell.dataset.col);
            const row = parseInt(cell.dataset.row);
            const { width, height } = this.draggedItem;

            // Check if this cell would be occupied by the dragged item
            const wouldOccupy = (
                col >= hoveredCol && 
                col < hoveredCol + width &&
                row >= hoveredRow && 
                row < hoveredRow + height
            );

            if (wouldOccupy) {
                // Check if placement is valid
                const isValid = this.canPlaceItem(hoveredCol, hoveredRow, storage);
                
                if (isValid) {
                    cell.style.backgroundColor = 'rgba(124, 252, 0, 0.4)';
                    cell.style.boxShadow = 'inset 0 0 0 2px rgba(124, 252, 0, 0.9)';
                } else {
                    cell.style.backgroundColor = 'rgba(255, 0, 0, 0.4)';
                    cell.style.boxShadow = 'inset 0 0 0 2px rgba(255, 0, 0, 0.9)';
                }
            } else {
                cell.style.backgroundColor = '';
                cell.style.boxShadow = '';
            }
        });
    }

    moveItemToSlot(targetSlot) {
        // Update visual position immediately for smooth UX
        if (this.draggedElement) {
            const targetCol = targetSlot % this.gridColumns;
            const targetRow = Math.floor(targetSlot / this.gridColumns);
            
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
        
        this.draggedElement.dispatchEvent(keyEvent);
        
        // Continue with next key after short delay
        setTimeout(() => {
            this.executeKeySequence(sequence, index + 1);
        }, 10);
    }

    updatePositionClasses(element, col, row) {
        // Remove old position classes
        const classes = element.className.split(' ');
        const newClasses = classes.filter(c => !c.startsWith('c_') && !c.startsWith('r_'));
        
        // Add new position classes
        newClasses.push(`c_${col}`, `r_${row}`);
        element.className = newClasses.join(' ');
    }

    cancelDrag() {
        if (this.draggedElement && this.originalPosition) {
            this.draggedElement.style.left = this.originalPosition.left;
            this.draggedElement.style.top = this.originalPosition.top;
        }
    }

    cleanup() {
        if (this.draggedElement) {
            this.draggedElement.classList.remove('dragging-js');
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
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        window.inventoryDragDrop = new InventoryDragDrop();
    });
} else {
    window.inventoryDragDrop = new InventoryDragDrop();
}

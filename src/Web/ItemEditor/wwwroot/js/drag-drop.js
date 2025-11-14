// Enhanced drag and drop visual feedback
window.muInventoryDragDrop = {
    currentDraggedElement: null,
    draggedItemWidth: 1,
    draggedItemHeight: 1,
    isDragging: false,
    startX: 0,
    startY: 0,
    startSlot: 0,
    currentRow: 0,
    currentCol: 0,

    initializeDragHandlers: function () {
        console.log('Initializing MU Inventory drag-drop handlers...');
        
        // Use mousedown instead of dragstart
        document.addEventListener('mousedown', function (e) {
            const item = e.target.closest('.mu-item-selector');
            if (item && item.getAttribute('draggable') === 'true') {
                e.preventDefault(); // Prevent default drag behavior
                
                console.log('Mouse down on item');
                muInventoryDragDrop.currentDraggedElement = item;
                muInventoryDragDrop.isDragging = false; // Not dragging yet, just mousedown
                muInventoryDragDrop.startX = e.clientX;
                muInventoryDragDrop.startY = e.clientY;
                
                // Extract item dimensions
                const widthClass = Array.from(item.classList).find(c => c.startsWith('w_'));
                const heightClass = Array.from(item.classList).find(c => c.startsWith('h_'));
                muInventoryDragDrop.draggedItemWidth = widthClass ? parseInt(widthClass.split('_')[1]) : 1;
                muInventoryDragDrop.draggedItemHeight = heightClass ? parseInt(heightClass.split('_')[1]) : 1;
                
                // Get current position
                const rowClass = Array.from(item.classList).find(c => c.startsWith('r_'));
                const colClass = Array.from(item.classList).find(c => c.startsWith('c_'));
                muInventoryDragDrop.currentRow = rowClass ? parseInt(rowClass.split('_')[1]) : 0;
                muInventoryDragDrop.currentCol = colClass ? parseInt(colClass.split('_')[1]) : 0;
                muInventoryDragDrop.startSlot = muInventoryDragDrop.currentRow * 8 + muInventoryDragDrop.currentCol;
                
                console.log('Item dimensions:', muInventoryDragDrop.draggedItemWidth, 'x', muInventoryDragDrop.draggedItemHeight);
                console.log('Start position: row', muInventoryDragDrop.currentRow, 'col', muInventoryDragDrop.currentCol);
            }
        });

        document.addEventListener('mousemove', function (e) {
            if (!muInventoryDragDrop.currentDraggedElement) return;
            
            const deltaX = e.clientX - muInventoryDragDrop.startX;
            const deltaY = e.clientY - muInventoryDragDrop.startY;
            
            // Start dragging if moved more than 5 pixels
            if (!muInventoryDragDrop.isDragging && (Math.abs(deltaX) > 5 || Math.abs(deltaY) > 5)) {
                muInventoryDragDrop.isDragging = true;
                muInventoryDragDrop.currentDraggedElement.classList.add('dragging');
                console.log('Drag started on item');
            }
            
            if (!muInventoryDragDrop.isDragging) return;
            
            // Calculate which cell we're over based on mouse position
            const cellSize = 42; // pixels
            const movedCells = {
                x: Math.round(deltaX / cellSize),
                y: Math.round(deltaY / cellSize)
            };
            
            const targetRow = muInventoryDragDrop.startSlot / 8 | 0; // Start row
            const targetCol = muInventoryDragDrop.startSlot % 8;     // Start col
            
            const newRow = targetRow + movedCells.y;
            const newCol = targetCol + movedCells.x;
            
            // Find and highlight the target cells
            muInventoryDragDrop.highlightCells(newRow, newCol);
        });

        document.addEventListener('mouseup', function (e) {
            if (!muInventoryDragDrop.currentDraggedElement) return;
            
            if (muInventoryDragDrop.isDragging) {
                console.log('Drag ended');
                
                const deltaX = e.clientX - muInventoryDragDrop.startX;
                const deltaY = e.clientY - muInventoryDragDrop.startY;
                
                const cellSize = 42;
                const movedCells = {
                    x: Math.round(deltaX / cellSize),
                    y: Math.round(deltaY / cellSize)
                };
                
                const startRow = muInventoryDragDrop.startSlot / 8 | 0;
                const startCol = muInventoryDragDrop.startSlot % 8;
                const targetRow = startRow + movedCells.y;
                const targetCol = startCol + movedCells.x;
                
                // Check if the target position is valid (no overlap)
                if (muInventoryDragDrop.canPlaceAt(targetRow, targetCol)) {
                    // Simulate WSAD keypresses
                    const movesX = Math.abs(movedCells.x);
                    const movesY = Math.abs(movedCells.y);
                    const directionX = movedCells.x > 0 ? 'd' : 'a';
                    const directionY = movedCells.y > 0 ? 's' : 'w';
                    
                    console.log('Moving', movesX, 'cells', directionX, 'and', movesY, 'cells', directionY);
                    
                    // Trigger keyboard events to move the item
                    muInventoryDragDrop.simulateMovement(movesX, directionX, movesY, directionY);
                } else {
                    console.log('Cannot place item at target position - overlap detected');
                }
                
                muInventoryDragDrop.currentDraggedElement.classList.remove('dragging');
            }
            
            // Clean up
            document.querySelectorAll('.drag-over-valid, .drag-over-invalid').forEach(function (el) {
                el.classList.remove('drag-over-valid', 'drag-over-invalid');
            });
            
            muInventoryDragDrop.currentDraggedElement = null;
            muInventoryDragDrop.isDragging = false;
        });

        console.log('MU Inventory drag-drop handlers initialized');
    },

    highlightCells: function(targetRow, targetCol) {
        // Remove previous highlights
        document.querySelectorAll('.drag-over-valid, .drag-over-invalid').forEach(function (el) {
            el.classList.remove('drag-over-valid', 'drag-over-invalid');
        });
        
        const allCells = document.querySelectorAll('.drop-zone-cell');
        if (allCells.length === 0) return;
        
        const maxRows = Math.max(...Array.from(allCells).map(c => parseInt(c.getAttribute('data-row')))) + 1;
        const maxCols = 8;
        
        let canPlace = this.canPlaceAt(targetRow, targetCol);
        const cellsToHighlight = [];
        
        // Collect all cells that would be occupied
        for (let dy = 0; dy < this.draggedItemHeight; dy++) {
            for (let dx = 0; dx < this.draggedItemWidth; dx++) {
                const checkRow = targetRow + dy;
                const checkCol = targetCol + dx;
                
                if (checkRow < 0 || checkRow >= maxRows || checkCol < 0 || checkCol >= maxCols) {
                    continue;
                }
                
                const cell = Array.from(allCells).find(c => 
                    parseInt(c.getAttribute('data-row')) === checkRow && 
                    parseInt(c.getAttribute('data-col')) === checkCol
                );
                
                if (cell) {
                    cellsToHighlight.push(cell);
                }
            }
        }
        
        const highlightClass = canPlace ? 'drag-over-valid' : 'drag-over-invalid';
        cellsToHighlight.forEach(function(cell) {
            cell.classList.add(highlightClass);
        });
    },

    canPlaceAt: function(targetRow, targetCol) {
        const allCells = document.querySelectorAll('.drop-zone-cell');
        if (allCells.length === 0) return false;
        
        const maxRows = Math.max(...Array.from(allCells).map(c => parseInt(c.getAttribute('data-row')))) + 1;
        const maxCols = 8;
        
        // Check all cells that would be occupied by this item
        for (let dy = 0; dy < this.draggedItemHeight; dy++) {
            for (let dx = 0; dx < this.draggedItemWidth; dx++) {
                const checkRow = targetRow + dy;
                const checkCol = targetCol + dx;
                
                // Check bounds
                if (checkRow < 0 || checkRow >= maxRows || checkCol < 0 || checkCol >= maxCols) {
                    return false;
                }
                
                // Find the cell at this position
                const cell = Array.from(allCells).find(c => 
                    parseInt(c.getAttribute('data-row')) === checkRow && 
                    parseInt(c.getAttribute('data-col')) === checkCol
                );
                
                // Cell doesn't exist or is occupied by another item
                if (!cell || cell.classList.contains('occupied')) {
                    return false;
                }
            }
        }
        
        return true;
    },

    simulateMovement: function(movesX, directionX, movesY, directionY) {
        const element = this.currentDraggedElement;
        if (!element) return;
        
        // Move horizontally first
        for (let i = 0; i < movesX; i++) {
            const event = new KeyboardEvent('keydown', {
                key: directionX,
                bubbles: true,
                cancelable: true
            });
            element.dispatchEvent(event);
        }
        
        // Then move vertically
        for (let i = 0; i < movesY; i++) {
            const event = new KeyboardEvent('keydown', {
                key: directionY,
                bubbles: true,
                cancelable: true
            });
            element.dispatchEvent(event);
        }
    }
};

// Auto-initialize
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() {
        muInventoryDragDrop.initializeDragHandlers();
    });
} else {
    muInventoryDragDrop.initializeDragHandlers();
}

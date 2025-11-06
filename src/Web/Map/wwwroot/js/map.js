// plain javascript to make JS Interop easier

function CreateMap(serverId, mapId, containerId, appId) {
    console.debug("Creating map; serverId: ", serverId, ", mapId: ", mapId, ", containerId: ", containerId, ", appId: ", appId);

    let stats = null;
    if (typeof Stats === "function") {
        stats = new Stats();
        stats.domElement.style.position = "relative";
        stats.domElement.style.top = "0";
        document.getElementById(containerId).appendChild(stats.domElement);
    }

    // Callback function to handle object selection on map
    function onObjectSelected(objectData) {
        const selectedInfoDiv = document.getElementById("selected_info");
        if (selectedInfoDiv && objectData) {
            // Update the displayed information
            document.getElementById("objectData_name").textContent = objectData.name || "Unknown";
            document.getElementById("objectData_id").textContent = objectData.id || "N/A";
            document.getElementById("objectData_x").textContent = objectData.x !== undefined ? objectData.x : "N/A";
            document.getElementById("objectData_y").textContent = objectData.y !== undefined ? objectData.y : "N/A";
            
            // Show the info div
            selectedInfoDiv.style.display = "block";
        }
    }

    System.import("MapApp")
        .then((module) => {
            console.log('MapApp module resolved');
            window[appId] = new module.MapApp(stats, serverId, mapId, document.getElementById(containerId), onObjectSelected);
        });
}

function DisposeMap(identifier) {
    console.debug("Disposing map; containerId: ", identifier);
    let map = window[identifier];
    if (map) {
        map.dispose();
        delete window[identifier];
    }
}

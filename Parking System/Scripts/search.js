console.info("search.js loaded");

var searchTimer = null;

function escapeHtml(value) {
    return (value || "")
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;");
}

function normalizeVehicleNumber(value) {
    return (value || "").toUpperCase().replace(/\s+/g, "");
}

function isValidPartialVehicleNumber(value) {
    return /^[A-Z0-9]*$/.test(value);
}

function isValidVehicleNumber(value) {
    return /^[A-Z0-9]{4,15}$/.test(value);
}

function renderEmpty(message) {
    var results = document.getElementById("searchResults");
    results.innerHTML = `
        <div style="padding: 2rem 1rem; color: var(--text-muted);">
            <p>${escapeHtml(message)}</p>
        </div>`;
}

var lastResults = [];

function renderResults(items) {
    var results = document.getElementById("searchResults");
    lastResults = items || [];

    if (!items || items.length === 0) {
        renderEmpty("No matching vehicles found");
        return;
    }

    var html = items.map(function (v) {
        // Simple color coding: if it has an entry time but no exit (which is the case for this API), it's "Parked"
        const statusColor = 'var(--success)';
        const statusText = 'Currently Parked';

        return `
            <div style="text-align: left; padding: 1.25rem; border-radius: 12px; background: var(--surface); border: 1px solid var(--border); border-left: 5px solid ${statusColor}; box-shadow: var(--shadow); margin-bottom: 1rem; position: relative;">
                <div style="position: absolute; top: 1rem; right: 1.25rem; font-size: 0.7rem; font-weight: 700; text-transform: uppercase; color: ${statusColor}; background: var(--primary-muted); padding: 2px 8px; border-radius: 4px;">
                    ${statusText}
                </div>
                <strong style="font-size: 1.1rem; color: var(--primary);">${escapeHtml(v.vehicleNumber)}</strong> 
                <span style="color: var(--text-muted); font-size: 0.85rem; margin-left: 0.5rem;">(${escapeHtml(v.vehicleType)})</span><br/>
                
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.5rem; margin-top: 0.75rem; font-size: 0.9rem;">
                    <div><span style="color: var(--text-muted);">Owner:</span> ${escapeHtml(v.ownerName)}</div>
                    <div><span style="color: var(--text-muted);">Phone:</span> ${escapeHtml(v.phoneNumber)}</div>
                    <div><span style="color: var(--text-muted);">Slot:</span> <span style="font-weight: 700;">${escapeHtml(v.slotNumber)}</span></div>
                    <div><span style="color: var(--text-muted);">Entry:</span> ${escapeHtml(v.entryTime)}</div>
                </div>
            </div>`;
    }).join("");

    results.innerHTML = html;
}

function exportToCSV() {
    if (lastResults.length === 0) {
        if (typeof Toast !== 'undefined') Toast.warning("No data to export");
        else alert("No data to export");
        return;
    }

    const headers = ["Vehicle Number", "Vehicle Type", "Owner Name", "Phone", "Slot", "Entry Time"];
    const rows = lastResults.map(v => [
        v.vehicleNumber,
        v.vehicleType,
        v.ownerName,
        v.phoneNumber,
        v.slotNumber,
        v.entryTime
    ]);

    let csvContent = "data:text/csv;charset=utf-8,"
        + headers.join(",") + "\n"
        + rows.map(e => e.join(",")).join("\n");

    const encodedUri = encodeURI(csvContent);
    const link = document.createElement("a");
    link.setAttribute("href", encodedUri);
    link.setAttribute("download", `parking_search_${new Date().getTime()}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);

    if (typeof Toast !== 'undefined') Toast.success("Exported successfully!");
}

function performSearch() {
    var input = document.getElementById("searchInput");
    var query = normalizeVehicleNumber(input.value);

    input.value = query;

    if (!query) {
        renderEmpty("Enter a vehicle number to search");
        return;
    }

    if (!isValidPartialVehicleNumber(query)) {
        renderEmpty("Only letters and numbers are allowed");
        return;
    }

    if (query.length < 2) {
        renderEmpty("Type at least 2 characters");
        return;
    }

    renderEmpty("Searching...");

    var formData = new URLSearchParams();
    formData.append("query", query);

    fetch("/API/searchVehicle.ashx", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: formData
    })
        .then(function (res) { return res.json(); })
        .then(function (data) {
            if (!data.success) {
                renderEmpty(data.message || "Search failed");
                return;
            }

            renderResults(data.items);
        })
        .catch(function () {
            renderEmpty("Network error. Please try again.");
        });
}

document.addEventListener("DOMContentLoaded", function () {
    var input = document.getElementById("searchInput");
    if (!input) return;

    input.addEventListener("input", function () {
        var normalized = normalizeVehicleNumber(input.value);
        if (!isValidPartialVehicleNumber(normalized)) {
            renderEmpty("Only letters and numbers are allowed");
            return;
        }

        clearTimeout(searchTimer);
        searchTimer = setTimeout(performSearch, 250);
    });
});
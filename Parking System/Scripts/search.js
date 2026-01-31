console.info("search.js loaded");

var searchTimer = null;

function escapeHtml(value) {
    return (value || "")
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;");
}

function renderEmpty(message) {
    var results = document.getElementById("searchResults");
    results.innerHTML = `
        <div style="padding: 2rem 1rem; color: var(--text-muted);">
            <p>${escapeHtml(message)}</p>
        </div>`;
}

function renderResults(items) {
    var results = document.getElementById("searchResults");

    if (!items || items.length === 0) {
        renderEmpty("No matching vehicles found");
        return;
    }

    var html = items.map(function (v) {
        return `
            <div style="text-align: left; padding: 1rem; border-radius: 12px; background: #fff; border: 1px solid #f1f5f9; box-shadow: 0 2px 8px rgba(0,0,0,0.06); margin-bottom: 1rem;">
                <strong>${escapeHtml(v.vehicleNumber)}</strong> (${escapeHtml(v.vehicleType)})<br/>
                Owner: ${escapeHtml(v.ownerName)}<br/>
                Phone: ${escapeHtml(v.phoneNumber)}<br/>
                Slot: ${escapeHtml(v.slotNumber)}<br/>
                Entry: ${escapeHtml(v.entryTime)}
            </div>`;
    }).join("");

    results.innerHTML = html;
}

function performSearch() {
    var input = document.getElementById("searchInput");
    var query = (input.value || "").trim().toUpperCase();

    if (!query) {
        renderEmpty("Enter a vehicle number to search");
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
        clearTimeout(searchTimer);
        searchTimer = setTimeout(performSearch, 250);
    });
});
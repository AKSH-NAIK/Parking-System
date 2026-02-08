// dashboard.js - Client-side dashboard functionality
console.info("dashboard.js loaded");

function logout() {
    fetch('/API/logout.ashx', { method: 'POST' })
        .then(function () {
            window.location.href = 'Login.aspx';
        })
        .catch(function () {
            window.location.href = 'Login.aspx';
        });
}

function goEntry2() {
    window.location.href = 'Entry2Wheeler.aspx';
}

function goEntry4() {
    window.location.href = 'Entry4Wheeler.aspx';
}

function goExit() {
    window.location.href = 'ExitVehicle.aspx';
}

function searchVehicle() {
    window.location.href = 'searchvehicle.aspx';
}

function updateTime() {
    var now = new Date();
    var options = { weekday: 'short', year: 'numeric', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit' };
    var timeString = now.toLocaleDateString('en-US', options);

    var clockElement = document.getElementById('clock');
    if (clockElement) {
        clockElement.innerText = timeString;
    }
}

function updateSlotCard(prefix, stats) {
    if (!stats) return;

    document.getElementById(prefix + "Total").innerText = stats.Total;
    document.getElementById(prefix + "Occupied").innerText = stats.Occupied;
    document.getElementById(prefix + "Available").innerText = stats.Available;

    document.getElementById(prefix + "OccupiedPercent").innerText = "Occupied " + stats.OccupiedPercent + "%";
    document.getElementById(prefix + "AvailablePercent").innerText = "Available " + stats.AvailablePercent + "%";

    document.getElementById(prefix + "OccupiedBar").style.width = stats.OccupiedPercent + "%";
    document.getElementById(prefix + "AvailableBar").style.width = stats.AvailablePercent + "%";
}

function loadStats() {
    // Add timestamp to prevent caching
    fetch('/API/dashboardStats.ashx?v=' + new Date().getTime(), { method: 'GET' })
        .then(function (res) { return res.json(); })
        .then(function (data) {
            if (!data.success) return;

            updateSlotCard("twoWheeler", data.data.TwoWheeler);
            updateSlotCard("fourWheeler", data.data.FourWheeler);

            var today = document.getElementById("revenue-today");
            var month = document.getElementById("revenue-month");

            if (today) {
                today.innerText = "₹ " + Number(data.data.RevenueToday || 0).toFixed(2);
            }
            if (month) {
                month.innerText = "₹ " + Number(data.data.RevenueMonth || 0).toFixed(2);
            }
        })
        .catch(function () {
            console.warn("Failed to load dashboard stats.");
        });
}

function refreshStats() {
    console.log("Manual Refresh Triggered");
    loadStats();
}

setInterval(updateTime, 1000);
updateTime();

document.addEventListener('DOMContentLoaded', function () {
    loadStats();
    setInterval(loadStats, 10000); // refresh every 10 seconds
});


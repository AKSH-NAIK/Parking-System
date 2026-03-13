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

// Chart instances
let occupancyChart = null;
let revenueChart = null;

function initCharts() {
    const ctxOcc = document.getElementById('occupancyChart');
    const ctxRev = document.getElementById('revenueChart');

    if (ctxOcc) {
        occupancyChart = new Chart(ctxOcc, {
            type: 'doughnut',
            data: {
                labels: ['Occupied', 'Available'],
                datasets: [{
                    data: [0, 100],
                    backgroundColor: ['#ef4444', '#10b981'],
                    borderWidth: 0,
                    hoverOffset: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: 'bottom', labels: { color: '#a1a1aa' } }
                }
            }
        });
    }

    if (ctxRev) {
        revenueChart = new Chart(ctxRev, {
            type: 'bar',
            data: {
                labels: ['Today', 'Month'],
                datasets: [{
                    label: 'Revenue (₹)',
                    data: [0, 0],
                    backgroundColor: ['#00ffc3', '#0EA5E9'],
                    borderRadius: 5
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: { beginAtZero: true, grid: { color: '#262626' }, ticks: { color: '#a1a1aa' } },
                    x: { grid: { display: false }, ticks: { color: '#a1a1aa' } }
                },
                plugins: {
                    legend: { display: false }
                }
            }
        });
    }
}

function updateCharts(data) {
    if (occupancyChart && data.TwoWheeler && data.FourWheeler) {
        const totalOcc = data.TwoWheeler.Occupied + data.FourWheeler.Occupied;
        const totalAvail = data.TwoWheeler.Available + data.FourWheeler.Available;
        occupancyChart.data.datasets[0].data = [totalOcc, totalAvail];
        occupancyChart.update();
    }

    if (revenueChart) {
        revenueChart.data.datasets[0].data = [data.RevenueToday || 0, data.RevenueMonth || 0];
        revenueChart.update();
    }
}

function loadStats(isManualRefresh = false) {
    // Add timestamp to prevent caching
    fetch('/API/dashboardStats.ashx?v=' + new Date().getTime(), { method: 'GET' })
        .then(function (res) { return res.json(); })
        .then(function (data) {
            if (!data.success) {
                if (isManualRefresh) endGlobalRefresh();
                return;
            }

            // If manual refresh, wait a bit for "feeling"
            const delay = isManualRefresh ? 800 : 0;

            setTimeout(() => {
                updateSlotCard("twoWheeler", data.data.TwoWheeler);
                updateSlotCard("fourWheeler", data.data.FourWheeler);
                updateCharts(data.data);

                var today = document.getElementById("revenue-today");
                var month = document.getElementById("revenue-month");

                if (today) {
                    today.innerText = "\u20B9 " + Number(data.data.RevenueToday || 0).toFixed(2);
                    if (isManualRefresh) pulseElement(today);
                }
                if (month) {
                    month.innerText = "\u20B9 " + Number(data.data.RevenueMonth || 0).toFixed(2);
                    if (isManualRefresh) pulseElement(month);
                }

                // Trigger fade-in animation
                var params = ['.financials-grid', '.dash-grid-2col'];
                params.forEach(function (sel) {
                    var el = document.querySelector(sel);
                    if (el) {
                        el.classList.remove('stats-loading');
                        el.classList.remove('stats-updated');
                        // Force reflow
                        void el.offsetWidth;
                        el.classList.add('stats-updated');
                    }
                });

                if (isManualRefresh) {
                    endGlobalRefresh();
                }
            }, delay);

        })
        .catch(function () {
            console.warn("Failed to load dashboard stats.");
            // Remove loading class on error too
            var params = ['.financials-grid', '.dash-grid-2col'];
            params.forEach(function (sel) {
                var el = document.querySelector(sel);
                if (el) el.classList.remove('stats-loading');
            });
            if (isManualRefresh) endGlobalRefresh();
        });
}

function startGlobalRefresh() {
    console.log("Global Refresh Start - Showing Overlay");
    const content = document.getElementById('dashboard-content');
    const overlay = document.getElementById('refresh-overlay');
    const refreshBtn = document.getElementById('btnRefreshStats');

    if (content) content.classList.add('refreshing');
    if (overlay) overlay.classList.add('visible');
    
    if (refreshBtn) {
        refreshBtn.disabled = true;
        refreshBtn.dataset.originalText = refreshBtn.innerText;
        refreshBtn.innerText = "Refreshing...";
    }
}

function endGlobalRefresh() {
    const content = document.getElementById('dashboard-content');
    const overlay = document.getElementById('refresh-overlay');
    const refreshBtn = document.getElementById('btnRefreshStats');

    if (overlay) {
        overlay.classList.remove('visible');
    }

    if (refreshBtn) {
        refreshBtn.disabled = false;
        refreshBtn.innerText = refreshBtn.dataset.originalText || "Refresh Stats";
        pulseElement(refreshBtn);
    }

    setTimeout(() => {
        if (content) {
            content.classList.remove('refreshing');
            content.classList.add('fade-in-smooth');
            setTimeout(() => content.classList.remove('fade-in-smooth'), 600);
        }
    }, 300);
}

function pulseElement(el) {
    el.classList.remove('stat-update-pulse');
    void el.offsetWidth; // force reflow
    el.classList.add('stat-update-pulse');
}

function refreshStats() {
    console.log("Manual Refresh Triggered");
    startGlobalRefresh();
    loadStats(true);
}

setInterval(updateTime, 1000);
updateTime();

document.addEventListener('DOMContentLoaded', function () {
    initCharts();
    loadStats();
    setInterval(loadStats, 10000); // refresh every 10 seconds
});


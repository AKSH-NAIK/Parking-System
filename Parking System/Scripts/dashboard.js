// dashboard.js - Client-side dashboard functionality
console.info("dashboard.js loaded");

// Logout function
function logout() {
    // Call logout API endpoint
    fetch('/API/logout.ashx', {
        method: 'POST'
    })
        .then(() => {
            // Redirect to login page
            window.location.href = 'Login.aspx';
        })
        .catch(err => {
            console.error('Logout error:', err);
            // Still redirect to login even if API call fails
            window.location.href = 'Login.aspx';
        });
}


// Navigation functions for entry pages
function goEntry2() {
    // Navigate to 2-wheeler entry page
    window.location.href = 'Entry2Wheeler.aspx';
}

function goEntry4() {
    // Navigate to 4-wheeler entry page
    window.location.href = 'Entry4Wheeler.aspx';
}

function goExit() {
    // Navigate to vehicle exit page
    alert('Vehicle Exit page - Coming soon!');
}

/* ===== NEW FUNCTIONALITY ===== */

// 1. Clock Functionality
function updateTime() {
    const now = new Date();
    const options = { weekday: 'short', year: 'numeric', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit' };
    const timeString = now.toLocaleDateString('en-US', options);

    const clockElement = document.getElementById('clock');
    if (clockElement) {
        clockElement.innerText = timeString;
    }
}

// Update time every second
setInterval(updateTime, 1000);
updateTime(); // Run immediately

// 2. Refresh Stats
function refreshStats() {
    // In a real app, this would fetch new data via AJAX.
    // For now, we reload the page to simulate a refresh.
    window.location.reload();
}

// 3. Search Vehicle
function searchVehicle() {
    // Navigate to search vehicle page
    window.location.href = 'searchvehicle.aspx';
}

// 4. Simulate Revenue Load (Visual Effect)
// Function to count up revenue
function animateRevenue() {
    const revenueElement = document.getElementById('revenue-today');
    if (!revenueElement) return;

    let current = 0;
    const target = 2500; // Example target for today
    const duration = 2000; // 2 seconds
    const stepTime = 50;
    const steps = duration / stepTime;
    const increment = target / steps;

    const timer = setInterval(() => {
        current += increment;
        if (current >= target) {
            current = target;
            clearInterval(timer);
        }
        revenueElement.innerText = "₹ " + Math.floor(current);
    }, stepTime);
}

// Start animation on load
document.addEventListener('DOMContentLoaded', animateRevenue);


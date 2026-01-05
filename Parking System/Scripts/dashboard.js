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

// Navigation functions for future pages
function goEntry() {
    // TODO: Navigate to vehicle entry page
    alert('Vehicle Entry page - Coming soon!');
}

function goExit() {
    // TODO: Navigate to vehicle exit page
    alert('Vehicle Exit page - Coming soon!');
}

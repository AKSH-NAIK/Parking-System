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
    // TODO: Navigate to vehicle exit page
    alert('Vehicle Exit page - Coming soon!');
}

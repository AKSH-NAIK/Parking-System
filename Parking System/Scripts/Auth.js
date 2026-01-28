// Auth.js - login wiring with robust API path and safe toast fallback
console.info("Auth.js loaded");

document.addEventListener("DOMContentLoaded", function () {

    const btn = document.getElementById("btnLogin");
    if (!btn) {
        console.warn("Auth.js: login button (#btnLogin) not found on the page.");
        return;
    }

    // Safe showToast fallback so missing toast implementation won't break login
    const _showToast = window.showToast || function (msg, type) {
        // simple non-blocking fallback
        console[type === "error" ? "warn" : "log"]("Toast:", msg);
    };

    // Password Visibility Toggle
    const togglePassword = document.getElementById("togglePassword");
    const passwordInput = document.getElementById("txtPassword");

    if (togglePassword && passwordInput) {
        togglePassword.addEventListener("click", function () {
            const type = passwordInput.getAttribute("type") === "password" ? "text" : "password";
            passwordInput.setAttribute("type", type);

            // Toggle icon
            this.innerHTML = type === "password"
                ? `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="width: 20px; height: 20px;"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>`
                : `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="width: 20px; height: 20px;"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line></svg>`;
        });
    }

    btn.addEventListener("click", function () {

        const staffId = (document.getElementById("txtStaffId") || {}).value.trim() || "";
        const password = (document.getElementById("txtPassword") || {}).value.trim() || "";

        if (!staffId || !password) {
            _showToast("Please enter Staff ID and Password", "error");
            return;
        }

        btn.disabled = true;

        // Use server-provided URL if available; otherwise a safe default. This avoids "~/" in client code.
        const apiUrl = window.__authApiUrl || "/API/auth.ashx";
        console.info("Auth.js: calling API at", apiUrl);

        // Build form body as URLSearchParams and let the browser set the Content-Type header.
        const payload = {
            staffId: staffId,
            passCode: password,   // handler expects passCode
            password: password    // harmless extra field
        };
        console.info("Auth.js: payload", payload);

        const body = new URLSearchParams(payload);
        console.log("Sending login request:", staffId, password);


        fetch(apiUrl, {
            method: "POST",
            body: body
        })
            .then(res => {
                btn.disabled = false;
                if (!res.ok) {
                    throw new Error("Network response was not ok: " + res.status);
                }
                return res.json();
            })
            .then(data => {
                if (data && data.success) {
                    const dashboardInput = document.getElementById("dashboardUrl");
                    const targetUrl = (dashboardInput && dashboardInput.value) ? dashboardInput.value : (window.__dashboardUrl || "Dashboard.aspx");
                    _showToast(data.message || "Login successful", "success");
                    console.log("Auth.js: Redirecting to", targetUrl);
                    setTimeout(() => window.location.href = targetUrl, 600);
                } else {
                    _showToast((data && data.message) || "Login failed", "error");
                }
            })
            .catch(err => {
                console.error("Auth.js fetch error:", err);
                btn.disabled = false;
                _showToast("Server error. Please try again.", "error");
            });

    });

});

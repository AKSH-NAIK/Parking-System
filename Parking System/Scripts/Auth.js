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
                _showToast(data.message || "Login successful", "success");
                setTimeout(() => window.location.href = "/Dashboard.aspx", 600);
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

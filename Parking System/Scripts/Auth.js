document.addEventListener("DOMContentLoaded", function () {

    const btnLogin = document.getElementById("btnLogin");
    const toastContainer = document.getElementById("toast-container");

    function showToast(message, type = "info", duration = 3500) {
        if (!toastContainer) return;

        const toast = document.createElement("div");
        toast.className = `toast toast--${type}`;
        toast.setAttribute("role", "status");
        toast.setAttribute("aria-live", "polite");
        toast.innerHTML = `<div class="toast__content">${message}</div>`;

        toastContainer.appendChild(toast);

        // Force reflow so animation runs
        // eslint-disable-next-line no-unused-expressions
        toast.offsetHeight;

        toast.classList.add("toast--visible");

        // Remove after duration
        const hideDelay = Math.max(800, duration - 300);
        setTimeout(() => toast.classList.remove("toast--visible"), hideDelay);

        // Remove from DOM after animation completes
        setTimeout(() => {
            if (toast.parentNode) toast.parentNode.removeChild(toast);
        }, duration + 200);
    }

    btnLogin.addEventListener("click", function () {

        const staffId = document.getElementById("txtStaffId").value.trim();
        const password = document.getElementById("txtPassword").value.trim();

        // Basic validation
        if (staffId === "" || password === "") {
            showToast("Please enter Staff ID and Password", "error");
            return;
        }

        // Disable button while request is in flight
        btnLogin.disabled = true;

        // Send login request to backend
        fetch("/Api/Auth.ashx", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                staffId: staffId,
                password: password
            })
        })
            .then(response => {
                btnLogin.disabled = false;
                return response.json();
            })
            .then(data => {

                if (data.success) {
                    // Login successful: show toast then redirect
                    showToast(data.message || "Login successful", "success", 900);
                    setTimeout(() => {
                        window.location.href = "/Pages/Dashboard.aspx";
                    }, 700);
                } else {
                    // Login failed
                    showToast(data.message || "Invalid credentials", "error");
                }

            })
            .catch(error => {
                console.error("Login error:", error);
                btnLogin.disabled = false;
                showToast("Something went wrong. Please try again.", "error");
            });

    });

});

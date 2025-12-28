document.addEventListener("DOMContentLoaded", function () {

    const btnLogin = document.getElementById("btnLogin");

    btnLogin.addEventListener("click", function () {

        const staffId = document.getElementById("txtStaffId").value.trim();
        const password = document.getElementById("txtPassword").value.trim();

        // Basic validation
        if (staffId === "" || password === "") {
            alert("Please enter Staff ID and Password");
            return;
        }

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
            .then(response => response.json())
            .then(data => {

                if (data.success) {
                    // Login successful
                    window.location.href = "/Pages/Dashboard.aspx";
                } else {
                    // Login failed
                    alert(data.message || "Invalid credentials");
                }

            })
            .catch(error => {
                console.error("Login error:", error);
                alert("Something went wrong. Please try again.");
            });

    });

});

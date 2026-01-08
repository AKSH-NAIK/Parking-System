<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Entry2Wheeler.aspx.cs"
    Inherits="Parking_System.UI.Entry2Wheeler" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>2-Wheeler Entry</title>
        <link rel="stylesheet" href="../Styles/site.css" type="text/css" />
    </head>

    <body>

        <div class="card">
            <h1>2-Wheeler Entry</h1>

            <label>Owner Name</label>
            <input type="text" id="ownerName" placeholder="John Doe" />

            <label>Phone Number</label>
            <input type="text" id="phoneNumber" placeholder="9876543210" />

            <label>Vehicle Number</label>
            <input type="text" id="vehicleNumber" placeholder="MH12AB1234" />

            <label>Entry Time</label>
            <div style="display: flex; align-items: center; margin-bottom: 1rem;">
                <input type="checkbox" id="useSystemTime" checked onchange="toggleTimeInput()"
                    style="width: auto; margin-right: 0.5rem; margin-bottom: 0;">
                <label for="useSystemTime" style="margin-bottom: 0; font-weight: normal;">Use System Time</label>
            </div>
            <input type="datetime-local" id="entryTime" disabled />

            <button onclick="submit2W()">Allocate Slot</button>

            <div id="result" class="message success"></div>

            <button class="back-button" onclick="window.location.href='Dashboard.aspx'">Back to Dashboard</button>
        </div>

        <script>
            function toggleTimeInput() {
                const useSystem = document.getElementById("useSystemTime").checked;
                const timeInput = document.getElementById("entryTime");

                timeInput.disabled = useSystem;

                if (useSystem) {
                    timeInput.value = ""; // Clear when disabled
                } else {
                    // Set current time as default when enabling
                    const now = new Date();
                    now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
                    timeInput.value = now.toISOString().slice(0, 16);
                }
            }

            function submit2W() {
                const name = document.getElementById("ownerName").value;
                const phone = document.getElementById("phoneNumber").value;
                const vehicle = document.getElementById("vehicleNumber").value;
                const useSystemTime = document.getElementById("useSystemTime").checked;
                let entryTime = "";

                if (name.trim() === "" || phone.trim() === "" || vehicle.trim() === "") {
                    document.getElementById("result").className = "message error";
                    document.getElementById("result").innerText = "Please fill in all details";
                    return;
                }

                if (!useSystemTime) {
                    entryTime = document.getElementById("entryTime").value;
                    if (entryTime === "") {
                        document.getElementById("result").className = "message error";
                        document.getElementById("result").innerText = "Please select entry time";
                        return;
                    }
                } else {
                    entryTime = new Date().toLocaleString();
                }

                document.getElementById("result").className = "message success";
                document.getElementById("result").innerText =
                    "2-Wheeler Slot A23 allocated successfully (Demo)";
            }
        </script>

    </body>

    </html>
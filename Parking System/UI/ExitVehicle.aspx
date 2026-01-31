    <%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExitVehicle.aspx.cs" Inherits="Parking_System.UI.ExitVehicle"
    %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Vehicle Exit</title>
        <link rel="stylesheet" href="../Styles/site.css" type="text/css" />
    </head>

    <body>

        <div class="card">
            <h1>🚗 Vehicle Exit</h1>

            <!-- STEP 1: Vehicle Number Input -->
            <div id="step1">
                <p class="subtitle">Enter vehicle number to fetch parking details</p>

                <label>Vehicle Number</label>
                <input type="text" id="vehicleNumber" placeholder="MH12AB1234" />

                <button onclick="fetchVehicleData()">Fetch Details</button>

                <div id="fetchResult"></div>

                <button class="back-button" onclick="window.location.href='Dashboard.aspx'">Back to Dashboard</button>
            </div>

            <!-- STEP 2: Vehicle Details & Exit Time -->
            <div id="step2" style="display: none;">
                <p class="subtitle">Confirm vehicle details and set exit time</p>

                <label>Owner Name</label>
                <input type="text" id="ownerName" disabled />

                <label>Phone Number</label>
                <input type="text" id="phoneNumber" disabled />

                <label>Vehicle Number</label>
                <input type="text" id="vehicleNumberDisplay" disabled />

                <label>Vehicle Type</label>
                <input type="text" id="vehicleType" disabled />

                <label>Entry Time</label>
                <input type="text" id="entryTime" disabled />

                <label>Slot Number</label>
                <input type="text" id="slotNumber" disabled />

                <label>Exit Time</label>
                <div class="checkbox-row">
                    <input type="checkbox" id="useSystemTime" checked onchange="toggleTimeInput()">
                    <label for="useSystemTime">Use System Time</label>
                </div>
                <input type="datetime-local" id="exitTime" disabled />

                <button onclick="processExit()">Process Exit</button>

                <div id="exitResult"></div>

                <button class="back-button" onclick="resetForm()">Search Another Vehicle</button>
            </div>
        </div>

        <script>
            // Toggle exit time input based on system time checkbox
            function toggleTimeInput() {
                const useSystem = document.getElementById("useSystemTime").checked;
                const timeInput = document.getElementById("exitTime");

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

            // Fetch vehicle data from database (simulated)
            function fetchVehicleData() {
                const vehicleNo = document.getElementById("vehicleNumber").value.trim();

                if (vehicleNo === "") {
                    document.getElementById("fetchResult").className = "message error";
                    document.getElementById("fetchResult").innerText = "Please enter a vehicle number";
                    return;
                }

                // TODO: Replace with actual API call to fetch data from database
                // Simulated database fetch
                setTimeout(() => {
                    // Simulate vehicle found (replace with actual DB query)
                    const vehicleData = {
                        ownerName: "John Doe",
                        phoneNumber: "9876543210",
                        vehicleNumber: vehicleNo.toUpperCase(),
                        vehicleType: "2-Wheeler",
                        entryTime: "2026-01-26 14:30:00",
                        slotNumber: "A23"
                    };

                    // Check if vehicle exists (in real implementation, check DB response)
                    if (vehicleData) {
                        // Populate step 2 fields
                        document.getElementById("ownerName").value = vehicleData.ownerName;
                        document.getElementById("phoneNumber").value = vehicleData.phoneNumber;
                        document.getElementById("vehicleNumberDisplay").value = vehicleData.vehicleNumber;
                        document.getElementById("vehicleType").value = vehicleData.vehicleType;
                        document.getElementById("entryTime").value = vehicleData.entryTime;
                        document.getElementById("slotNumber").value = vehicleData.slotNumber;

                        // Hide step 1, show step 2
                        document.getElementById("step1").style.display = "none";
                        document.getElementById("step2").style.display = "block";
                    } else {
                        document.getElementById("fetchResult").className = "message error";
                        document.getElementById("fetchResult").innerText = "Vehicle not found in parking records";
                    }
                }, 500); // Simulate network delay
            }

            // Process vehicle exit
            function processExit() {
                const useSystemTime = document.getElementById("useSystemTime").checked;
                let exitTime = "";

                if (!useSystemTime) {
                    exitTime = document.getElementById("exitTime").value;
                    if (exitTime === "") {
                        document.getElementById("exitResult").className = "message error";
                        document.getElementById("exitResult").innerText = "Please select exit time";
                        return;
                    }
                } else {
                    exitTime = new Date().toLocaleString();
                }

                // TODO: Replace with actual API call to update database and calculate charges
                const vehicleNo = document.getElementById("vehicleNumberDisplay").value;
                const slotNo = document.getElementById("slotNumber").value;

                document.getElementById("exitResult").className = "message success";
                document.getElementById("exitResult").innerText =
                    `Vehicle ${vehicleNo} exited successfully!\nSlot ${slotNo} is now available.\nExit Time: ${exitTime}\n(Demo - Charges calculation pending)`;
            }

            // Reset form to step 1
            function resetForm() {
                document.getElementById("step1").style.display = "block";
                document.getElementById("step2").style.display = "none";
                document.getElementById("vehicleNumber").value = "";
                document.getElementById("fetchResult").innerText = "";
                document.getElementById("exitResult").innerText = "";
                document.getElementById("useSystemTime").checked = true;
                toggleTimeInput();
            }
        </script>

    </body>

    </html>
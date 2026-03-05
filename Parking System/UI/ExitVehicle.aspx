<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExitVehicle.aspx.cs" Inherits="Parking_System.UI.ExitVehicle"
    %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Vehicle Exit</title>
        <link rel="stylesheet" href="../Styles/site.css?v=4" type="text/css" />
    </head>

    <body>

        <div class="card">
            <h1> Vehicle Exit</h1>

            <div id="step1">
                <p class="subtitle">Enter vehicle number to fetch parking details</p>

                <label>Vehicle Number</label>
                <input type="text" id="vehicleNumber" placeholder="MH12AB1234" style="text-transform: uppercase;" />

                <button onclick="fetchVehicleData()" class="primary">Fetch Details</button>

                <div id="fetchResult"></div>

                <button class="back-button" onclick="window.location.href='Dashboard.aspx'">Back to Dashboard</button>
            </div>

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

                <button onclick="processExit()" class="primary">Process Exit</button>
                <button id="printReceiptBtn" onclick="window.print()" class="btn"
                    style="display: none; margin-top: 0.5rem; background: var(--success); color: #fff; border-color: var(--success);">
                    <i class="fas fa-print" style="margin-right: 0.5rem;"></i>Print Receipt
                </button>

                <div id="exitResult"></div>

                <div id="qrSection"
                    style="display: none; margin-top: 1rem; flex-direction: column; align-items: center; text-align: center;">
                    <p class="subtitle">Pay using UPI</p>
                    <img id="upiQr" alt="UPI QR Code"
                        style="width: 200px; height: 200px; border-radius: 12px; border: 1px solid #e2e8f0; margin: 0 auto;" />
                    <p id="amountText" style="margin-top: 0.75rem; font-weight: 600;"></p>
                </div>

                <button class="back-button" onclick="window.location.href='Dashboard.aspx'">Back To Dashboard</button>
            </div>

            <!-- Print Template -->
            <div id="printTemplate" style="display: none;">
                <h2 style="text-align: center; border-bottom: 2px dashed #000; padding-bottom: 5mm;">EXIT BILL</h2>
                <div style="margin: 5mm 0;">
                    <p><strong>Vehicle:</strong> <span id="p_vehicleNumber"></span></p>
                    <p><strong>Owner:</strong> <span id="p_ownerName"></span></p>
                    <p><strong>Phone:</strong> <span id="p_phoneNumber"></span></p>
                    <p><strong>Slot:</strong> <span id="p_slotNumber"></span></p>
                    <hr style="border: 0; border-top: 1px dashed #000; margin: 3mm 0;">
                    <p><strong>Entry:</strong> <span id="p_entryTime"></span></p>
                    <p><strong>Exit:</strong> <span id="p_exitTime"></span></p>
                    <hr style="border: 0; border-top: 1px dashed #000; margin: 3mm 0;">
                    <p style="font-size: 1.2rem; font-weight: 800;"><strong>Total Amount:</strong> &#8377; <span
                            id="p_amount"></span></p>
                </div>
                <div style="border-top: 1px solid #000; padding-top: 3mm; font-size: 0.8rem; text-align: center;">
                    <p>Thank you for parking with us!</p>
                </div>
            </div>
        </div>

        <script>
            function formatDateTime(date) {
                if (!date) return "";
                const d = new Date(date);
                const year = d.getFullYear();
                const month = String(d.getMonth() + 1).padStart(2, '0');
                const day = String(d.getDate()).padStart(2, '0');
                const hours = String(d.getHours()).padStart(2, '0');
                const minutes = String(d.getMinutes()).padStart(2, '0');
                const seconds = String(d.getSeconds()).padStart(2, '0');
                return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
            }

            function toggleTimeInput() {
                const useSystem = document.getElementById("useSystemTime").checked;
                const timeInput = document.getElementById("exitTime");

                timeInput.disabled = useSystem;

                if (useSystem) {
                    timeInput.value = "";
                } else {
                    const now = new Date();
                    now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
                    timeInput.value = now.toISOString().slice(0, 16);
                }
            }

            function fetchVehicleData() {
                const vehicleNo = document.getElementById("vehicleNumber").value.trim().toUpperCase();

                if (vehicleNo === "") {
                    document.getElementById("fetchResult").className = "message error";
                    document.getElementById("fetchResult").innerText = "Please enter a vehicle number";
                    return;
                }

                const formData = new URLSearchParams();
                formData.append("action", "fetch");
                formData.append("vehicleNumber", vehicleNo);

                fetch("../API/vehicleExit.ashx", {
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded" },
                    body: formData
                })
                    .then(function (res) { return res.json(); })
                    .then(function (data) {
                        if (!data.success) {
                            document.getElementById("fetchResult").className = "message error";
                            document.getElementById("fetchResult").innerText = data.message || "Vehicle not found";
                            return;
                        }

                        const v = data.data;
                        document.getElementById("ownerName").value = v.ownerName;
                        document.getElementById("phoneNumber").value = v.phoneNumber;
                        document.getElementById("vehicleNumberDisplay").value = v.vehicleNumber;
                        document.getElementById("vehicleType").value = v.vehicleType;
                        document.getElementById("entryTime").value = v.entryTime;
                        document.getElementById("slotNumber").value = v.slotNumber;

                        document.getElementById("step1").style.display = "none";
                        document.getElementById("step2").style.display = "block";
                        document.getElementById("fetchResult").innerText = "";
                    })
                    .catch(function () {
                        document.getElementById("fetchResult").className = "message error";
                        document.getElementById("fetchResult").innerText = "Network error. Please try again.";
                    });
            }

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
                }

                const vehicleNo = document.getElementById("vehicleNumberDisplay").value;

                const formData = new URLSearchParams();
                formData.append("action", "exit");
                formData.append("vehicleNumber", vehicleNo);
                formData.append("exitTime", exitTime);

                fetch("../API/vehicleExit.ashx", {
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded" },
                    body: formData
                })
                    .then(function (res) { return res.json(); })
                    .then(function (data) {
                        if (!data.success) {
                            document.getElementById("exitResult").className = "message error";
                            document.getElementById("exitResult").innerText = data.message || "Exit failed";
                            return;
                        }

                        const result = data.data;
                        document.getElementById("exitResult").className = "message success";
                        document.getElementById("exitResult").innerText =
                            "Vehicle " + result.vehicleNumber + " exited successfully. Slot " + result.slotNumber + " is now available.";

                        const qrUrl = "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=" + encodeURIComponent(result.upiUri);
                        document.getElementById("upiQr").src = qrUrl;
                        document.getElementById("amountText").innerText = "Amount: " + Number(result.amount).toFixed(2);
                        document.getElementById("qrSection").style.display = "block";

                        // Setup Print Template
                        document.getElementById("p_vehicleNumber").innerText = result.vehicleNumber;
                        document.getElementById("p_ownerName").innerText = document.getElementById("ownerName").value;
                        document.getElementById("p_phoneNumber").innerText = document.getElementById("phoneNumber").value;
                        document.getElementById("p_slotNumber").innerText = result.slotNumber;
                        document.getElementById("p_entryTime").innerText = formatDateTime(document.getElementById("entryTime").value);
                        document.getElementById("p_exitTime").innerText = formatDateTime(useSystemTime ? new Date() : exitTime);
                        document.getElementById("p_amount").innerText = Number(result.amount).toFixed(2);

                        document.getElementById("printReceiptBtn").style.display = 'inline-flex';
                        document.getElementById("qrSection").style.setProperty('display', 'flex', 'important');
                        if (typeof Toast !== 'undefined') Toast.success("Vehicle exit processed!");
                    })
                    .catch(function () {
                        document.getElementById("exitResult").className = "message error";
                        document.getElementById("exitResult").innerText = "Network error. Please try again.";
                    });
            }

        </script>

    </body>

    </html>
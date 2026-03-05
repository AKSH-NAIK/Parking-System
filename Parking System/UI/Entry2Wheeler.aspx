<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Entry2Wheeler.aspx.cs"
    Inherits="Parking_System.UI.Entry2Wheeler" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>2-Wheeler Entry</title>
        <link rel="stylesheet" href="../Styles/site.css?v=4" type="text/css" />
    </head>

    <body>

        <div class="card">
            <h1>2-Wheeler Entry</h1>

            <label>Owner Name</label>
            <input type="text" id="ownerName" placeholder="John Doe" />

            <label>Phone Number</label>
            <input type="text" id="phoneNumber" placeholder="9876543210" maxlength="10" />

            <label>Vehicle Number</label>
            <input type="text" id="vehicleNumber" placeholder="MH12AB1234" style="text-transform: uppercase;" />

            <label>Entry Time</label>
            <div class="checkbox-row">
                <input type="checkbox" id="useSystemTime" checked onchange="VehicleEntry.toggleTimeInput()">
                <label for="useSystemTime">Use System Time</label>
            </div>
            <input type="datetime-local" id="entryTime" disabled />

            <button onclick="VehicleEntry.submitEntry()" class="primary">Allocate Slot</button>
            <button id="printReceiptBtn" onclick="VehicleEntry.printReceipt()" class="btn"
                style="display: none; margin-top: 0.5rem; background: var(--success); color: #fff; border-color: var(--success);">
                <i class="fas fa-print" style="margin-right: 0.5rem;"></i>Print Receipt
            </button>

            <div id="result" class="message success"></div>

            <!-- Print Template -->
            <div id="printTemplate" style="display: none;">
                <h2 style="text-align: center; border-bottom: 2px dashed #000; padding-bottom: 5mm;">PARKING RECEIPT
                </h2>
                <div style="margin: 5mm 0;">
                    <p><strong>Vehicle:</strong> <span id="p_vehicleNumber"></span></p>
                    <p><strong>Type:</strong> <span id="p_vehicleType"></span></p>
                    <p><strong>Owner:</strong> <span id="p_ownerName"></span></p>
                    <p><strong>Phone:</strong> <span id="p_phoneNumber"></span></p>
                    <p><strong>Slot:</strong> <span id="p_slotNumber"
                            style="font-size: 1.5rem; font-weight: 800;"></span></p>
                </div>
                <div style="border-top: 1px solid #000; padding-top: 3mm; font-size: 0.8rem;">
                    <p><strong>Entry Time:</strong> <span id="p_entryTime"></span></p>
                    <p style="margin-top: 5mm; text-align: center;">--- Keep this slip safe ---</p>
                </div>
            </div>

            <button class="back-button" onclick="window.location.href='Dashboard.aspx'">Back to Dashboard</button>
        </div>

        <script src="../Scripts/vehicleEntry.js"></script>
        <script>
            window.addEventListener('DOMContentLoaded', function () {
                VehicleEntry.init('2-Wheeler');
            });
        </script>

    </body>

    </html>
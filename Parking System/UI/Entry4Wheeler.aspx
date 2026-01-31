<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Entry4Wheeler.aspx.cs"
    Inherits="Parking_System.UI.Entry4Wheeler" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>4-Wheeler Entry</title>
        <link rel="stylesheet" href="../Styles/site.css" type="text/css" />
    </head>

    <body>

        <div class="card">
            <h1>4-Wheeler Entry</h1>

            <label>Owner Name</label>
            <input type="text" id="ownerName" placeholder="Jane Doe" />

            <label>Phone Number</label>
            <input type="text" id="phoneNumber" placeholder="9876543210" maxlength="10" />

            <label>Vehicle Number</label>
            <input type="text" id="vehicleNumber" placeholder="MH14XY5678" style="text-transform: uppercase;" />

            <label>Entry Time</label>
            <div class="checkbox-row">
                <input type="checkbox" id="useSystemTime" checked onchange="VehicleEntry.toggleTimeInput()">
                <label for="useSystemTime">Use System Time</label>
            </div>
            <input type="datetime-local" id="entryTime" disabled />

            <button onclick="VehicleEntry.submitEntry()">Allocate Slot</button>

            <div id="result" class="message success"></div>

            <button class="back-button" onclick="window.location.href='Dashboard.aspx'">Back to Dashboard</button>
        </div>

        <script src="../Scripts/vehicleEntry.js"></script>
        <script>
            window.addEventListener('DOMContentLoaded', function() {
                VehicleEntry.init('4-Wheeler');
            });
        </script>

    </body>

    </html>
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Entry4Wheeler.aspx.cs"
    Inherits="Parking_System.UI.Entry4Wheeler" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>4-Wheeler Entry</title>
        <link rel="stylesheet" href="../Styles/site.css" type="text/css" />
    </head>

    <body>

        <div class="card">
            <h1>4-Wheeler Entry</h1>

            <label>Vehicle Number</label>
            <input type="text" id="vehicleNumber" placeholder="MH14XY5678" />

            <button onclick="submit4W()">Allocate Slot</button>

            <div id="result" class="message success"></div>

            <button class="back-button" onclick="window.location.href='Dashboard.aspx'">Back to Dashboard</button>
        </div>

        <script>
            function submit4W() {
                const vehicle = document.getElementById("vehicleNumber").value;

                if (vehicle.trim() === "") {
                    document.getElementById("result").className = "message error";
                    document.getElementById("result").innerText = "Please enter vehicle number";
                    return;
                }

                document.getElementById("result").className = "message success";
                document.getElementById("result").innerText =
                    "4-Wheeler Slot B08 allocated successfully (Demo)";
            }
        </script>

    </body>

    </html>
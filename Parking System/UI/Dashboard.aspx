<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="ParkingSystem.Dashboard" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Dashboard</title>
        <link rel="stylesheet" href="../Styles/site.css?v=3" type="text/css" />
    </head>

    <body>

        <div class="card wide">
            <h1>Parking Management Dashboard</h1>
            <button onclick="logout()">LogOut</button>

            <!-- ===== 2-WHEELER SECTION ===== -->
            <h2>2-Wheeler Parking</h2>

            <div class="stats">
                <div class="stat-box">
                    <p>Total Slots</p>
                    <h2>100</h2>
                </div>

                <div class="stat-box occupied">
                    <p>Occupied</p>
                    <h2>40</h2>
                </div>

                <div class="stat-box free">
                    <p>Available</p>
                    <h2>60</h2>
                </div>
            </div>

            <!-- ===== 4-WHEELER SECTION ===== -->
            <h2>4-Wheeler Parking</h2>

            <div class="stats">
                <div class="stat-box">
                    <p>Total Slots</p>
                    <h2>50</h2>
                </div>

                <div class="stat-box occupied">
                    <p>Occupied</p>
                    <h2>18</h2>
                </div>

                <div class="stat-box free">
                    <p>Available</p>
                    <h2>32</h2>
                </div>
            </div>

            <!-- ===== ACTION BUTTONS ===== -->
            <div class="actions">
                <button onclick="goEntry2()">2-Wheeler Entry</button>
                <button onclick="goEntry4()">4-Wheeler Entry</button>
                <button onclick="goExit()">Vehicle Exit</button>
            </div>
        </div>


        <script src="../Scripts/dashboard.js"></script>
    </body>

    </html>
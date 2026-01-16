<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="ParkingSystem.Dashboard" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Dashboard</title>
        <link rel="stylesheet" href="../Styles/site.css?v=3" type="text/css" />
    </head>

    <body>

        <div class="card wide">
            <!-- ===== HEADER & CLOCK & LOGOUT ===== -->
            <div class="dash-header">
                <h1 style="font-size: 1.5rem; margin: 0;">Dashboard</h1>
                <div style="display: flex; gap: 10px; align-items: center;">
                    <div id="clock" style="font-weight: 600; font-size: 1rem;"></div>
                    <button onclick="logout()"
                        style="padding: 0.5rem 1rem; min-width: auto; font-size: 0.9rem; margin: 0; position: static; box-shadow: none;">LogOut</button>
                </div>
            </div>

            <!-- ===== REVENUE SECTION ===== -->
            <h2 style="margin: 1rem 0 0.5rem; font-size: 1.1rem;">Financials</h2>
            <div class="stats" style="margin: 0.5rem 0 1.5rem; gap: 1rem;">
                <div class="stat-box" style="padding: 1rem; border-radius: 1rem;">
                    <p style="margin-bottom: 0.25rem;">Today's Revenue</p>
                    <h2 id="revenue-today" style="font-size: 1.8rem;">₹ 0</h2>
                </div>
                <div class="stat-box" style="padding: 1rem; border-radius: 1rem;">
                    <p style="margin-bottom: 0.25rem;">Monthly Revenue</p>
                    <h2 style="font-size: 1.8rem;">₹ 12,500</h2>
                </div>
            </div>

            <!-- ===== PARKING SECTIONS (Two Columns) ===== -->
            <!-- ===== PARKING SECTIONS (Two Columns) ===== -->
            <div class="dash-grid-2col">
                <!-- 2-WHEELER CARD -->
                <div class="parking-card">
                    <div class="pc-header">
                        <div>
                            <h3 class="pc-title">2-Wheeler Parking</h3>

                        </div>
                        <div style="text-align: right;">
                            <a href="Entry2Wheeler.aspx" class="pc-link">Book Slot</a>

                        </div>
                    </div>

                    <div class="pc-body">

                        <div class="pc-text-row">
                            <span class="text-occupied-label">Occupied 40%</span>
                            <span class="text-available-label">Available 60%</span>
                        </div>
                        <div class="pc-progress-track">
                            <div class="pc-progress-fill fill-occupied" style="width: 40%;"></div>
                            <div class="pc-progress-fill fill-available" style="width: 60%;"></div>
                        </div>
                    </div>

                    <div class="pc-footer">
                        <div class="pc-stat-item">
                            <span class="pc-dot dot-total"></span>
                            <span class="pc-label">Total</span>
                            <span class="pc-value">100</span>
                        </div>
                        <div class="pc-stat-item">
                            <span class="pc-dot dot-occupied"></span>
                            <span class="pc-label">Occupied</span>
                            <span class="pc-value">40</span>
                        </div>
                        <div class="pc-stat-item">
                            <span class="pc-dot dot-available"></span>
                            <span class="pc-label">Available</span>
                            <span class="pc-value">60</span>
                        </div>
                    </div>
                </div>

                <!-- 4-WHEELER CARD -->
                <div class="parking-card">
                    <div class="pc-header">
                        <div>
                            <h3 class="pc-title">4-Wheeler Parking</h3>
                            <!-- Removed Zone -->
                        </div>
                        <div style="text-align: right;">
                            <a href="Entry4Wheeler.aspx" class="pc-link">Book Slot</a>
                            <!-- Removed Manager -->
                        </div>
                    </div>

                    <div class="pc-body">
                        <!-- Labels above the bar -->
                        <div class="pc-text-row">
                            <span class="text-occupied-label">Occupied 36%</span>
                            <span class="text-available-label">Available 64%</span>
                        </div>
                        <div class="pc-progress-track">
                            <div class="pc-progress-fill fill-occupied" style="width: 36%;"></div>
                            <div class="pc-progress-fill fill-available" style="width: 64%;"></div>
                        </div>
                    </div>

                    <div class="pc-footer">
                        <div class="pc-stat-item">
                            <span class="pc-dot dot-total"></span>
                            <span class="pc-label">Total</span>
                            <span class="pc-value">50</span>
                        </div>
                        <div class="pc-stat-item">
                            <span class="pc-dot dot-occupied"></span>
                            <span class="pc-label">Occupied</span>
                            <span class="pc-value">18</span>
                        </div>
                        <div class="pc-stat-item">
                            <span class="pc-dot dot-available"></span>
                            <span class="pc-label">Available</span>
                            <span class="pc-value">32</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ===== ACTION BUTTONS ===== -->
            <div class="actions actions-grid">
                <button onclick="goEntry2()">2-Wheeler Entry</button>
                <button onclick="goEntry4()">4-Wheeler Entry</button>
                <button onclick="searchVehicle()">Search Vehicle</button>
                <button onclick="refreshStats()">Refresh Stats</button>
                <button onclick="goExit()">Vehicle Exit</button>
            </div>
        </div>


        <script src="../Scripts/dashboard.js"></script>
    </body>

    </html>
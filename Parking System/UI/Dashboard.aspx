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
                <!-- 2-WHEELER -->
                <div>
                    <h2 style="margin: 0 0 0.5rem; font-size: 1.1rem;">2-Wheeler</h2>
                    <div class="stats" style="grid-template-columns: 1fr; gap: 0.5rem; margin: 0;">
                        <div class="stat-box" style="padding: 0.75rem; border-radius: 0.75rem;">
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <p style="margin: 0;">Total Slots</p>
                                <h2 style="font-size: 1.5rem; margin: 0;">100</h2>
                            </div>
                        </div>
                        <div class="stat-box occupied" style="padding: 0.75rem; border-radius: 0.75rem;">
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <p style="margin: 0;">Occupied</p>
                                <h2 style="font-size: 1.5rem; margin: 0;">40 <span
                                        style="font-size: 0.6em;">(40%)</span></h2>
                            </div>
                        </div>
                        <div class="stat-box free" style="padding: 0.75rem; border-radius: 0.75rem;">
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <p style="margin: 0;">Available</p>
                                <h2 style="font-size: 1.5rem; margin: 0;">60 <span
                                        style="font-size: 0.6em;">(60%)</span></h2>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 4-WHEELER -->
                <div>
                    <h2 style="margin: 0 0 0.5rem; font-size: 1.1rem;">4-Wheeler</h2>
                    <div class="stats" style="grid-template-columns: 1fr; gap: 0.5rem; margin: 0;">
                        <div class="stat-box" style="padding: 0.75rem; border-radius: 0.75rem;">
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <p style="margin: 0;">Total Slots</p>
                                <h2 style="font-size: 1.5rem; margin: 0;">50</h2>
                            </div>
                        </div>
                        <div class="stat-box occupied" style="padding: 0.75rem; border-radius: 0.75rem;">
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <p style="margin: 0;">Occupied</p>
                                <h2 style="font-size: 1.5rem; margin: 0;">18 <span
                                        style="font-size: 0.6em;">(36%)</span></h2>
                            </div>
                        </div>
                        <div class="stat-box free" style="padding: 0.75rem; border-radius: 0.75rem;">
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <p style="margin: 0;">Available</p>
                                <h2 style="font-size: 1.5rem; margin: 0;">32 <span
                                        style="font-size: 0.6em;">(64%)</span></h2>
                            </div>
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
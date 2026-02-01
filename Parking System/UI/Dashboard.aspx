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
        <div class="dash-header">
            <h1 style="font-size: 1.5rem; margin: 0;">Dashboard</h1>
            <div style="display: flex; gap: 10px; align-items: center;">
                <div id="clock" style="font-weight: 600; font-size: 1rem;"></div>
                <button onclick="logout()"
                    style="padding: 0.5rem 1rem; min-width: auto; font-size: 0.9rem; margin: 0; position: static; box-shadow: none;">LogOut</button>
            </div>
        </div>

        <h2 class="section-title">Financials</h2>
        <div class="financials-grid">
            <div class="finance-card">
                <p class="fc-label">Today's Revenue</p>
                <h2 id="revenue-today" class="fc-value">₹ 0</h2>
            </div>
            <div class="finance-card">
                <p class="fc-label">Monthly Revenue</p>
                <h2 class="fc-value">₹ 12,500</h2>
            </div>
        </div>

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
                        <span id="twoWheelerOccupiedPercent" class="text-occupied-label">Occupied 0%</span>
                        <span id="twoWheelerAvailablePercent" class="text-available-label">Available 0%</span>
                    </div>
                    <div class="pc-progress-track">
                        <div id="twoWheelerOccupiedBar" class="pc-progress-fill fill-occupied" style="width: 0%;"></div>
                        <div id="twoWheelerAvailableBar" class="pc-progress-fill fill-available" style="width: 0%;"></div>
                    </div>
                </div>

                <div class="pc-footer">
                    <div class="pc-stat-item">
                        <span class="pc-dot dot-total"></span>
                        <span class="pc-label">Total</span>
                        <span id="twoWheelerTotal" class="pc-value">0</span>
                    </div>
                    <div class="pc-stat-item">
                        <span class="pc-dot dot-occupied"></span>
                        <span class="pc-label">Occupied</span>
                        <span id="twoWheelerOccupied" class="pc-value">0</span>
                    </div>
                    <div class="pc-stat-item">
                        <span class="pc-dot dot-available"></span>
                        <span class="pc-label">Available</span>
                        <span id="twoWheelerAvailable" class="pc-value">0</span>
                    </div>
                </div>
            </div>

            <!-- 4-WHEELER CARD -->
            <div class="parking-card">
                <div class="pc-header">
                    <div>
                        <h3 class="pc-title">4-Wheeler Parking</h3>
                    </div>
                    <div style="text-align: right;">
                        <a href="Entry4Wheeler.aspx" class="pc-link">Book Slot</a>
                    </div>
                </div>

                <div class="pc-body">
                    <div class="pc-text-row">
                        <span id="fourWheelerOccupiedPercent" class="text-occupied-label">Occupied 0%</span>
                        <span id="fourWheelerAvailablePercent" class="text-available-label">Available 0%</span>
                    </div>
                    <div class="pc-progress-track">
                        <div id="fourWheelerOccupiedBar" class="pc-progress-fill fill-occupied" style="width: 0%;"></div>
                        <div id="fourWheelerAvailableBar" class="pc-progress-fill fill-available" style="width: 0%;"></div>
                    </div>
                </div>

                <div class="pc-footer">
                    <div class="pc-stat-item">
                        <span class="pc-dot dot-total"></span>
                        <span class="pc-label">Total</span>
                        <span id="fourWheelerTotal" class="pc-value">0</span>
                    </div>
                    <div class="pc-stat-item">
                        <span class="pc-dot dot-occupied"></span>
                        <span class="pc-label">Occupied</span>
                        <span id="fourWheelerOccupied" class="pc-value">0</span>
                    </div>
                    <div class="pc-stat-item">
                        <span class="pc-dot dot-available"></span>
                        <span class="pc-label">Available</span>
                        <span id="fourWheelerAvailable" class="pc-value">0</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="actions-grid">
            <button onclick="searchVehicle()">Search Vehicle</button>
            <button onclick="refreshStats()">Refresh Stats</button>
            <button onclick="goExit()">Vehicle Exit</button>
        </div>
    </div>

    <script src="../Scripts/dashboard.js?v=<%= DateTime.Now.Ticks %>"></script>
</body>

</html>
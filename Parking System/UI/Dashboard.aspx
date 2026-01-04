<%@ Page Language="C#" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Dashboard</title>
        <link rel="stylesheet" href="../Styles/site.css?v=2" type="text/css" />
    </head>

    <body>

        <div class="card wide">
            <h1>Parking Management Dashboard</h1>

            <div class="stats">
                <div class="stat-box">
                    <p>Total Slots</p>
                    <h2>20</h2>
                </div>

                <div class="stat-box occupied">
                    <p>Occupied</p>
                    <h2>8</h2>
                </div>

                <div class="stat-box free">
                    <p>Available</p>
                    <h2>12</h2>
                </div>
            </div>

            <div class="actions">
                <button onclick="goEntry()">Vehicle Entry</button>
                <button onclick="goExit()">Vehicle Exit</button>
                <button class="secondary" onclick="logout()">Logout</button>
            </div>
        </div>

        <script src="../Scripts/dashboard.js"></script>
    </body>

    </html>
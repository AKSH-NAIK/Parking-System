<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SearchVehicle.aspx.cs"
    Inherits="Parking_System.UI.SearchVehicle" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Search Vehicle</title>
        <link rel="stylesheet" href="../Styles/site.css" type="text/css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    </head>

    <body>

        <div class="card wide">
            <h1>🔍 Search Vehicle</h1>
            <p class="subtitle">Search for any parked vehicle by vehicle number</p>

            <!-- Search Bar -->
            <div style="display: flex; gap: 0.75rem; margin: 2rem 0;">
                <input type="text" id="searchInput" placeholder="Enter vehicle number (e.g., MH12AB1234)"
                    autocomplete="off" style="flex: 1; margin-bottom: 0;" />
                <button onclick="performSearch()" style="width: auto; min-width: 120px; margin: 0;">
                    <i class="fas fa-search" style="margin-right: 0.5rem;"></i>Search
                </button>
            </div>

            <!-- Search Results -->
            <div id="searchResults" style="min-height: 200px; margin: 2rem 0; text-align: center;">
                <div style="padding: 3rem 1rem; color: var(--text-muted);">
                    <i class="fas fa-car"
                        style="font-size: 3rem; color: var(--text-muted); margin-bottom: 1rem; display: block;"></i>
                    <p>Enter a vehicle number to search</p>
                </div>
            </div>

            <div style="text-align: center; margin-top: 2rem;">
                <button class="back-button" onclick="window.location.href='Dashboard.aspx'"
                    style="width: auto; max-width: 300px; padding: 0.75rem 2rem;">Back to Dashboard</button>
            </div>
        </div>

        <script src="../Scripts/search.js"></script>

    </body>

    </html>
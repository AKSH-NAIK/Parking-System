<!-- Staff Login Page for Parking System Application -->
<%@ Page Language="C#" AutoEventWireup="false" %>

    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Staff Login - Parking Management System</title>

        <link rel="stylesheet" href="../Styles/site.css?v=3" type="text/css" />
    </head>

    <body>

        <div class="card" role="main" aria-labelledby="loginHeading">
            <h1 id="loginHeading">Parking Management System</h1>
            <p class="subtitle">Staff Login Portal</p>

            <div class="login-box">
                <label for="txtStaffId">Staff ID</label>
                <input type="text" id="txtStaffId" name="txtStaffId" placeholder="Enter your staff ID" />

                <label for="txtPassword">Password</label>
                <div class="password-group">
                    <input type="password" id="txtPassword" name="txtPassword" placeholder="Enter your password" />
                    <button type="button" id="togglePassword" aria-label="Toggle password visibility">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                            stroke-linecap="round" stroke-linejoin="round" style="width: 20px; height: 20px;">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                            <circle cx="12" cy="12" r="3"></circle>
                        </svg>
                    </button>
                </div>

                <button type="button" id="btnLogin">Login</button>
            </div>

            <div class="demo-credentials" aria-hidden="true">
                <p class="demo-title">Demo Credentials:</p>
                <p class="demo-line"><strong>Staff ID:</strong> STF001 <strong>Password:</strong> admin123</p>
                <p class="demo-line"><strong>Staff ID:</strong> STF002 <strong>Password:</strong> staff123</p>
            </div>

            <input type="hidden" id="dashboardUrl" value='<%= ResolveUrl("~/UI/Dashboard.aspx") %>' />
        </div>

        <div id="toast-container" aria-live="polite" aria-atomic="true"></div>

        <script src='<%= ResolveUrl("~/Scripts/Auth.js") %>?v=<%= DateTime.Now.Ticks %>'></script>

    </body>

    </html>
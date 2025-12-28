<!-- Staff Login Page for Parking System Application -->
<%@ Page Language="C#" AutoEventWireup="false" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Staff Login</title>

    
    <link rel="stylesheet" href="<%= ResolveUrl("~/Styles/site.css") %>" />
</head>
<body>

    <div class="login-box" role="main" aria-labelledby="loginHeading">
        <h2 id="loginHeading">Staff Login</h2>

        <label for="txtStaffId">Staff ID</label>
        <input type="text" id="txtStaffId" name="txtStaffId" placeholder="Enter your staff ID" />

        <label for="txtPassword">Password</label>
        <input type="password" id="txtPassword" name="txtPassword" placeholder="Enter your password" />

        <button type="button" id="btnLogin">Login</button>
    </div>

    <!-- Resolve script path as well -->
    <script src="<%= ResolveUrl("~/Scripts/Auth.js") %>"></script>

</body>
</html>

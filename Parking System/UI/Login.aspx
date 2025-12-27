<%@ Page Language="C#" AutoEventWireup="false" %>
<!--Login Page for Staff Members-->
<!DOCTYPE html>
<html>
<head>
    <title>Staff Login</title>
    <link rel="stylesheet" href="/Content/site.css" />
</head>
<body>

    <div>
        <label>Staff ID</label><br />
        <input type="text" id="txtStaffId" /><br /><br />

        <label>Password</label><br />
        <input type="password" id="txtPassword" /><br /><br />

        <button type="button" id="btnLogin">Login</button>
    </div>

    <script src="/Scripts/auth.js"></script>

</body>
</html>

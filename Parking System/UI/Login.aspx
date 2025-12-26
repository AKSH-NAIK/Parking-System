<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Parking_System.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            Staff ID:
<asp:TextBox ID="txtName" runat="server"></asp:TextBox>
<asp:RequiredFieldValidator ID="rfvName" runat="server"
ControlToValidate="txtName"
ErrorMessage="Name is required"
ForeColor="Red">
</asp:RequiredFieldValidator>
<br /><br />
            Password:
<asp:TextBox ID="txtPassword" runat="server"TextMode="Password"></asp:TextBox>
<asp:RequiredFieldValidator ID="rfvPassword" runat="server"ControlToValidate="txtPassword"ErrorMessage="Password is required"ForeColor="Red"></asp:RequiredFieldValidator>
<br /><br />
        </div>
    </form>
</body>
</html>

<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Default.aspx.cs" Inherits="Parking_System._Default" %>

    <asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

        <main>
            <section class="card" style="max-width: 800px; margin: 2rem auto; text-align: center;">
                <h1>Parking Management System</h1>
                <p class="subtitle">Efficient terminal-style parking oversight.</p>
                <div style="margin-top: 2rem;">
                    <a href="UI/Login.aspx" class="btn primary">Access Staff Portal</a>
                </div>
            </section>

            <div class="dash-grid-2col" style="max-width: 1000px; margin: 0 auto;">
                <section class="finance-card">
                    <h2 style="margin-top: 0;">Minimal</h2>
                    <p>Clean, distraction-free interface focused on performance.</p>
                </section>
                <section class="finance-card">
                    <h2 style="margin-top: 0;">Techy</h2>
                    <p>Modern dark theme with real-time data visualization.</p>
                </section>
            </div>
        </main>

    </asp:Content>
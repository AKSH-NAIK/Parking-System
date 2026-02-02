# 🚗 Smart Parking Management System

A robust and efficient web-based application designed to streamline parking operations, track vehicle entry/exit, and manage revenue automatically. Built with **ASP.NET Web Forms** and **SQL Server**, this system provides a seamless experience for both parking staff and administrators.

---

## ✨ Key Features

- **📊 Real-time Dashboard**: Monitor current parking occupancy (2-wheelers & 4-wheelers) and track revenue statistics (Daily & Monthly).
- **📝 Automated Entry Management**: Dedicated entry modules with automatic slot allocation and double-parking prevention.
- **🚪 Efficient Exit Processing**: Instant vehicle lookup, automated fee calculation (hourly/half-hourly), and exit processing.
- **💸 UPI Payment Integration**: Dynamic UPI payment links and QR code generation for contactless payments.
- **🔍 Advanced Search**: Real-time vehicle search to identify owners, entry times, and allocated slots.
- **🔐 Secure Access**: Role-based access control for Staff and Administrators.

---

## 🛠️ Technology Stack

- **Backend**: C# (.NET Framework 4.7.2).
- **Frontend Scripting**: JavaScript (jQuery / AJAX).
- **Web Framework**: ASP.NET Web Forms.
- **API Architecture**: Generic Handlers (.ashx) for real-time asynchronous communication.

---

## 🚀 Getting Started

### Prerequisites
- **Visual Studio 2022** (ASP.NET and web development workload).
- **SQL Server** (LocalDB, Express, or Remote).
- **.NET Framework 4.7.2**+.

### 📦 Installation
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/AKSH-NAIK/Parking-System.git
   ```
2. **Open the Project**: Open `Parking System.slnx` or the project folder in Visual Studio.
3. **Configure Database**: Follow the instructions in the [Database Configuration](#-database-connection--configuration) section.
4. **Run**: Set `UI/Login.aspx` as the start page and press `F5`.

---

## 🗄️ Database Connection & Configuration

To connect your own database, update the `connStr` variable in the following API handlers:

- `Parking System/API/auth.ashx.cs`
- `Parking System/API/vehicleEntry.ashx.cs`
- `Parking System/API/vehicleExit.ashx.cs`
- `Parking System/API/dashboardStats.ashx.cs`
- `Parking System/API/searchVehicle.ashx.cs`

### Connection String Examples:

*   **LocalDB**: `@"Data Source=(localdb)\MSSQLLocalDB; Initial Catalog=ParkingSystemDB; Integrated Security=True;"`
*   **SQL Express**: `@"Data Source=.\SQLEXPRESS; Initial Catalog=ParkingSystemDB; Integrated Security=True;"`
*   **Remote/Cloud SQL**: `@"Data Source=IP_OR_URL; Initial Catalog=DB_NAME; User ID=user; Password=pass;"`

> [!IMPORTANT]
> **Schema Requirement**: Your custom database must contain tables for `Staff`, `Vehicles`, `ParkingSlots`, and `Transactions` with columns matching the project's logic.

---

## 🏗️ Using Other Database Providers

To use a non-SQL Server database (like **MySQL**, **PostgreSQL**, or **MongoDB**):
1.  **Install Drivers**: Add the relevant NuGet package (e.g., `MySql.Data`, `Npgsql`, or `MongoDB.Driver`).
2.  **Update Handlers**: Replace `SqlConnection`, `SqlCommand`, and `SqlDataReader` with the respective classes from your chosen provider.
3.  **Refactor SQL**: Adjust the query syntax to match the dialect of your target database.

---

## 👤 Default Credentials
- **Staff ID**: `admin`
- **Passcode**: `admin123`

---

## 📄 License

This project is licensed under the [MIT License](LICENSE.txt).

---

**Developed by [Aksh Naik](https://github.com/AKSH-NAIK)**
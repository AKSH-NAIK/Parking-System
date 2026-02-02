# 🚗 Smart Parking Management System

A robust and efficient web-based application designed to streamline parking operations, track vehicle entry/exit, and manage revenue automatically. Built with **ASP.NET Web Forms** and **SQL Server**, this system provides a seamless experience for both parking staff and administrators.

---

## ✨ Key Features

- **📊 Real-time Dashboard**: Monitor current parking occupancy (2-wheelers & 4-wheelers) and track revenue statistics (Daily & Monthly).
- **📝 Automated Entry Management**:
  - Dedicated entry modules for 2-Wheelers and 4-Wheelers.
  - Automatic slot allocation based on availability.
  - Real-time validation to prevent double parking.
- **🚪 Efficient Exit Processing**:
  - Instant vehicle lookup by registration number.
  - Automated parking fee calculation based on duration.
  - Support for hourly and half-hourly billing increments.
- **💸 UPI Payment Integration**: Generates dynamic UPI payment links/QR codes for contactless payments.
- **🔍 Advanced Search**: Search for any parked vehicle to find its owner, entry time, and allocated slot.
- **🔐 Secure Access**: Role-based access control for Staff and Administrators.

---

## 🛠️ Technology Stack

- **Backend**: C# (.NET Framework 4.7.2).
- **Frontend Scripting**: JavaScript (jQuery / AJAX).
- **Web Framework**: ASP.NET Web Forms.
- **API**: Generic Handlers (.ashx) for AJAX-based communication.

---

## 🚀 Getting Started

### Prerequisites

- **Visual Studio 2022** (with ASP.NET and web development workload).
- **SQL Server Express** or **LocalDB**.
- **.NET Framework 4.7.2** or higher.

### 📦 Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/AKSH-NAIK/Parking-System.git
   cd Parking-System
   ```

2. **Open the Project**:
   - Open `Parking System.slnx` or the project folder in Visual Studio.

3. **Database Setup**:
   Follow the detailed instructions in the [Database Configuration](#-database-configuration) section below.

4. **Run the Application**:
   - Set `Default.aspx` or `UI/Login.aspx` as the start page.
   - Press `F5` to run with IIS Express.

---

## 🗄️ Database Connection & Configuration

To connect your own database to this project, follow these steps:

### 1. Identify your Connection String
Depending on your SQL Server setup, your connection string will look different. Here are common examples:

*   **LocalDB (Default)**:
    ```csharp
    string connStr = @"Data Source=(localdb)\MSSQLLocalDB; Initial Catalog=ParkingSystemDB; Integrated Security=True;";
    ```
*   **SQL Server Express**:
    ```csharp
    string connStr = @"Data Source=.\SQLEXPRESS; Initial Catalog=ParkingSystemDB; Integrated Security=True;";
    ```
*   **Remote SQL Server (with Authentication)**:
    ```csharp
    string connStr = @"Data Source=YOUR_SERVER_IP; Initial Catalog=ParkingSystemDB; User ID=your_username; Password=your_password; Encrypt=False;";
    ```

### 2. Update the API Handlers
The project uses the variable `connStr` to manage database connections. You must update this variable in the following files to point to your database:

- `Parking System/API/auth.ashx.cs`
- `Parking System/API/vehicleEntry.ashx.cs`
- `Parking System/API/vehicleExit.ashx.cs`
- `Parking System/API/dashboardStats.ashx.cs`
- `Parking System/API/searchVehicle.ashx.cs`

> [!IMPORTANT]
> **Database Schema**: Ensure your custom database contains the necessary tables (`Staff`, `Vehicles`, `ParkingSlots`, `Transactions`) with the correct column names as expected by the API logic.

> [!TIP]
> **Centralized Configuration**: For production, it is recommended to move these connection strings into the `<connectionStrings>` section of the `Web.config` file to manage them centrally.

---

## 🏗️ Using Other Database Providers (MySQL, PostgreSQL, MongoDB, etc.)

This project is currently optimized for **SQL Server** using `System.Data.SqlClient`. If you wish to use a different database provider, follow this roadmap:

### 1. For Relational Databases (MySQL, PostgreSQL)
You can continue using the existing logic but must change the Data Provider:
- **MySQL**: Install the `MySql.Data` NuGet package and replace `SqlConnection`, `SqlCommand`, and `SqlDataReader` with `MySqlConnection`, `MySqlCommand`, and `MySqlDataReader`.
- **PostgreSQL**: Install the `Npgsql` NuGet package and use `NpgsqlConnection`, `NpgsqlCommand`, and `NpgsqlDataReader`.
- **Note**: You will need to adjust the SQL syntax in the API handlers to match the provider's dialect (e.g., using `` ` `` for MySQL or `"` for PostgreSQL).

### 2. For NoSQL Databases (MongoDB)
Switching to MongoDB requires a more significant change in the data access layer:
- **Install Driver**: Add the `MongoDB.Driver` NuGet package.
- **Change Logic**: Instead of writing SQL queries, you will use MongoDB's `IMongoCollection` and BSON documents.
- **Example Flow**:
  1. Define a C# model classes (e.g., `Vehicle`, `Transaction`).
  2. In the API handlers, replace the `using (SqlConnection...)` blocks with MongoDB client calls:
     ```csharp
     var client = new MongoClient("mongodb://localhost:27017");
     var database = client.GetDatabase("ParkingSystemDB");
     var collection = database.GetCollection<Vehicle>("Vehicles");
     ```

### 3. Recommended Approach: Repository Pattern
If you plan to support multiple database types, it is highly recommended to implement a **Repository Pattern**:
1. Create an Interface (e.g., `IVehicleRepository`).
2. Create concrete implementations for each database (e.g., `SqlVehicleRepository`, `MongoVehicleRepository`).
3. Inject the desired repository into your API handlers.

---

## 👤 Default Credentials

Use the following credentials to log in for the first time:

- **Staff ID**: `admin`
- **Passcode**: `admin123`

---

## 📸 Screenshots

*(Add your project screenshots here)*

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE.txt](LICENSE.txt) file for details.

---

**Developed by [Aksh Naik](https://github.com/AKSH-NAIK)**
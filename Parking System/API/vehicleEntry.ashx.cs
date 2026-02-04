using System;
using System.Web;
using System.Data.SqlClient;
using System.Web.SessionState;

public class vehicleEntry : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";

        try
        {
            string ownerName = context.Request.Form["ownerName"];
            string phoneNumber = context.Request.Form["phoneNumber"];
            string vehicleNumber = context.Request.Form["vehicleNumber"];
            string vehicleType = context.Request.Form["vehicleType"];
            string entryTimeStr = context.Request.Form["entryTime"];

            if (string.IsNullOrWhiteSpace(ownerName) || string.IsNullOrWhiteSpace(phoneNumber) ||
                string.IsNullOrWhiteSpace(vehicleNumber) || string.IsNullOrWhiteSpace(vehicleType))
            {
                Write(context, false, "All fields are required", "");
                return;
            }

            DateTime entryTime = string.IsNullOrWhiteSpace(entryTimeStr)
                ? DateTime.Now
                : DateTime.Parse(entryTimeStr);

            string staffId = context.Session["StaffId"]?.ToString();

            string connStr = @"Data Source=(localdb)\MSSQLLocalDB;
                              Initial Catalog=ParkingSystemDB;
                              Integrated Security=True;
                              Connect Timeout=30;
                              Encrypt=False;";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string checkSql = @"SELECT COUNT(*) FROM Transactions 
                                   WHERE VehicleId IN (SELECT VehicleId FROM Vehicles WHERE VehicleNumber=@VehicleNumber)
                                   AND ExitTime IS NULL";
                SqlCommand checkCmd = new SqlCommand(checkSql, conn);
                checkCmd.Parameters.AddWithValue("@VehicleNumber", vehicleNumber);
                int alreadyParked = (int)checkCmd.ExecuteScalar();

                if (alreadyParked > 0)
                {
                    Write(context, false, "Vehicle is already parked!", "");
                    return;
                }

                int vehicleId;
                string getVehicleSql = "SELECT VehicleId FROM Vehicles WHERE VehicleNumber=@VehicleNumber";
                SqlCommand getVehicleCmd = new SqlCommand(getVehicleSql, conn);
                getVehicleCmd.Parameters.AddWithValue("@VehicleNumber", vehicleNumber);
                object existingVehicle = getVehicleCmd.ExecuteScalar();

                if (existingVehicle != null)
                {
                    vehicleId = (int)existingVehicle;

                    // Update existing vehicle details to match current entry
                    string updateVehicleSql = @"UPDATE Vehicles 
                                              SET OwnerName=@OwnerName, 
                                                  PhoneNumber=@PhoneNumber, 
                                                  VehicleType=@VehicleType
                                              WHERE VehicleId=@VehicleId";
                    SqlCommand updateVehicleCmd = new SqlCommand(updateVehicleSql, conn);
                    updateVehicleCmd.Parameters.AddWithValue("@OwnerName", ownerName);
                    updateVehicleCmd.Parameters.AddWithValue("@PhoneNumber", phoneNumber);
                    updateVehicleCmd.Parameters.AddWithValue("@VehicleType", vehicleType);
                    updateVehicleCmd.Parameters.AddWithValue("@VehicleId", vehicleId);
                    updateVehicleCmd.ExecuteNonQuery();
                }
                else
                {
                    string insertVehicleSql = @"INSERT INTO Vehicles (OwnerName, PhoneNumber, VehicleNumber, VehicleType) 
                                                OUTPUT INSERTED.VehicleId
                                                VALUES (@OwnerName, @PhoneNumber, @VehicleNumber, @VehicleType)";
                    SqlCommand insertVehicleCmd = new SqlCommand(insertVehicleSql, conn);
                    insertVehicleCmd.Parameters.AddWithValue("@OwnerName", ownerName);
                    insertVehicleCmd.Parameters.AddWithValue("@PhoneNumber", phoneNumber);
                    insertVehicleCmd.Parameters.AddWithValue("@VehicleNumber", vehicleNumber);
                    insertVehicleCmd.Parameters.AddWithValue("@VehicleType", vehicleType);
                    vehicleId = (int)insertVehicleCmd.ExecuteScalar();
                }

                string findSlotSql = @"SELECT TOP 1 SlotId, SlotNumber FROM ParkingSlots 
                                      WHERE VehicleType=@VehicleType AND IsOccupied=0 
                                      ORDER BY SlotNumber";
                SqlCommand findSlotCmd = new SqlCommand(findSlotSql, conn);
                findSlotCmd.Parameters.AddWithValue("@VehicleType", vehicleType);
                SqlDataReader reader = findSlotCmd.ExecuteReader();

                if (!reader.Read())
                {
                    Write(context, false, "No slots available for " + vehicleType, "");
                    return;
                }

                int slotId = reader.GetInt32(0);
                string slotNumber = reader.GetString(1);
                reader.Close();

                string updateSlotSql = "UPDATE ParkingSlots SET IsOccupied=1 WHERE SlotId=@SlotId";
                SqlCommand updateSlotCmd = new SqlCommand(updateSlotSql, conn);
                updateSlotCmd.Parameters.AddWithValue("@SlotId", slotId);
                updateSlotCmd.ExecuteNonQuery();

                string insertTransactionSql = @"INSERT INTO Transactions (VehicleId, SlotId, EntryTime, StaffId) 
                                               VALUES (@VehicleId, @SlotId, @EntryTime, @StaffId)";
                SqlCommand insertTransactionCmd = new SqlCommand(insertTransactionSql, conn);
                insertTransactionCmd.Parameters.AddWithValue("@VehicleId", vehicleId);
                insertTransactionCmd.Parameters.AddWithValue("@SlotId", slotId);
                insertTransactionCmd.Parameters.AddWithValue("@EntryTime", entryTime);
                insertTransactionCmd.Parameters.AddWithValue("@StaffId", (object)staffId ?? DBNull.Value);
                insertTransactionCmd.ExecuteNonQuery();

                Write(context, true, "Slot " + slotNumber + " allocated successfully!", slotNumber);
            }
        }
        catch (Exception ex)
        {
            Write(context, false, "Error: " + ex.Message, "");
        }
    }

    private void Write(HttpContext ctx, bool success, string message, string slotNumber)
    {
        string json = "{\"success\":" + success.ToString().ToLower() + ",\"message\":\"" + message + "\"";
        if (!string.IsNullOrEmpty(slotNumber))
        {
            json += ",\"slotNumber\":\"" + slotNumber + "\"";
        }
        json += "}";
        ctx.Response.Write(json);
    }

    public bool IsReusable
    {
        get { return false; }
    }
}
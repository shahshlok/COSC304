<!DOCTYPE html>
<html>
<head>
    <title>Customer Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f9f9f9;
            color: #333;
        }
        h1 {
            color: #4CAF50;
            text-align: center;
            font-size: 24px;
            margin-bottom: 20px;
        }
        .table-container {
            display: flex;
            justify-content: center;
        }
        table {
            width: 60%;
            max-width: 600px;
            border-collapse: collapse;
            margin: 20px auto;
            background-color: #fff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            overflow: hidden;
        }
        th, td {
            padding: 12px 15px;
            text-align: left;
        }
        th {
            background-color: #4CAF50;
            color: white;
            font-weight: bold;
            font-size: 16px;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #e0f7fa;
        }
        td {
            font-size: 14px;
            color: #555;
        }
        .no-info {
            text-align: center;
            color: red;
            font-weight: bold;
            margin-top: 20px;
        }
        .error-message {
            color: red;
            font-weight: bold;
            margin-top: 20px;
            text-align: center;
        }
        .success-message {
            color: green;
            font-weight: bold;
            margin-top: 20px;
            text-align: center;
        }
        .edit-buttons {
            text-align: center;
            margin: 20px 0;
        }
        .edit-button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin: 0 10px;
            font-size: 14px;
        }
        .edit-button:hover {
            background-color: #45a049;
        }
        .form-container {
            max-width: 500px;
            margin: 20px auto;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            display: none;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #333;
        }
        .form-group input {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .form-buttons {
            margin-top: 20px;
            text-align: right;
        }
        .form-buttons button {
            margin-left: 10px;
        }
        .cancel-button {
            background-color: #f44336;
        }
        .cancel-button:hover {
            background-color: #da190b;
        }
    </style>
</head>
<body>

<h1>Customer Profile</h1>

<%@ include file="auth.jsp"%>
<%@ page import="java.sql.*, java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
    // Display message if any
    String message = request.getParameter("message");
    if (message != null && !message.isEmpty()) {
        if (message.toLowerCase().contains("error")) {
            out.println("<div class='error-message'>" + message + "</div>");
        } else {
            out.println("<div class='success-message'>" + message + "</div>");
        }
    }
%>

<div class="table-container">
<%
    String userName = (String) session.getAttribute("authenticatedUser");
    if (userName == null) {
        out.println("<p class='error-message'>Error: You must be logged in to view this page.</p>");
        return;
    }

    String sql = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid FROM customer WHERE userid = ?";
    try (Connection con = DriverManager.getConnection(url, uid, pw);
         PreparedStatement stmt = con.prepareStatement(sql)) {

        stmt.setString(1, userName);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            out.println("<table>");
            out.println("<tr><th>Customer Id</th><td>" + rs.getInt("customerId") + "</td></tr>");
            out.println("<tr><th>User Id</th><td>" + rs.getString("userid") + "</td></tr>");
            out.println("<tr><th>First Name</th><td>" + rs.getString("firstName") + "</td></tr>");
            out.println("<tr><th>Last Name</th><td>" + rs.getString("lastName") + "</td></tr>");
            out.println("<tr><th>Email</th><td>" + rs.getString("email") + "</td></tr>");
            out.println("<tr><th>Phone</th><td>" + rs.getString("phonenum") + "</td></tr>");
            out.println("<tr><th>Address</th><td>" + rs.getString("address") + "</td></tr>");
            out.println("<tr><th>City</th><td>" + rs.getString("city") + "</td></tr>");
            out.println("<tr><th>State</th><td>" + rs.getString("state") + "</td></tr>");
            out.println("<tr><th>Postal Code</th><td>" + rs.getString("postalCode") + "</td></tr>");
            out.println("<tr><th>Country</th><td>" + rs.getString("country") + "</td></tr>");
            out.println("</table>");
            
            // Store current values for form
            String currentAddress = rs.getString("address");
            String currentCity = rs.getString("city");
            String currentState = rs.getString("state");
            String currentPostal = rs.getString("postalCode");
            String currentCountry = rs.getString("country");
%>
            <div class="edit-buttons">
                <button class="edit-button" onclick="showAddressForm()">Edit Address</button>
                <button class="edit-button" onclick="showPasswordForm()">Change Password</button>
            </div>

            <!-- Address Edit Form -->
            <div id="addressForm" class="form-container">
                <form action="editprofile.jsp" method="post">
                    <input type="hidden" name="action" value="updateAddress">
                    <div class="form-group">
                        <label>Address:</label>
                        <input type="text" name="address" value="<%= currentAddress %>" required>
                    </div>
                    <div class="form-group">
                        <label>City:</label>
                        <input type="text" name="city" value="<%= currentCity %>" required>
                    </div>
                    <div class="form-group">
                        <label>State:</label>
                        <input type="text" name="state" value="<%= currentState %>" required>
                    </div>
                    <div class="form-group">
                        <label>Postal Code:</label>
                        <input type="text" name="postalCode" value="<%= currentPostal %>" required>
                    </div>
                    <div class="form-group">
                        <label>Country:</label>
                        <input type="text" name="country" value="<%= currentCountry %>" required>
                    </div>
                    <div class="form-buttons">
                        <button type="button" class="edit-button cancel-button" onclick="hideAddressForm()">Cancel</button>
                        <button type="submit" class="edit-button">Update Address</button>
                    </div>
                </form>
            </div>

            <!-- Password Change Form -->
            <div id="passwordForm" class="form-container">
                <form action="editprofile.jsp" method="post">
                    <input type="hidden" name="action" value="updatePassword">
                    <div class="form-group">
                        <label>Current Password:</label>
                        <input type="password" name="currentPassword" required>
                    </div>
                    <div class="form-group">
                        <label>New Password (minimum 5 characters):</label>
                        <input type="password" name="newPassword" required minlength="5">
                    </div>
                    <div class="form-group">
                        <label>Confirm New Password:</label>
                        <input type="password" name="confirmPassword" required minlength="5">
                    </div>
                    <div class="form-buttons">
                        <button type="button" class="edit-button cancel-button" onclick="hidePasswordForm()">Cancel</button>
                        <button type="submit" class="edit-button">Update Password</button>
                    </div>
                </form>
            </div>
<%
        } else {
            out.println("<p class='no-info'>No customer information found.</p>");
        }
    } catch (SQLException e) {
        out.println("<p class='error-message'>Error retrieving customer information: " + e.getMessage() + "</p>");
    }
%>
</div>

<script>
function showAddressForm() {
    document.getElementById('addressForm').style.display = 'block';
    document.getElementById('passwordForm').style.display = 'none';
}

function hideAddressForm() {
    document.getElementById('addressForm').style.display = 'none';
}

function showPasswordForm() {
    document.getElementById('passwordForm').style.display = 'block';
    document.getElementById('addressForm').style.display = 'none';
}

function hidePasswordForm() {
    document.getElementById('passwordForm').style.display = 'none';
}
</script>

</body>
</html>

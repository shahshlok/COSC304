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
    </style>
</head>
<body>

<h1>Customer Profile</h1>

<%@ include file="auth.jsp"%>
<%@ page import="java.sql.*, java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

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
        } else {
            out.println("<p class='no-info'>No customer information found.</p>");
        }
    } catch (SQLException e) {
        out.println("<p class='error-message'>Error retrieving customer information: " + e.getMessage() + "</p>");
    }
%>
</div>

</body>
</html>

<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Administrator Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f8f9fa;
        }
        h2 {
            color: #333;
            margin-bottom: 20px;
            font-weight: bold;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        th, td {
            padding: 8px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #ddd;
        }
        .error-message {
            color: red;
            font-weight: bold;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>

<div class="container">
    <h2>Total Sales by Day</h2>

    <%
        String sql = "SELECT CAST(orderDate AS DATE) AS OrderDate, SUM(totalAmount) AS TotalSales " +
                     "FROM ordersummary " +
                     "GROUP BY CAST(orderDate AS DATE) " +
                     "ORDER BY OrderDate DESC";

        try (Connection con = DriverManager.getConnection(url, uid, pw);
             PreparedStatement stmt = con.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            out.println("<table>");
            out.println("<thead><tr><th>Date</th><th>Total Sales</th></tr></thead>");
            out.println("<tbody>");

            while (rs.next()) {
                String orderDate = rs.getString("OrderDate");
                double totalSales = rs.getDouble("TotalSales");
                out.println("<tr><td>" + orderDate + "</td><td>$" + String.format("%.2f", totalSales) + "</td></tr>");
            }

            out.println("</tbody></table>");

            // Customer List Section
            out.println("<h2>Customer List</h2>");
            String customerSql = "SELECT customerId, firstName + ' ' + lastName as customerName FROM customer ORDER BY customerId";
            PreparedStatement customerStmt = con.prepareStatement(customerSql);
            ResultSet customerRs = customerStmt.executeQuery();

            out.println("<table>");
            out.println("<thead><tr><th>Customer ID</th><th>Customer Name</th></tr></thead>");
            out.println("<tbody>");

            while (customerRs.next()) {
                out.println("<tr>");
                out.println("<td>" + customerRs.getInt("customerId") + "</td>");
                out.println("<td>" + customerRs.getString("customerName") + "</td>");
                out.println("</tr>");
            }

            out.println("</tbody></table>");

        } catch (SQLException e) {
            out.println("<p class='error-message'>Error retrieving data: " + e.getMessage() + "</p>");
        }
    %>
</div>

</body>
</html>

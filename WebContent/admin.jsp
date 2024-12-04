<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Administrator Page - Total Sales by Day</title>
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
        .container {
            max-width: 800px;
            margin: auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        table {
            width: 100%;
            margin-top: 20px;
        }
        th {
            background-color: #007bff;
            color: #fff;
            text-align: center;
        }
        td, th {
            padding: 12px;
            border: 1px solid #ddd;
        }
        .error-message {
            color: #dc3545;
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

            out.println("<table class='table table-striped table-bordered'>");
            out.println("<thead><tr><th>Date</th><th>Total Sales</th></tr></thead>");
            out.println("<tbody>");

            while (rs.next()) {
                String orderDate = rs.getString("OrderDate");
                double totalSales = rs.getDouble("TotalSales");
                out.println("<tr><td>" + orderDate + "</td><td>$" + String.format("%.2f", totalSales) + "</td></tr>");
            }

            out.println("</tbody></table>");

        } catch (SQLException e) {
            out.println("<p class='error-message'>Error retrieving sales data: " + e.getMessage() + "</p>");
        }
    %>
</div>

</body>
</html>


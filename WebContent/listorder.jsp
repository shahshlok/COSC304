<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Grocery Order List</title>
	<style>
		body {
			font-family: Arial, sans-serif;
			background-color: #f8f9fa;
			margin: 20px;
			color: #333;
		}
		h1 {
			color: #0056b3;
			text-align: center;
			margin-bottom: 20px;
		}
		.order-summary, .product-details {
			width: 100%;
			margin: 0 auto 30px;
			border-collapse: collapse;
			box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
		}
		.order-summary th, .order-summary td, .product-details th, .product-details td {
			border: 1px solid #ddd;
			padding: 10px;
			text-align: left;
		}
		.order-summary th {
			background-color: #007bff;
			color: #fff;
		}
		.product-details th {
			background-color: #e9ecef;
		}
		.product-details td {
			background-color: #fff;
		}
		.total-amount {
			font-weight: bold;
			color: #28a745;
		}
		.customer-name {
			font-weight: bold;
			color: #333;
		}
		.product-details {
			margin-top: 10px;
			width: 90%;
		}
	</style>
</head>
<body>

<h1>Order List</h1>

<%
	// Load SQL Server driver
	try {
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	} catch (ClassNotFoundException e) {
		out.println("ClassNotFoundException: " + e);
	}

	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	try (Connection con = DriverManager.getConnection(url, uid, pw)) {
		Statement stmt = con.createStatement();
		String query = "SELECT orderId, orderDate, ordersummary.customerId, firstName, lastName, totalAmount " +
					   "FROM ordersummary JOIN customer ON ordersummary.customerId = customer.customerId";
		ResultSet rs = stmt.executeQuery(query);

		String productQuery = "SELECT orderproduct.productId, orderproduct.quantity, orderproduct.price " +
							  "FROM orderproduct JOIN product ON orderproduct.productId = product.productId " +
							  "WHERE orderproduct.orderId = ?";
		PreparedStatement pstmt = con.prepareStatement(productQuery);

		while (rs.next()) {
			// Order summary
			out.println("<table class='order-summary'>");
			out.println("<tr><th>Order ID</th><th>Order Date</th><th>Customer ID</th><th>Customer Name</th><th>Total Amount</th></tr>");
			out.println("<tr>");
			out.println("<td>" + rs.getInt("orderId") + "</td>");
			out.println("<td>" + rs.getTimestamp("orderDate") + "</td>");
			out.println("<td>" + rs.getInt("customerId") + "</td>");
			out.println("<td class='customer-name'>" + rs.getString("firstName") + " " + rs.getString("lastName") + "</td>");
			out.println("<td class='total-amount'>" + currFormat.format(rs.getDouble("totalAmount")) + "</td>");
			out.println("</tr>");
			out.println("</table>");

			// Fetch and display product details for the order
			pstmt.setInt(1, rs.getInt("orderId"));
			ResultSet productRs = pstmt.executeQuery();

			out.println("<table class='product-details'>");
			out.println("<tr><th>Product ID</th><th>Quantity</th><th>Price</th></tr>");
			while (productRs.next()) {
				out.println("<tr>");
				out.println("<td>" + productRs.getInt("productId") + "</td>");
				out.println("<td>" + productRs.getInt("quantity") + "</td>");
				out.println("<td>" + currFormat.format(productRs.getDouble("price")) + "</td>");
				out.println("</tr>");
			}
			out.println("</table><br>");
		}
	} catch (SQLException e) {
		out.println("SQL Exception: " + e.getMessage());
	}
%>

</body>
</html>

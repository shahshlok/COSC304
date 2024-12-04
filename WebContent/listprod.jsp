<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="javax.xml.transform.Result" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>YOUR NAME Grocery</title>
	<style>
		body {
			font-family: Arial, sans-serif;
			background-color: #f4f4f4;
			margin: 0;
			padding: 20px;
		}
		h1 {
			color: #333;
		}
		form {
			margin-bottom: 20px;
		}
		input[type="text"], select {
			padding: 10px;
			width: 300px;
			border-radius: 5px;
			border: 1px solid #ccc;
			margin-right: 10px;
		}
		input[type="submit"], input[type="reset"] {
			padding: 10px 20px;
			background-color: #28a745;
			color: white;
			border: none;
			border-radius: 5px;
			cursor: pointer;
		}
		input[type="reset"] {
			background-color: #dc3545;
		}
		.product-list {
			display: grid;
			grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
			gap: 20px;
			margin-top: 20px;
		}
		.product-item {
			background-color: white;
			padding: 15px;
			border-radius: 5px;
			box-shadow: 0 2px 5px rgba(0,0,0,0.1);
			display: flex;
			flex-direction: column;
			align-items: start;
		}
		.addcart {
			margin-top: 10px;
			padding: 8px 12px;
			background-color: #007bff;
			color: white;
			border-radius: 5px;
			text-align: center;
			text-decoration: none;
			cursor: pointer;
		}
		.addcart:hover {
			background-color: #0056b3;
		}
	</style>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<!-- Search form for product name or ID -->
<form method="get" action="listprod.jsp">
	<input type="text" name="productName" placeholder="Enter product name or ID...">
	<input type="submit" value="Submit">
	<input type="reset" value="Reset"> (Leave blank for all products)
</form>

<!-- Dropdown filter for category -->
<form method="get" action="listprod.jsp">
	<select name="category">
		<option value="">All Categories</option>
		<%
			// Load SQL Server driver
			try {
				Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
			} catch (java.lang.ClassNotFoundException e) {
				out.println("ClassNotFoundException: " + e);
			}

			// Query to get categories
			try (Connection con = DriverManager.getConnection(url, uid, pw)) {
				String categoryQuery = "SELECT categoryName FROM category";
				PreparedStatement categoryStatement = con.prepareStatement(categoryQuery);
				ResultSet categoryResult = categoryStatement.executeQuery();

				// Populate the dropdown with category names
				while (categoryResult.next()) {
					String categoryName = categoryResult.getString("categoryName");
		%>
					<option value="<%= categoryName %>"><%= categoryName %></option>
		<%
				}
			} catch (SQLException e) {
				out.println("Error fetching categories: " + e);
			}
		%>
	</select>
	<input type="submit" value="Filter by Category">
</form>

<div class="product-list">
	<%
		// Retrieve parameters
		String nameOrId = request.getParameter("productName");
		String category = request.getParameter("category");

		// Load SQL Server driver
		try {
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		} catch (java.lang.ClassNotFoundException e) {
			out.println("ClassNotFoundException: " + e);
		}

		// Set up the query and conditions
		String query = "SELECT product.productId, product.productName, product.productPrice " +
                       "FROM product JOIN category ON product.categoryId = category.categoryId WHERE 1=1 ";

		// Adjust the query based on which parameter is present
		if (nameOrId != null && !nameOrId.isEmpty()) {
			// Check if the input is numeric to search by product ID
			boolean isNumeric = nameOrId.matches("\\d+");
			if (isNumeric) {
				query += " AND product.productId = ?";
			} else {
				query += " AND product.productName LIKE ?";
			}
		} else if (category != null && !category.isEmpty()) {
			query += " AND category.categoryName = ?";
		}

		try (Connection con = DriverManager.getConnection(url, uid, pw);
		     PreparedStatement preparedStatement = con.prepareStatement(query)) {

			// Set the parameters based on search type
			int paramIndex = 1;
			if (nameOrId != null && !nameOrId.isEmpty()) {
				if (nameOrId.matches("\\d+")) {
					preparedStatement.setInt(paramIndex++, Integer.parseInt(nameOrId));
				} else {
					preparedStatement.setString(paramIndex++, "%" + nameOrId + "%");
				}
			} else if (category != null && !category.isEmpty()) {
				preparedStatement.setString(paramIndex, category);
			}

			ResultSet resultSet = preparedStatement.executeQuery();

			// Display each product
			while (resultSet.next()) {
				String pname = resultSet.getString("productName");
				int pid = resultSet.getInt("productId");
				int pp = resultSet.getInt("productPrice");
	%>
	<div class="product-item">
		<a href="product.jsp?id=<%= pid %>"><strong><%= pname %></strong></a><br>
		<span>Price: $<%= pp %></span>
		<a class="addcart" href="<%= "addcart.jsp?id=" + pid + "&name=" + URLEncoder.encode(pname, StandardCharsets.UTF_8) + "&price=" + pp %>">Add to cart</a>
	</div>
	<%
			}
		} catch (SQLException e) {
			out.println(e);
		}
	%>
</div>

</body>
</html>

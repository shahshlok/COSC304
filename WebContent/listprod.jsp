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
    <title>SportifyHub - Your Sports Store</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --secondary-color: #f59e0b;
            --text-color: #1f2937;
            --background-color: #f3f4f6;
            --card-background: #ffffff;
        }

        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            background-color: var(--background-color);
            margin: 0;
            padding: 0;
            color: var(--text-color);
        }

        .product-list {
            max-width: 1400px;
            margin: 2rem auto;
            padding: 0 1rem;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 2rem;
        }

        .product-card {
            background: var(--card-background);
            border-radius: 12px;
            padding: 1rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: transform 0.2s, box-shadow 0.2s;
            display: flex;
            flex-direction: column;
        }

        .product-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }

        .product-image {
            width: 100%;
            height: 200px;
            object-fit: contain;
            border-radius: 8px;
            margin-bottom: 1rem;
        }

        .product-name {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-color);
            margin-bottom: 0.5rem;
            text-decoration: none;
        }

        .product-price {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        .add-to-cart {
            background-color: var(--primary-color);
            color: white;
            padding: 0.75rem 1rem;
            border-radius: 8px;
            text-decoration: none;
            text-align: center;
            font-weight: 600;
            transition: background-color 0.2s;
            margin-top: auto;
        }

        .add-to-cart:hover {
            background-color: #1d4ed8;
        }

        @media (max-width: 768px) {
            .product-list {
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            }
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>

    <main class="product-list">
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
            String query = "SELECT product.productId, product.productName, product.productPrice, product.productImageURL " +
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

                ResultSet rst = preparedStatement.executeQuery();

                // Display each product
                while (rst.next()) {
                    int productId = rst.getInt("productId");
                    String productName = rst.getString("productName");
                    double productPrice = rst.getDouble("productPrice");
                    String productImageURL = rst.getString("productImageURL");

                    String addCartLink = "addcart.jsp?id=" + productId + "&name=" + URLEncoder.encode(productName, StandardCharsets.UTF_8) + "&price=" + productPrice;
                    String productDetailsLink = "product.jsp?id=" + productId;
        %>
                    <div class="product-card">
                        <img src="<%= productImageURL %>" alt="<%= productName %>" class="product-image" onerror="this.src='img/default.jpg'">
                        <a href="<%= productDetailsLink %>" class="product-name"><%= productName %></a>
                        <div class="product-price">$<%= String.format("%.2f", productPrice) %></div>
                        <a href="<%= addCartLink %>" class="add-to-cart">
                            <i class="fas fa-shopping-cart"></i>
                            Add to Cart
                        </a>
                    </div>
        <%
                }
            } catch (SQLException ex) {
                out.println(ex);
            }
        %>
    </main>
</body>
</html>

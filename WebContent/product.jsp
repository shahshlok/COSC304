<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SportifyHub - Product Details</title>
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

        .product-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 3rem;
            background: var(--card-background);
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 2rem;
        }

        .product-image {
            width: 100%;
            height: auto;
            border-radius: 8px;
            object-fit: contain;
        }

        .product-info {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .product-name {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-color);
            margin: 0;
        }

        .product-price {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
        }

        .product-description {
            font-size: 1.1rem;
            line-height: 1.6;
            color: #4b5563;
        }

        .add-to-cart {
            background-color: var(--primary-color);
            color: white;
            padding: 1rem 2rem;
            border-radius: 8px;
            text-decoration: none;
            text-align: center;
            font-weight: 600;
            font-size: 1.1rem;
            transition: background-color 0.2s;
            display: inline-block;
            margin-top: auto;
        }

        .add-to-cart:hover {
            background-color: #1d4ed8;
        }

        .product-meta {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
            padding: 1rem;
            background-color: #f8fafc;
            border-radius: 8px;
        }

        .meta-item {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .meta-label {
            font-size: 0.9rem;
            color: #64748b;
            font-weight: 500;
        }

        .meta-value {
            font-size: 1rem;
            color: var(--text-color);
            font-weight: 600;
        }

        @media (max-width: 768px) {
            .product-container {
                grid-template-columns: 1fr;
                gap: 2rem;
            }
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>

    <main class="product-container">
        <%
            String productId = request.getParameter("id");
            
            if (productId == null || productId.isEmpty()) {
                out.println("<p>Invalid product id. Please try again.</p>");
            } else {
                getConnection();
                
                String sql = "SELECT product.*, category.categoryName " +
                            "FROM product JOIN category ON product.categoryId = category.categoryId " +
                            "WHERE productId = ?";
                
                PreparedStatement pstmt = con.prepareStatement(sql);
                pstmt.setString(1, productId);
                
                ResultSet rst = pstmt.executeQuery();
                
                if (rst.next()) {
                    String productName = rst.getString("productName");
                    double productPrice = rst.getDouble("productPrice");
                    String productDesc = rst.getString("productDesc");
                    String categoryName = rst.getString("categoryName");
                    String productImageURL = rst.getString("productImageURL");
                    int categoryId = rst.getInt("categoryId");
                    
                    String addCartURL = "addcart.jsp?id=" + productId + "&name=" + URLEncoder.encode(productName, StandardCharsets.UTF_8) + "&price=" + productPrice;
        %>
                    <div class="product-image-container">
                        <img src="<%= productImageURL %>" alt="<%= productName %>" class="product-image" onerror="this.src='img/default.jpg'">
                    </div>
                    <div class="product-info">
                        <h1 class="product-name"><%= productName %></h1>
                        <div class="product-price"><%= NumberFormat.getCurrencyInstance().format(productPrice) %></div>
                        <p class="product-description"><%= productDesc != null ? productDesc : "No description available." %></p>
                        
                        <div class="product-meta">
                            <div class="meta-item">
                                <span class="meta-label">Category</span>
                                <span class="meta-value"><%= categoryName %></span>
                            </div>
                            <div class="meta-item">
                                <span class="meta-label">Product ID</span>
                                <span class="meta-value">#<%= productId %></span>
                            </div>
                        </div>
                        
                        <a href="<%= addCartURL %>" class="add-to-cart">
                            <i class="fas fa-shopping-cart"></i> Add to Cart
                        </a>
                    </div>
        <%
                } else {
                    out.println("<p>No product found.</p>");
                }
                
                closeConnection();
            }
        %>
    </main>
</body>
</html>
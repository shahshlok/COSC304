<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
    <title>Ray's Grocery - Product Information</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        .product-container {
            max-width: 600px;
            margin: 40px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #f9f9f9;
        }
        .product-image {
            max-width: 100%;
            height: auto;
            margin-bottom: 20px;
        }
        .product-price {
            font-size: 1.2em;
            font-weight: bold;
            color: #28a745;
            margin-bottom: 20px;
        }
        .product-buttons a {
            margin-right: 10px;
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<%
// Get product name to search for
String productId = request.getParameter("id");
String sql = "";
if (productId != null) {
    try {
        Connection con = DriverManager.getConnection(url, uid, pw);

        //PreparedStatement
        sql = "SELECT productName, productPrice, productImageURL, productImage FROM product WHERE productId = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, Integer.parseInt(productId));
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            String productName = rs.getString("productName");
            double productPrice = rs.getDouble("productPrice");
            String productImageURL = rs.getString("productImageURL");

            out.println("<h2 class='product-name'>" + productName + "</h2>");
            out.println("<p class='product-price'>Price: $" + NumberFormat.getInstance().format(productPrice) + "</p>");
            if (productImageURL != null && !productImageURL.isEmpty()) {
                out.println("<img src='" + productImageURL + "' alt='Product Image' />");
            }
            if (productName.equals("Chai")) {
                out.println("<img src='displayImage.jsp?productId=" + productId + "' alt= '" + productName + "' class='img-fluid' />");
            }
            out.println("<a href='addcart.jsp?id=" + productId + "&name=" + java.net.URLEncoder.encode(productName, "UTF-8") + "&price=" + productPrice + "' class='btn btn-primary'>Add to Cart</a>");
            out.println("<a href='listprod.jsp' class='btn btn-secondary'>Continue Shopping</a>");
        } else {
            out.println("Product not found.");
        }

        rs.close();
        stmt.close();
        con.close();

    } catch (SQLException e) {
        out.println("Error: " + e.getMessage());
    }
} else {
    out.println("No product ID provided.");
}
%>

</body>
</html>

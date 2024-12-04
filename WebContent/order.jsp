<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery Order Processing</title>
</head>
<style>

    body {
        font-family: Arial, sans-serif;
        margin: 20px;
    }
    h1 {
        color: #333;
    }
    table {
        width: 100%;
        margin-bottom: 20px;
    }
    th, td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: left;
    }
    th {
        background-color: #f2f2f2;
        font-weight: bold;
    }
    .product-details th, .product-details td {
        background-color: #fff;
    }
</style>
<body>

<%
    // Get customer id
    String custId = request.getParameter("customerId");
    String custPass = request.getParameter("customerPassword");
    @SuppressWarnings({"unchecked"})
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    } catch (java.lang.ClassNotFoundException e) {
        out.println("ClassNotFoundException: " + e);
    }

    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
        con.setAutoCommit(false);  // Start transaction

        // Check if customer exists
        String customerQuery = "SELECT COUNT(customerId) FROM customer WHERE customerId = ?";
        try (PreparedStatement pstmt = con.prepareStatement(customerQuery)) {
            pstmt.setString(1, custId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next() && rs.getInt(1) == 0) {
                out.println("<h4>Customer does not exist or password is wrong</h4>");
                return;  // Exit the process
            }
        }
        // Check if password is correct
        String customerQuery1 = "SELECT password FROM customer WHERE customerId = ?";
        try (PreparedStatement pstmt = con.prepareStatement(customerQuery1)) {
            pstmt.setString(1, custId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next() && !rs.getString(1).equals(custPass)) {
                out.println("<h4>Customer does not exist or password is wrong</h4>");
                return;  // Exit the process
            }
        }

        // Check if shopping cart is empty
        if (productList == null || productList.isEmpty()) {
            out.println("<h4>Shopping cart is empty</h4>");
            return;  // Exit the process
        }

        // Insert order summary
        String sql = "INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (?, GETDATE(), 0)";
        int orderId;
        try (PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, custId);
            pstmt.executeUpdate();
            ResultSet keys = pstmt.getGeneratedKeys();
            keys.next();
            orderId = keys.getInt(1);
        }

        double totalAmount = 0;

        String insertProduct = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
        try (PreparedStatement pstmt = con.prepareStatement(insertProduct)) {
            for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
                ArrayList<Object> product = entry.getValue();
                String productId = (String) product.get(0);
                String price = (String) product.get(2);
                double pr = Double.parseDouble(price);
                int qty = ((Integer) product.get(3)).intValue();

                pstmt.setInt(1, orderId);
                pstmt.setString(2, productId);
                pstmt.setInt(3, qty);
                pstmt.setDouble(4, pr);
                pstmt.executeUpdate();

                totalAmount += pr * qty;
            }
        }

        // Update total amount in ordersummary
        String updateTotal = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
        try (PreparedStatement pstmt = con.prepareStatement(updateTotal)) {
            pstmt.setDouble(1, totalAmount);
            pstmt.setInt(2, orderId);
            pstmt.executeUpdate();
        }

        String showOrder="Select orderId,productId,quantity,price from orderproduct where orderId=?";
        try (PreparedStatement pstmt=con.prepareStatement(showOrder)){
            pstmt.setInt(1,orderId);
            ResultSet resultSet=pstmt.executeQuery();
            out.println("<table class='product-details'>");
            out.println("<tr>");
            out.println("<th>Product Id</th>");
            out.println("<th>Quantity</th>");
            out.println("<th>Price</th>");
            out.println("</tr>");
            NumberFormat currFormat = NumberFormat.getCurrencyInstance();
            while (resultSet.next()){
                out.println("<tr>");
                out.println("<td>"+resultSet.getInt("productId")+"</td>");
                out.println("<td>"+resultSet.getInt("quantity")+"</td>");
                out.println("<td>"+currFormat.format(resultSet.getDouble("price"))+"</td>");
                out.println("</tr>");
            }
        }

        con.commit();  // Commit transaction


    } catch (SQLException e) {
        out.println(e);
    }
%>
</BODY>
</HTML>


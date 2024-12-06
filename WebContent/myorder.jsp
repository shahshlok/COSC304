<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<%
    // Authentication check
    String authenticatedUser = (String) session.getAttribute("authenticatedUser");
    if (authenticatedUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Orders</title>
    <style>
        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        h1 {
            color: #2C3E50;
            text-align: center;
            margin-bottom: 30px;
        }
        .order-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            border-radius: 8px;
            overflow: hidden;
        }
        .order-table th {
            background: #2C3E50;
            color: white;
            padding: 15px;
            text-align: left;
        }
        .order-table td {
            padding: 15px;
            border-bottom: 1px solid #eee;
        }
        .order-table tr:last-child td {
            border-bottom: none;
        }
        .order-header {
            background: #f8f9fa;
            font-weight: bold;
        }
        .order-total {
            font-weight: bold;
            color: #2C3E50;
        }
        .product-row td {
            padding: 10px 15px;
        }
        .no-orders {
            text-align: center;
            padding: 50px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            color: #666;
        }
        .error-message {
            color: #721c24;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            text-align: center;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <div class="container">
        <h1>My Order History</h1>
        
        <%
        try {
            // Get connection
            getConnection();
            
            // Get customer ID for the logged-in user
            String customerIdQuery = "SELECT customerId FROM customer WHERE userid = ?";
            PreparedStatement custStmt = con.prepareStatement(customerIdQuery);
            custStmt.setString(1, authenticatedUser);
            ResultSet custRs = custStmt.executeQuery();
            
            if (!custRs.next()) {
                out.println("<div class='error-message'>Customer account not found.</div>");
                return;
            }
            
            int customerId = custRs.getInt("customerId");
            
            // Get all orders for this customer
            String orderQuery = 
                "SELECT O.orderId, O.orderDate, O.totalAmount, " +
                "P.productId, P.productName, OP.quantity, OP.price " +
                "FROM ordersummary O " +
                "JOIN orderproduct OP ON O.orderId = OP.orderId " +
                "JOIN product P ON OP.productId = P.productId " +
                "WHERE O.customerId = ? " +
                "ORDER BY O.orderDate DESC, O.orderId, P.productId";
                
            PreparedStatement orderStmt = con.prepareStatement(orderQuery);
            orderStmt.setInt(1, customerId);
            ResultSet orderRs = orderStmt.executeQuery();
            
            NumberFormat currFormat = NumberFormat.getCurrencyInstance();
            
            boolean hasOrders = false;
            int currentOrderId = -1;
            
            while (orderRs.next()) {
                hasOrders = true;
                int orderId = orderRs.getInt("orderId");
                
                if (currentOrderId != orderId) {
                    // Close previous table if exists
                    if (currentOrderId != -1) {
                        out.println("</table>");
                    }
                    
                    currentOrderId = orderId;
                    
                    // Start new order table
                    out.println("<table class='order-table'>");
                    out.println("<tr>");
                    out.println("<th colspan='2'>Order #" + orderId + "</th>");
                    out.println("<th>Date: " + orderRs.getTimestamp("orderDate") + "</th>");
                    out.println("<th style='text-align: right;'>Total: " + 
                              currFormat.format(orderRs.getDouble("totalAmount")) + "</th>");
                    out.println("</tr>");
                    out.println("<tr class='order-header'>");
                    out.println("<td>Product</td>");
                    out.println("<td>Quantity</td>");
                    out.println("<td>Price</td>");
                    out.println("<td>Subtotal</td>");
                    out.println("</tr>");
                }
                
                // Add product row
                double subtotal = orderRs.getInt("quantity") * orderRs.getDouble("price");
                out.println("<tr class='product-row'>");
                out.println("<td>" + orderRs.getString("productName") + "</td>");
                out.println("<td>" + orderRs.getInt("quantity") + "</td>");
                out.println("<td>" + currFormat.format(orderRs.getDouble("price")) + "</td>");
                out.println("<td style='text-align: right;'>" + currFormat.format(subtotal) + "</td>");
                out.println("</tr>");
            }
            
            // Close last table if exists
            if (currentOrderId != -1) {
                out.println("</table>");
            }
            
            if (!hasOrders) {
                out.println("<div class='no-orders'>");
                out.println("<h3>No orders found</h3>");
                out.println("<p>You haven't placed any orders yet.</p>");
                out.println("</div>");
            }
            
            // Close resources
            if (orderRs != null) orderRs.close();
            if (orderStmt != null) orderStmt.close();
            if (custRs != null) custRs.close();
            if (custStmt != null) custStmt.close();
            
        } catch (SQLException ex) {
            out.println("<div class='error-message'>Error: " + ex.getMessage() + "</div>");
        } finally {
            closeConnection();
        }
        %>
    </div>
</body>
</html>

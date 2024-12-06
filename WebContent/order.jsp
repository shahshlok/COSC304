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
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmation - SportifyHub</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --secondary-color: #f59e0b;
            --success-color: #10b981;
            --danger-color: #ef4444;
            --text-color: #1f2937;
            --background-color: #f3f4f6;
            --card-background: #ffffff;
            --border-color: #e5e7eb;
        }

        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            background-color: var(--background-color);
            margin: 0;
            padding: 0;
            color: var(--text-color);
            min-height: 100vh;
        }

        .header {
            background-color: var(--primary-color);
            padding: 1rem 2rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-content {
            max-width: 1400px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .logo {
            font-size: 1.8rem;
            font-weight: bold;
            color: white;
            text-decoration: none;
            transition: opacity 0.2s;
        }

        .logo:hover {
            opacity: 0.9;
        }

        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }

        .order-container {
            background-color: var(--card-background);
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .order-success {
            text-align: center;
            margin-bottom: 2rem;
            padding: 2rem;
            background-color: #ecfdf5;
            border-radius: 8px;
            color: var(--success-color);
        }

        .order-success i {
            font-size: 3rem;
            margin-bottom: 1rem;
        }

        .order-error {
            text-align: center;
            margin-bottom: 2rem;
            padding: 2rem;
            background-color: #fef2f2;
            border-radius: 8px;
            color: var(--danger-color);
        }

        .order-error i {
            font-size: 3rem;
            margin-bottom: 1rem;
        }

        .page-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-color);
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .order-details {
            margin-top: 2rem;
        }

        .order-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 2rem;
        }

        .order-table th {
            background-color: var(--background-color);
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            color: var(--text-color);
            border-bottom: 2px solid var(--border-color);
        }

        .order-table td {
            padding: 1rem;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }

        .order-table tr:hover {
            background-color: var(--background-color);
        }

        .price-column {
            font-weight: 600;
            color: var(--primary-color);
        }

        .total-row td {
            font-weight: 700;
            font-size: 1.1rem;
            border-top: 2px solid var(--border-color);
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s;
            border: none;
            cursor: pointer;
            font-size: 1rem;
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }

        .btn-primary:hover {
            background-color: #1d4ed8;
        }

        .actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
            justify-content: center;
        }

        @media (max-width: 768px) {
            .order-table {
                display: block;
                overflow-x: auto;
            }

            .actions {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-content">
            <a href="index.jsp" class="logo">SportifyHub</a>
        </div>
    </header>

    <div class="container">
        <div class="order-container">
            <%
            // Get customer id
            String custId = request.getParameter("customerId");
            String custPass = request.getParameter("customerPassword");
            @SuppressWarnings({"unchecked"})
            HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

            try {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            } catch (java.lang.ClassNotFoundException e) {
                out.println("<div class='order-error'>");
                out.println("<i class='fas fa-exclamation-circle'></i>");
                out.println("<h2>Error Loading Driver</h2>");
                out.println("<p>" + e.getMessage() + "</p>");
                out.println("</div>");
                return;
            }

            try (Connection con = DriverManager.getConnection(url, uid, pw)) {
                con.setAutoCommit(false);  // Start transaction

                // Check if customer exists and password is correct
                String customerQuery = "SELECT customerId, firstName, lastName FROM customer WHERE customerId = ? AND password = ?";
                String customerName = "";
                try (PreparedStatement pstmt = con.prepareStatement(customerQuery)) {
                    pstmt.setString(1, custId);
                    pstmt.setString(2, custPass);
                    ResultSet rs = pstmt.executeQuery();
                    if (!rs.next()) {
                        out.println("<div class='order-error'>");
                        out.println("<i class='fas fa-exclamation-circle'></i>");
                        out.println("<h2>Authentication Failed</h2>");
                        out.println("<p>Invalid customer ID or password.</p>");
                        out.println("</div>");
                        return;
                    }
                    customerName = rs.getString("firstName") + " " + rs.getString("lastName");
                }

                // Check if shopping cart is empty
                if (productList == null || productList.isEmpty()) {
                    out.println("<div class='order-error'>");
                    out.println("<i class='fas fa-shopping-cart'></i>");
                    out.println("<h2>Empty Cart</h2>");
                    out.println("<p>Your shopping cart is empty.</p>");
                    out.println("</div>");
                    return;
                }

                // Process the order
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

                // Insert order details
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

                // Update total amount
                String updateTotal = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
                try (PreparedStatement pstmt = con.prepareStatement(updateTotal)) {
                    pstmt.setDouble(1, totalAmount);
                    pstmt.setInt(2, orderId);
                    pstmt.executeUpdate();
                }

                // Show order confirmation
                out.println("<div class='order-success'>");
                out.println("<i class='fas fa-check-circle'></i>");
                out.println("<h2>Order Confirmed!</h2>");
                out.println("<p>Thank you for your order, " + customerName + "!</p>");
                out.println("<p>Order #: " + orderId + "</p>");
                out.println("</div>");

                out.println("<div class='order-details'>");
                out.println("<h2 class='page-title'><i class='fas fa-list'></i> Order Details</h2>");

                // Show order items
                String showOrder = "SELECT op.*, p.productName FROM orderproduct op JOIN product p ON op.productId = p.productId WHERE orderId=?";
                try (PreparedStatement pstmt = con.prepareStatement(showOrder)) {
                    pstmt.setInt(1, orderId);
                    ResultSet resultSet = pstmt.executeQuery();
                    
                    out.println("<table class='order-table'>");
                    out.println("<tr>");
                    out.println("<th>Product</th>");
                    out.println("<th>Quantity</th>");
                    out.println("<th>Price</th>");
                    out.println("<th>Subtotal</th>");
                    out.println("</tr>");
                    
                    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
                    while (resultSet.next()) {
                        double price = resultSet.getDouble("price");
                        int quantity = resultSet.getInt("quantity");
                        double subtotal = price * quantity;
                        
                        out.println("<tr>");
                        out.println("<td>" + resultSet.getString("productName") + "</td>");
                        out.println("<td>" + quantity + "</td>");
                        out.println("<td class='price-column'>" + currFormat.format(price) + "</td>");
                        out.println("<td class='price-column'>" + currFormat.format(subtotal) + "</td>");
                        out.println("</tr>");
                    }
                    
                    out.println("<tr class='total-row'>");
                    out.println("<td colspan='3' align='right'><b>Order Total:</b></td>");
                    out.println("<td class='price-column'>" + currFormat.format(totalAmount) + "</td>");
                    out.println("</tr>");
                    out.println("</table>");
                }

                out.println("</div>");

                // Clear the shopping cart
                session.removeAttribute("productList");

                con.commit();  // Commit transaction

                // Add action buttons
                out.println("<div class='actions'>");
                out.println("<a href='listprod.jsp' class='btn btn-primary'>");
                out.println("<i class='fas fa-shopping-bag'></i> Continue Shopping");
                out.println("</a>");
                out.println("</div>");

            } catch (SQLException e) {
                out.println("<div class='order-error'>");
                out.println("<i class='fas fa-exclamation-circle'></i>");
                out.println("<h2>Order Processing Error</h2>");
                out.println("<p>" + e.getMessage() + "</p>");
                out.println("</div>");
            }
            %>
        </div>
    </div>
</body>
</html>

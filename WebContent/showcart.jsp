<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Shopping Cart - SportifyHub</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --secondary-color: #f59e0b;
            --text-color: #1f2937;
            --background-color: #f3f4f6;
            --card-background: #ffffff;
            --border-color: #e5e7eb;
            --danger-color: #ef4444;
            --success-color: #10b981;
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

        .cart-container {
            background-color: var(--card-background);
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            padding: 2rem;
            margin-bottom: 2rem;
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

        .cart-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 2rem;
        }

        .cart-table th {
            background-color: var(--background-color);
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            color: var(--text-color);
            border-bottom: 2px solid var(--border-color);
        }

        .cart-table td {
            padding: 1rem;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }

        .cart-table tr:hover {
            background-color: var(--background-color);
        }

        .quantity-input {
            width: 80px;
            padding: 0.5rem;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            text-align: center;
            font-size: 1rem;
        }

        .price-column {
            font-weight: 600;
            color: var(--primary-color);
        }

        .total-row td {
            font-weight: 700;
            font-size: 1.1rem;
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

        .btn-secondary {
            background-color: var(--secondary-color);
            color: white;
        }

        .btn-secondary:hover {
            background-color: #d97706;
        }

        .btn-danger {
            background-color: var(--danger-color);
            color: white;
            padding: 0.5rem 1rem;
            font-size: 0.875rem;
        }

        .btn-danger:hover {
            background-color: #dc2626;
        }

        .actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        .empty-cart {
            text-align: center;
            padding: 3rem;
        }

        .empty-cart i {
            font-size: 4rem;
            color: var(--border-color);
            margin-bottom: 1rem;
        }

        .empty-cart h1 {
            font-size: 1.5rem;
            color: var(--text-color);
            margin-bottom: 1rem;
        }

        @media (max-width: 768px) {
            .cart-table {
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
        <div class="cart-container">
            <%
            // Get the current list of products
            @SuppressWarnings({"unchecked"})
            HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

            if (productList == null || productList.isEmpty())
            {
            %>
                <div class="empty-cart">
                    <i class="fas fa-shopping-cart"></i>
                    <h1>Your shopping cart is empty!</h1>
                    <a href="listprod.jsp" class="btn btn-primary">
                        <i class="fas fa-shopping-bag"></i>
                        Start Shopping
                    </a>
                </div>
            <%
            }
            else
            {
                NumberFormat currFormat = NumberFormat.getCurrencyInstance();
            %>
                <h1 class="page-title">
                    <i class="fas fa-shopping-cart"></i>
                    Your Shopping Cart
                </h1>
                
                <form action="updatequantity.jsp" method="post">
                    <table class="cart-table">
                        <thead>
                            <tr>
                                <th>Product ID</th>
                                <th>Product Name</th>
                                <th>Quantity</th>
                                <th>Price</th>
                                <th>Subtotal</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                        double total = 0;
                        Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
                        while (iterator.hasNext()) 
                        {	
                            Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                            ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
                            if (product.size() < 4)
                            {
                                out.println("Expected product with four entries. Got: "+product);
                                continue;
                            }
                            
                            Object price = product.get(2);
                            Object itemqty = product.get(3);
                            double pr = 0;
                            int qty = 0;
                            
                            try
                            {
                                pr = Double.parseDouble(price.toString());
                                qty = Integer.parseInt(itemqty.toString());
                            }
                            catch (Exception e)
                            {
                                out.println("Invalid price or quantity for product: "+product.get(0));
                                continue;
                            }
                        %>
                            <tr>
                                <td><%= product.get(0) %></td>
                                <td><%= product.get(1) %></td>
                                <td>
                                    <input type="number" 
                                           name="quantity_<%= product.get(0) %>" 
                                           value="<%= qty %>" 
                                           min="1" 
                                           class="quantity-input">
                                </td>
                                <td class="price-column"><%= currFormat.format(pr) %></td>
                                <td class="price-column"><%= currFormat.format(pr*qty) %></td>
                                <td>
                                    <a href="removefromcart.jsp?productId=<%= product.get(0) %>" 
                                       class="btn btn-danger">
                                        <i class="fas fa-trash"></i>
                                        Remove
                                    </a>
                                </td>
                            </tr>
                        <%
                            total = total + pr*qty;
                        }
                        %>
                            <tr class="total-row">
                                <td colspan="4" align="right">Order Total:</td>
                                <td class="price-column"><%= currFormat.format(total) %></td>
                                <td></td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-sync-alt"></i>
                            Update Quantities
                        </button>
                        <a href="checkout.jsp" class="btn btn-secondary">
                            <i class="fas fa-credit-card"></i>
                            Proceed to Checkout
                        </a>
                        <a href="listprod.jsp" class="btn btn-primary">
                            <i class="fas fa-shopping-bag"></i>
                            Continue Shopping
                        </a>
                    </div>
                </form>
            <%
            }
            %>
        </div>
    </div>
</body>
</html>

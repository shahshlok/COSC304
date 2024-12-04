<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<%
// Retrieve the shopping cart from the session
@SuppressWarnings("unchecked")
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList != null) {
    // Loop through all products in the cart and update quantities
    for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
        String productId = entry.getKey();
        String quantityParam = request.getParameter("quantity_" + productId);

        if (quantityParam != null) {
            try {
                int quantity = Integer.parseInt(quantityParam);
                if (quantity > 0) {
                    // Update the product quantity in the cart
                    ArrayList<Object> product = entry.getValue();
                    product.set(3, quantity); // Update quantity in the product details
                }
            } catch (NumberFormatException e) {
                // Handle invalid input, e.g., set a default quantity or show an error
            }
        }
    }
    // Save the updated cart back to the session
    session.setAttribute("productList", productList);
}

// Redirect back to the shopping cart page
response.sendRedirect("showcart.jsp");
%>

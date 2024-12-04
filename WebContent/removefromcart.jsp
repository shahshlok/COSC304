<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<%
// Get product ID from the request
String productId = request.getParameter("productId");

@SuppressWarnings("unchecked")
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList != null && productId != null) {
    // Remove the product with the specified ID
    productList.remove(productId);
    // Update the session attribute
    session.setAttribute("productList", productList);
}

// Redirect back to the shopping cart page
response.sendRedirect("showcart.jsp");
%>

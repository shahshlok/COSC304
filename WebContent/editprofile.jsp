<%@ page language="java" import="java.io.*,java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<%
String userid = (String) session.getAttribute("authenticatedUser");
if (userid == null) {
    response.sendRedirect("login.jsp");
    return;
}

// Get the action type (address or password update)
String action = request.getParameter("action");

try {
    getConnection();
    
    if ("updateAddress".equals(action)) {
        // Get address parameters
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String postalCode = request.getParameter("postalCode");
        String country = request.getParameter("country");

        // Validate required fields
        if (address == null || city == null || state == null || postalCode == null || country == null ||
            address.trim().isEmpty() || city.trim().isEmpty() || state.trim().isEmpty() || 
            postalCode.trim().isEmpty() || country.trim().isEmpty()) {
            response.sendRedirect("customer.jsp?message=All fields are required");
            return;
        }

        // Update address in database
        String sql = "UPDATE customer SET address=?, city=?, state=?, postalCode=?, country=? WHERE userid=?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, address);
        pstmt.setString(2, city);
        pstmt.setString(3, state);
        pstmt.setString(4, postalCode);
        pstmt.setString(5, country);
        pstmt.setString(6, userid);
        
        pstmt.executeUpdate();
        response.sendRedirect("customer.jsp?message=Address updated successfully");
    }
    else if ("updatePassword".equals(action)) {
        // Get password parameters
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate required fields
        if (currentPassword == null || newPassword == null || confirmPassword == null ||
            currentPassword.trim().isEmpty() || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
            response.sendRedirect("customer.jsp?message=All password fields are required");
            return;
        }

        // Validate password length
        if (newPassword.length() < 5) {
            response.sendRedirect("customer.jsp?message=Password must be at least 5 characters long");
            return;
        }

        // Validate password match
        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("customer.jsp?message=New passwords do not match");
            return;
        }

        // Verify current password
        String sql = "SELECT password FROM customer WHERE userid = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, userid);
        ResultSet rst = pstmt.executeQuery();

        if (rst.next()) {
            String storedPassword = rst.getString("password");
            if (!currentPassword.equals(storedPassword)) {
                response.sendRedirect("customer.jsp?message=Current password is incorrect");
                return;
            }

            // Update password
            sql = "UPDATE customer SET password = ? WHERE userid = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, newPassword);
            pstmt.setString(2, userid);
            pstmt.executeUpdate();

            response.sendRedirect("customer.jsp?message=Password updated successfully");
        }
    }
} catch (SQLException ex) {
    response.sendRedirect("customer.jsp?message=Error: " + ex.getMessage());
} finally {
    closeConnection();
}
%>


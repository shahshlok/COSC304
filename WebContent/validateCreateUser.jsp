<%@ page language="java" import="java.io.*,java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<%
try {
    // Get all form parameters
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("email");
    String phonenum = request.getParameter("phonenum");
    String address = request.getParameter("address");
    String city = request.getParameter("city");
    String state = request.getParameter("state");
    String postalCode = request.getParameter("postalCode");
    String country = request.getParameter("country");
    String userid = request.getParameter("userid");
    String password = request.getParameter("password");

    // Validate all fields are filled
    if (firstName == null || lastName == null || email == null || phonenum == null || 
        address == null || city == null || state == null || postalCode == null || 
        country == null || userid == null || password == null ||
        firstName.isEmpty() || lastName.isEmpty() || email.isEmpty() || phonenum.isEmpty() || 
        address.isEmpty() || city.isEmpty() || state.isEmpty() || postalCode.isEmpty() || 
        country.isEmpty() || userid.isEmpty() || password.isEmpty()) {
        response.sendRedirect("createuser.jsp?message=All fields are required");
        return;
    }

    // Validate password length
    if (password.length() < 5) {
        response.sendRedirect("createuser.jsp?message=Password must be at least 5 characters long");
        return;
    }

    // Validate phone number format
    if (!phonenum.matches("\\d{3}-\\d{3}-\\d{4}")) {
        response.sendRedirect("createuser.jsp?message=Invalid phone number format. Use: XXX-XXX-XXXX");
        return;
    }

    // Get the database connection
    getConnection();

    // Check if email is already in use
    PreparedStatement emailCheck = con.prepareStatement("SELECT customerId FROM customer WHERE email = ?");
    emailCheck.setString(1, email);
    ResultSet emailRs = emailCheck.executeQuery();
    if (emailRs.next()) {
        response.sendRedirect("createuser.jsp?message=Email address is already registered");
        return;
    }

    // Check if phone number is already in use
    PreparedStatement phoneCheck = con.prepareStatement("SELECT customerId FROM customer WHERE phonenum = ?");
    phoneCheck.setString(1, phonenum);
    ResultSet phoneRs = phoneCheck.executeQuery();
    if (phoneRs.next()) {
        response.sendRedirect("createuser.jsp?message=Phone number is already registered");
        return;
    }

    // Check if username is already taken
    PreparedStatement userCheck = con.prepareStatement("SELECT customerId FROM customer WHERE userid = ?");
    userCheck.setString(1, userid);
    ResultSet userRs = userCheck.executeQuery();
    if (userRs.next()) {
        response.sendRedirect("createuser.jsp?message=Username is already taken");
        return;
    }

    // Insert new user into database
    String sql = "INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, firstName);
    pstmt.setString(2, lastName);
    pstmt.setString(3, email);
    pstmt.setString(4, phonenum);
    pstmt.setString(5, address);
    pstmt.setString(6, city);
    pstmt.setString(7, state);
    pstmt.setString(8, postalCode);
    pstmt.setString(9, country);
    pstmt.setString(10, userid);
    pstmt.setString(11, password);

    pstmt.executeUpdate();

    // Set session for automatic login
    session.setAttribute("authenticatedUser", userid);

    // Clean up resources
    pstmt.close();
    closeConnection();

    // Redirect to home page
    response.sendRedirect("index.jsp");

} catch (SQLException ex) {
    response.sendRedirect("createuser.jsp?message=Error creating account: " + ex.getMessage());
} finally {
    closeConnection();
}
%>

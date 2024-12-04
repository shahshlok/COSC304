<%@ page language="java" import="java.io.*,java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<%
    String authenticatedUser = null;
    session = request.getSession(true);

    try {
        // Attempt to validate login
        authenticatedUser = validateLogin(out, request, session);
    } catch (IOException e) {
        System.err.println(e);
    }

    // Redirect based on authentication result
    if (authenticatedUser != null) {
        response.sendRedirect("index.jsp"); // Successful login
    } else {
        response.sendRedirect("login.jsp"); // Failed login - redirect back to login page with a message
    }
%>

<%!
    String validateLogin(JspWriter out, HttpServletRequest request, HttpSession session) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String retStr = null;

        if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
            return null; // Return null if credentials are missing
        }

        try {
            // Establish a database connection
            Connection con = DriverManager.getConnection(url, uid, pw);
            String sql = "SELECT userid FROM customer WHERE userid = ? AND password = ?";
            try (PreparedStatement pstmt = con.prepareStatement(sql)) {
                pstmt.setString(1, username);
                pstmt.setString(2, password);
                ResultSet rs = pstmt.executeQuery();

                // Check if the credentials match a record
                if (rs.next()) {
                    retStr = username; // Set retStr to the username if a match is found
                }
            } finally {
                con.close();
            }
        } catch (SQLException ex) {
            out.println(ex);
        }

        // Set session attributes based on login success or failure
        if (retStr != null) {
            session.removeAttribute("loginMessage");
            session.setAttribute("authenticatedUser", username);
        } else {
            session.setAttribute("loginMessage", "Could not connect to the system using that username/password.");
        }

        return retStr;
    }
%>

<!DOCTYPE html>
<html>
<head>
<title>Login - SportifyHub</title>
<style>
    body {
        font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
        background-color: #f5f5f5;
        margin: 0;
        padding: 20px;
    }
    .container {
        max-width: 400px;
        margin: 40px auto;
        background: white;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    h3 {
        text-align: center;
        color: #2C3E50;
        margin-bottom: 30px;
    }
    .form-group {
        margin-bottom: 15px;
    }
    label {
        display: block;
        margin-bottom: 5px;
        color: #2C3E50;
    }
    input[type="text"],
    input[type="password"] {
        width: 100%;
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 4px;
        box-sizing: border-box;
    }
    .submit {
        width: 100%;
        padding: 10px;
        background-color: #2C3E50;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 16px;
        margin-top: 20px;
    }
    .submit:hover {
        background-color: #34495E;
    }
    .error-message {
        color: #E74C3C;
        margin-bottom: 20px;
        text-align: center;
    }
    .register-link {
        text-align: center;
        margin-top: 20px;
        color: #666;
    }
    .register-link a {
        color: #2C3E50;
        text-decoration: none;
    }
    .register-link a:hover {
        text-decoration: underline;
    }
</style>
</head>
<body>

<div class="container">
    <h3>Sign In</h3>

    <%
    if (session.getAttribute("loginMessage") != null) {
        out.println("<div class='error-message'>" + session.getAttribute("loginMessage").toString() + "</div>");
    }
    %>

    <form name="MyForm" method="post" action="validateLogin.jsp">
        <div class="form-group">
            <label>Username</label>
            <input type="text" name="username" required>
        </div>
        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" required>
        </div>
        <input class="submit" type="submit" value="Sign In">
    </form>

    <div class="register-link">
        Don't have an account? <a href="createuser.jsp">Create Account</a>
    </div>
</div>

</body>
</html>

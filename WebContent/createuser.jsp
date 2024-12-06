<!DOCTYPE html>
<html>
<head>
    <title>Create Account - SportifyHub</title>
    <style>
        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 500px;
            margin: 20px auto;
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
        input[type="password"],
        input[type="email"],
        input[type="tel"] {
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
        .error {
            color: #E74C3C;
            margin-bottom: 20px;
            text-align: center;
        }
        .login-link {
            text-align: center;
            margin-top: 20px;
        }
        .login-link a {
            color: #2C3E50;
            text-decoration: none;
        }
        .login-link a:hover {
            text-decoration: underline;
        }
        .required {
            color: #E74C3C;
            margin-left: 3px;
        }
    </style>
</head>
<body>

<div class="container">
    <h3>Create New Account</h3>

    <%
    String message = request.getParameter("message");
    if (message != null) {
        out.println("<div class='error'>" + message + "</div>");
    }
    %>

    <form name="MyForm" method="post" action="validateCreateUser.jsp" onsubmit="return validateForm()">
        <div class="form-group">
            <label>First Name<span class="required">*</span></label>
            <input type="text" name="firstName" required>
        </div>

        <div class="form-group">
            <label>Last Name<span class="required">*</span></label>
            <input type="text" name="lastName" required>
        </div>

        <div class="form-group">
            <label>Email<span class="required">*</span></label>
            <input type="email" name="email" required>
        </div>

        <div class="form-group">
            <label>Phone Number<span class="required">*</span> (Format: XXX-XXX-XXXX)</label>
            <input type="tel" name="phonenum" pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}" required>
        </div>

        <div class="form-group">
            <label>Address<span class="required">*</span></label>
            <input type="text" name="address" required>
        </div>

        <div class="form-group">
            <label>City<span class="required">*</span></label>
            <input type="text" name="city" required>
        </div>

        <div class="form-group">
            <label>State/Province<span class="required">*</span></label>
            <input type="text" name="state" required>
        </div>

        <div class="form-group">
            <label>Postal Code<span class="required">*</span></label>
            <input type="text" name="postalCode" required>
        </div>

        <div class="form-group">
            <label>Country<span class="required">*</span></label>
            <input type="text" name="country" required>
        </div>

        <div class="form-group">
            <label>Username<span class="required">*</span></label>
            <input type="text" name="userid" required>
        </div>

        <div class="form-group">
            <label>Password<span class="required">*</span> (Minimum 5 characters)</label>
            <input type="password" name="password" required minlength="5">
        </div>

        <div class="form-group">
            <label>Confirm Password<span class="required">*</span></label>
            <input type="password" name="confirmPassword" required minlength="5">
        </div>

        <input class="submit" type="submit" value="Create Account">
    </form>

    <div class="login-link">
        Already have an account? <a href="login.jsp">Sign In</a>
    </div>
</div>

<script>
function validateForm() {
    var password = document.getElementsByName("password")[0].value;
    var confirmPassword = document.getElementsByName("confirmPassword")[0].value;
    
    if (password.length < 5) {
        alert("Password must be at least 5 characters long!");
        return false;
    }
    
    if (password !== confirmPassword) {
        alert("Passwords do not match!");
        return false;
    }
    
    var phonePattern = /^\d{3}-\d{3}-\d{4}$/;
    var phone = document.getElementsByName("phonenum")[0].value;
    if (!phonePattern.test(phone)) {
        alert("Phone number must be in format: XXX-XXX-XXXX");
        return false;
    }
    
    return true;
}
</script>

</body>
</html>

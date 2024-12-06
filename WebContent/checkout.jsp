<!DOCTYPE html>
<html>
<head>
    <title>Ray's Grocery Checkout Line</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
            background-color: #f8f8f8;
        }

        .container {
            background-color: #fff;
            padding: 20px 40px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 400px;
            text-align: center;
        }

        h1 {
            font-size: 1.5em;
            color: #333;
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-weight: bold;
            color: #555;
            margin-bottom: 5px;
            text-align: left;
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 1em;
        }

        input[type="submit"], input[type="reset"] {
            background-color: #4CAF50;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            font-size: 1em;
            cursor: pointer;
            margin-top: 10px;
            width: 48%;
            margin-right: 4%;
        }

        input[type="reset"] {
            background-color: #f44336;
        }

        input[type="submit"]:hover, input[type="reset"]:hover {
            opacity: 0.9;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Checkout</h1>
    <p>Please enter your Customer ID and Password to complete the transaction:</p>

    <form method="get" action="order.jsp">
        <label for="customerId">User Name</label>
        <input type="text" name="customerId" id="customerId" required>

        <label for="customerPassword">Password</label>
        <input type="password" name="customerPassword" id="customerPassword" required>

        <input type="submit" value="Submit">
        <input type="reset" value="Reset">
    </form>
</div>

</body>
</html>


<!DOCTYPE html>
<html>
<head>
    <title>SportifyHub - Premium Sports Gear</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2C3E50;
            --secondary-color: #E74C3C;
            --accent-color: #3498DB;
            --background-color: #ECF0F1;
            --text-color: #2C3E50;
            --gradient-start: #2C3E50;
            --gradient-end: #3498DB;
        }

        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            background-color: var(--background-color);
            color: var(--text-color);
            line-height: 1.6;
        }

        .hero-section {
            position: relative;
            height: 80vh;
            background: linear-gradient(135deg, var(--gradient-start), var(--gradient-end));
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .hero-content {
            text-align: center;
            color: white;
            z-index: 2;
            padding: 2rem;
            max-width: 800px;
        }

        .hero-title {
            font-size: 4rem;
            font-weight: 800;
            margin-bottom: 1rem;
            letter-spacing: -1px;
            line-height: 1.2;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }

        .hero-subtitle {
            font-size: 1.5rem;
            margin-bottom: 2rem;
            opacity: 0.9;
        }

        .cta-button {
            display: inline-block;
            padding: 1.2rem 3rem;
            background-color: var(--secondary-color);
            color: white;
            text-decoration: none;
            border-radius: 50px;
            font-size: 1.2rem;
            font-weight: 600;
            transition: transform 0.3s, box-shadow 0.3s;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .cta-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }

        .features-section {
            padding: 5rem 2rem;
            background: white;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 3rem;
            max-width: 1400px;
            margin: 0 auto;
        }

        .feature-card {
            background: white;
            padding: 2rem;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            transition: transform 0.3s;
            text-align: center;
        }

        .feature-card:hover {
            transform: translateY(-10px);
        }

        .feature-icon {
            font-size: 2.5rem;
            color: var(--accent-color);
            margin-bottom: 1.5rem;
        }

        .feature-title {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            color: var(--text-color);
        }

        .feature-description {
            color: #666;
            font-size: 1.1rem;
            line-height: 1.6;
        }

        .trending-section {
            padding: 5rem 2rem;
            background: linear-gradient(to right, #f6f9fc, #ffffff);
        }

        .section-title {
            text-align: center;
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 3rem;
            color: var(--text-color);
        }

        .trending-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            max-width: 1400px;
            margin: 0 auto;
        }

        .product-card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 15px 30px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }

        .product-card:hover {
            transform: translateY(-10px);
        }

        .product-image {
            width: 100%;
            height: 300px;
            object-fit: cover;
        }

        .product-details {
            padding: 1.5rem;
        }

        .product-title {
            font-size: 1.2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            color: var(--text-color);
        }

        .product-price {
            font-size: 1.3rem;
            font-weight: 800;
            color: var(--secondary-color);
        }

        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.5rem;
            }

            .hero-subtitle {
                font-size: 1.2rem;
            }

            .features-grid {
                grid-template-columns: 1fr;
            }

            .trending-grid {
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            }
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>

    <section class="hero-section">
        <div class="hero-content">
            <h1 class="hero-title">Elevate Your Game</h1>
            <p class="hero-subtitle">Premium sports gear for the modern athlete</p>
            <a href="listprod.jsp" class="cta-button">Shop Now</a>
        </div>
    </section>

    <section class="features-section">
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-truck"></i>
                </div>
                <h3 class="feature-title">Express Delivery</h3>
                <p class="feature-description">Get your gear delivered within 24 hours with our premium shipping service</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-medal"></i>
                </div>
                <h3 class="feature-title">Premium Quality</h3>
                <p class="feature-description">Curated selection of top-tier sports equipment and apparel</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-undo"></i>
                </div>
                <h3 class="feature-title">Easy Returns</h3>
                <p class="feature-description">30-day hassle-free returns with our satisfaction guarantee</p>
            </div>
        </div>
    </section>

    <section class="trending-section">
        <h2 class="section-title">Top Selling Products</h2>
        <div class="trending-grid">
            <%@ page import="java.sql.*" %>
            <%@ include file="jdbc.jsp" %>
            <%
            String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            String uid = "sa";
            String pw = "304#sa#pw";

            try ( Connection con = DriverManager.getConnection(url, uid, pw);
                  Statement stmt = con.createStatement();
                  ResultSet rst = stmt.executeQuery("SELECT TOP 4 p.productId, p.productName, p.productPrice, p.productImageURL, COUNT(op.productId) as sales FROM product p JOIN orderproduct op ON p.productId = op.productId GROUP BY p.productId, p.productName, p.productPrice, p.productImageURL ORDER BY sales DESC") 
                )
            {
                while (rst.next()) {
                    String productName = rst.getString("productName");
                    double productPrice = rst.getDouble("productPrice");
                    String imageURL = rst.getString("productImageURL");
            %>
                <div class="product-card">
                    <img src="<%= imageURL %>" alt="<%= productName %>" class="product-image" onerror="this.src='img/default.jpg'">
                    <div class="product-details">
                        <h3 class="product-title"><%= productName %></h3>
                        <p class="product-price">$<%= String.format("%.2f", productPrice) %></p>
                    </div>
                </div>
            <%
                }
            } catch (SQLException ex) {
                out.println("<p>Error loading products: " + ex.getMessage() + "</p>");
            }
            %>
        </div>
    </section>
</body>
</html>

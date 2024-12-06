<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<style>
    .main-header {
        background-color: white;
        padding: 0.5rem 2rem;
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
        gap: 2rem;
    }

    .logo img {
        height: 60px;
        width: auto;
    }

    .nav-links {
        display: flex;
        align-items: center;
        gap: 2rem;
        flex-grow: 1;
        justify-content: center;
    }

    .nav-links a {
        text-decoration: none;
        color: #111;
        font-weight: 500;
        font-size: 1rem;
        padding: 0.5rem 1rem;
        transition: color 0.2s;
    }

    .nav-links a:hover {
        color: #757575;
    }

    .header-actions {
        display: flex;
        align-items: center;
        gap: 1.5rem;
    }

    .search-container {
        position: relative;
        display: flex;
        align-items: center;
    }

    .search-input {
        padding: 0.5rem 1rem;
        padding-left: 2.5rem;
        border: none;
        border-radius: 20px;
        background-color: #f5f5f5;
        width: 180px;
        font-size: 1rem;
    }

    .search-icon {
        position: absolute;
        left: 0.75rem;
        color: #757575;
    }

    .action-icon {
        color: #111;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        position: relative;
    }

    .action-icon:hover {
        color: #757575;
    }

    .user-dropdown {
        position: absolute;
        top: 100%;
        right: 0;
        background: white;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        min-width: 180px;
        opacity: 0;
        visibility: hidden;
        transform: translateY(10px);
        transition: all 0.2s;
        z-index: 1000;
        margin-top: 0.5rem;
    }

    .action-icon:hover .user-dropdown {
        opacity: 1;
        visibility: visible;
        transform: translateY(0);
    }

    .dropdown-item {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        padding: 0.75rem 1rem;
        color: #111;
        text-decoration: none;
        transition: background-color 0.2s;
    }

    .dropdown-item:hover {
        background-color: #f5f5f5;
    }

    .dropdown-divider {
        height: 1px;
        background-color: #eee;
        margin: 0.5rem 0;
    }

    .dropdown-item.logout {
        color: #dc3545;
    }

    .dropdown-item.logout:hover {
        background-color: #fff5f5;
    }

    @media (max-width: 1024px) {
        .nav-links {
            display: none;
        }
    }
</style>

<header class="main-header">
    <div class="header-content">
        <a href="index.jsp" class="logo">
            <img src="img/sportifyhub-logo.png" alt="SportifyHub" onerror="this.src='https://placehold.co/120x60?text=SportifyHub'">
        </a>
        
        <nav class="nav-links">
            <a href="listprod.jsp?category=Nike+Shoes">Nike Shoes</a>
            <a href="listprod.jsp?category=Adidas+Shoes">Adidas Shoes</a>
            <a href="listprod.jsp?category=Nike+Apparel">Nike Apparel</a>
            <a href="listprod.jsp?category=Adidas+Apparel">Adidas Apparel</a>
            <a href="listprod.jsp?category=Basketball+Equipment">Basketball</a>
        </nav>

        <div class="header-actions">
            <div class="search-container">
                <i class="fas fa-search search-icon"></i>
                <form method="get" action="listprod.jsp">
                    <input type="text" name="productName" placeholder="Search" class="search-input">
                </form>
            </div>

            <%
            String userName = (String) session.getAttribute("authenticatedUser");
            if (userName != null) {
                out.println("<div class='action-icon'>");
                out.println("<div><i class='fas fa-user'></i> " + userName + "</div>");
                out.println("<div class='user-dropdown'>");
                out.println("<a href='customer.jsp' class='dropdown-item'><i class='fas fa-user-circle'></i>Profile</a>");
                out.println("<a href='myorder.jsp' class='dropdown-item'><i class='fas fa-box'></i>My Orders</a>");
                out.println("<div class='dropdown-divider'></div>");
                out.println("<a href='logout.jsp' class='dropdown-item logout'><i class='fas fa-sign-out-alt'></i>Logout</a>");
                out.println("</div>");
                out.println("</div>");
            } else {
                out.println("<a href='login.jsp' class='action-icon'><i class='fas fa-user'></i> Sign In</a>");
            }
            %>
            <a href="showcart.jsp" class="action-icon">
                <i class="fas fa-shopping-bag"></i>
            </a>
        </div>
    </div>
</header>

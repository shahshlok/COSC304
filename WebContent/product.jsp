<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SportifyHub - Product Details</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --secondary-color: #f59e0b;
            --text-color: #1f2937;
            --background-color: #f3f4f6;
            --card-background: #ffffff;
        }

        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            background-color: var(--background-color);
            margin: 0;
            padding: 0;
            color: var(--text-color);
        }

        .product-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 2rem;
            background: var(--card-background);
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .product-details {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 3rem;
            margin-bottom: 3rem;
        }

        .product-image {
            width: 100%;
            height: auto;
            border-radius: 8px;
            object-fit: contain;
        }

        .product-info {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .product-name {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-color);
            margin: 0;
        }

        .product-price {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
        }

        .product-description {
            font-size: 1.1rem;
            line-height: 1.6;
            color: #4b5563;
        }

        .add-to-cart {
            background-color: var(--primary-color);
            color: white;
            padding: 1rem 2rem;
            border-radius: 8px;
            text-decoration: none;
            text-align: center;
            font-weight: 600;
            font-size: 1.1rem;
            transition: background-color 0.2s;
            display: inline-block;
            margin-top: auto;
            border: none;
            cursor: pointer;
        }

        .add-to-cart:hover {
            background-color: #1d4ed8;
        }

        .product-meta {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
            padding: 1rem;
            background-color: #f8fafc;
            border-radius: 8px;
        }

        .meta-item {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .meta-label {
            font-size: 0.9rem;
            color: #64748b;
            font-weight: 500;
        }

        .meta-value {
            font-size: 1rem;
            color: var(--text-color);
            font-weight: 600;
        }

        .reviews-section {
            margin-top: 3rem;
            padding-top: 2rem;
            border-top: 1px solid #e5e7eb;
        }

        .rating-summary {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .average-rating {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .rating-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
        }

        .rating-stars {
            color: var(--secondary-color);
        }

        .total-reviews {
            color: #6b7280;
        }

        .review-form {
            display: flex;
            flex-direction: column;
            gap: 1rem;
            margin-top: 1rem;
            background: #f9fafb;
            padding: 1.5rem;
            border-radius: 8px;
        }

        .rating-input, .comment-input {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .rating-input select {
            padding: 0.5rem;
            border: 1px solid #d1d5db;
            border-radius: 4px;
            width: 200px;
        }

        .comment-input textarea {
            padding: 0.75rem;
            border: 1px solid #d1d5db;
            border-radius: 4px;
            resize: vertical;
        }

        .submit-review {
            background-color: var(--primary-color);
            color: white;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 600;
            align-self: flex-start;
        }

        .submit-review:hover {
            background-color: #1d4ed8;
        }

        .login-prompt {
            background: #f9fafb;
            padding: 1rem;
            border-radius: 4px;
            margin: 1rem 0;
        }

        .login-prompt a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
        }

        .reviews-list {
            margin-top: 2rem;
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .review-item {
            padding: 1rem;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
        }

        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.75rem;
        }

        .reviewer-name {
            font-weight: 600;
        }

        .review-rating {
            color: var(--secondary-color);
        }

        .review-date {
            color: #6b7280;
            font-size: 0.875rem;
        }

        .review-comment {
            color: #374151;
            line-height: 1.5;
        }

        .success-message {
            background-color: #dcfce7;
            color: #166534;
            padding: 1rem;
            border-radius: 4px;
            margin: 1rem 0;
        }

        .error-message {
            background-color: #fee2e2;
            color: #991b1b;
            padding: 1rem;
            border-radius: 4px;
            margin: 1rem 0;
        }

        @media (max-width: 768px) {
            .product-details {
                grid-template-columns: 1fr;
                gap: 2rem;
            }

            .review-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.5rem;
            }
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>

    <main class="product-container">
        <%
            String productId = request.getParameter("id");
            String userId = session.getAttribute("authenticatedUser") != null ? session.getAttribute("authenticatedUser").toString() : null;
            String customerId = null;
            String message = "";
            String messageType = "";

            // Get connection
            getConnection();

            // Get customerId if user is logged in
            if (userId != null) {
                String customerIdQuery = "SELECT customerId FROM customer WHERE userid = ?";
                PreparedStatement custStmt = con.prepareStatement(customerIdQuery);
                custStmt.setString(1, userId);
                ResultSet custRs = custStmt.executeQuery();
                if (custRs.next()) {
                    customerId = String.valueOf(custRs.getInt("customerId"));
                }
            }

            // Handle review submission
            if ("POST".equalsIgnoreCase(request.getMethod()) && customerId != null) {
                String rating = request.getParameter("rating");
                String comment = request.getParameter("comment");

                if (rating != null && comment != null && !comment.trim().isEmpty()) {
                    try {
                        // Get current timestamp
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                        String currentTime = sdf.format(new Date());
                        
                        // Insert the review
                        String sql = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (?, ?, ?, ?, ?)";
                        PreparedStatement pstmt = con.prepareStatement(sql);
                        pstmt.setInt(1, Integer.parseInt(rating));
                        pstmt.setString(2, currentTime);
                        pstmt.setInt(3, Integer.parseInt(customerId));
                        pstmt.setInt(4, Integer.parseInt(productId));
                        pstmt.setString(5, comment);
                        
                        pstmt.executeUpdate();
                        message = "Your review has been submitted successfully!";
                        messageType = "success";
                    } catch (Exception e) {
                        message = "Failed to submit review: " + e.getMessage();
                        messageType = "error";
                    }
                }
            }
            
            if (productId == null || productId.isEmpty()) {
                out.println("<p>Invalid product id. Please try again.</p>");
            } else {
                
                String sql = "SELECT product.*, category.categoryName " +
                            "FROM product JOIN category ON product.categoryId = category.categoryId " +
                            "WHERE productId = ?";
                
                PreparedStatement pstmt = con.prepareStatement(sql);
                pstmt.setString(1, productId);
                
                ResultSet rst = pstmt.executeQuery();
                
                if (rst.next()) {
                    String productName = rst.getString("productName");
                    double productPrice = rst.getDouble("productPrice");
                    String productDesc = rst.getString("productDesc");
                    String categoryName = rst.getString("categoryName");
                    String productImageURL = rst.getString("productImageURL");
                    int categoryId = rst.getInt("categoryId");
                    
                    String addCartURL = "addcart.jsp?id=" + productId + "&name=" + URLEncoder.encode(productName, StandardCharsets.UTF_8) + "&price=" + productPrice;
        %>
                    <div class="product-details">
                        <div class="product-image-container">
                            <img src="<%= productImageURL %>" alt="<%= productName %>" class="product-image" onerror="this.src='img/default.jpg'">
                        </div>
                        <div class="product-info">
                            <h1 class="product-name"><%= productName %></h1>
                            <div class="product-price"><%= NumberFormat.getCurrencyInstance().format(productPrice) %></div>
                            <p class="product-description"><%= productDesc != null ? productDesc : "No description available." %></p>
                            
                            <div class="product-meta">
                                <div class="meta-item">
                                    <span class="meta-label">Category</span>
                                    <span class="meta-value"><%= categoryName %></span>
                                </div>
                            </div>
                            
                            <a href="<%= addCartURL %>" class="add-to-cart">Add to Cart</a>
                        </div>
                    </div>

                    <!-- Reviews Section -->
                    <div class="reviews-section">
                        <h2>Customer Reviews</h2>
                        
                        <% if (!message.isEmpty()) { %>
                            <div class="<%= messageType %>-message">
                                <%= message %>
                            </div>
                        <% } %>
                        
                        <%
                        // Get average rating
                        String avgRatingSql = "SELECT AVG(CAST(reviewRating AS FLOAT)) as avgRating, COUNT(*) as totalReviews FROM review WHERE productId = ?";
                        PreparedStatement avgStmt = con.prepareStatement(avgRatingSql);
                        avgStmt.setString(1, productId);
                        ResultSet avgRst = avgStmt.executeQuery();
                        
                        if (avgRst.next()) {
                            double avgRating = avgRst.getDouble("avgRating");
                            int totalReviews = avgRst.getInt("totalReviews");
                            if (totalReviews > 0) {
                        %>
                            <div class="rating-summary">
                                <div class="average-rating">
                                    <span class="rating-number"><%= String.format("%.1f", avgRating) %></span>
                                    <span class="rating-stars">
                                        <% for (int i = 1; i <= 5; i++) { %>
                                            <i class="fas fa-star<%= i <= avgRating ? "" : "-o" %>"></i>
                                        <% } %>
                                    </span>
                                </div>
                                <div class="total-reviews">
                                    Based on <%= totalReviews %> review<%= totalReviews != 1 ? "s" : "" %>
                                </div>
                            </div>
                        <%
                            }
                        }
                        
                        // Check if user is logged in
                        if (userId != null) {
                        %>
                            <div class="add-review">
                                <h3>Write a Review</h3>
                                <form method="POST" class="review-form">
                                    <div class="rating-input">
                                        <label>Rating:</label>
                                        <select name="rating" required>
                                            <option value="5">5 - Excellent</option>
                                            <option value="4">4 - Very Good</option>
                                            <option value="3">3 - Good</option>
                                            <option value="2">2 - Fair</option>
                                            <option value="1">1 - Poor</option>
                                        </select>
                                    </div>
                                    <div class="comment-input">
                                        <label>Your Review:</label>
                                        <textarea name="comment" required maxlength="1000" rows="4"></textarea>
                                    </div>
                                    <button type="submit" class="submit-review">Submit Review</button>
                                </form>
                            </div>
                        <%
                        } else {
                        %>
                            <p class="login-prompt">Please <a href="login.jsp">log in</a> to write a review.</p>
                        <%
                        }
                        
                        // Display existing reviews
                        String reviewsSql = "SELECT r.*, c.firstName, c.lastName FROM review r JOIN customer c ON r.customerId = c.customerId WHERE r.productId = ? ORDER BY r.reviewDate DESC";
                        PreparedStatement reviewsStmt = con.prepareStatement(reviewsSql);
                        reviewsStmt.setString(1, productId);
                        ResultSet reviewsRst = reviewsStmt.executeQuery();
                        
                        // Debug output
                        out.println("<!-- Debug: Checking for reviews for product ID: " + productId + " -->");
                        int reviewCount = 0;
                        %>
                        
                        <div class="reviews-list">
                            <% 
                            while (reviewsRst.next()) { 
                                reviewCount++;
                                // Debug output for each review
                                out.println("<!-- Debug: Found review " + reviewCount + " -->");
                            %>
                                <div class="review-item">
                                    <div class="review-header">
                                        <div class="reviewer-name">
                                            <%= reviewsRst.getString("firstName") + " " + reviewsRst.getString("lastName").charAt(0) + "." %>
                                        </div>
                                        <div class="review-rating">
                                            <% for (int i = 1; i <= 5; i++) { %>
                                                <i class="fas fa-star<%= i <= reviewsRst.getInt("reviewRating") ? "" : "-o" %>"></i>
                                            <% } %>
                                        </div>
                                        <div class="review-date">
                                            <%= new SimpleDateFormat("MMM d, yyyy").format(reviewsRst.getTimestamp("reviewDate")) %>
                                        </div>
                                    </div>
                                    <div class="review-comment">
                                        <%= reviewsRst.getString("reviewComment") %>
                                    </div>
                                </div>
                            <% } 
                            // Debug output for total reviews found
                            out.println("<!-- Debug: Total reviews found: " + reviewCount + " -->");
                            if (reviewCount == 0) {
                            %>
                                <p>No reviews yet. Be the first to review this product!</p>
                            <%
                            }
                            %>
                        </div>
                    </div>
        <%
                }
                closeConnection();
            }
        %>
    </main>
</body>
</html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartmart.model.User" %>
<%
    User u = (User) session.getAttribute("user");
    if (u == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - SmartMart</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .checkout-layout { max-width: 700px; margin: 2rem auto; padding: 0 1.5rem; }
        .checkout-card { background: var(--bg-card); border: 1px solid var(--border); border-radius: var(--radius-lg); padding: 2rem; }
    </style>
</head>
<body>

<header class="site-header">
    <div class="header-inner">
        <a href="index.jsp" class="logo"><i class="fas fa-shopping-cart"></i> SmartMart</a>
        <nav class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="products.jsp">Products</a>
        </nav>
        <div class="header-actions">
            <a href="profile.jsp" class="profile-circle"><%= u.getFirstName().substring(0,1) %></a>
        </div>
    </div>
</header>

<div class="checkout-layout">
    <h2>Checkout</h2>

    <% if (request.getAttribute("checkoutError") != null) { %>
    <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${checkoutError}</div>
    <% } %>

    <div class="checkout-card">
        <h3 style="margin-bottom:1.5rem;"><i class="fas fa-map-marker-alt" style="color:var(--primary);"></i> Delivery Details</h3>
        <form action="CheckoutServlet" method="post">
            <div class="form-group">
                <label class="form-label">Full Name</label>
                <input type="text" class="form-control" value="<%= u.getFirstName() + " " + u.getLastName() %>" readonly style="background:#f9fafb;">
            </div>
            <div class="form-group">
                <label class="form-label">Phone</label>
                <input type="text" class="form-control" value="<%= u.getPhone() %>" readonly style="background:#f9fafb;">
            </div>
            <div class="form-group">
                <label class="form-label">Delivery Address *</label>
                <textarea name="deliveryAddress" class="form-control" rows="3"
                          placeholder="Enter your full delivery address..." required></textarea>
            </div>
            <div class="form-group">
                <label class="form-label">Payment Method</label>
                <div style="display:flex; gap:1rem; flex-wrap:wrap;">
                    <label style="display:flex; align-items:center; gap:0.5rem; cursor:pointer; padding:0.75rem 1rem; border:1px solid var(--border); border-radius:var(--radius); flex:1;">
                        <input type="radio" name="payment" value="cod" checked> Cash on Delivery
                    </label>
                </div>
            </div>
            <div style="display:flex; gap:1rem; margin-top:1rem;">
                <a href="CartServlet" class="btn btn-outline" style="flex:1; padding:0.9rem;">
                    <i class="fas fa-arrow-left"></i> Back to Cart
                </a>
                <button type="submit" class="btn btn-primary" style="flex:1; padding:0.9rem;">
                    <i class="fas fa-check"></i> Place Order
                </button>
            </div>
        </form>
    </div>
</div>

<footer class="site-footer">
    <div class="footer-bottom"><p>&copy; 2026 SmartMart. All rights reserved.</p></div>
</footer>
</body>
</html>

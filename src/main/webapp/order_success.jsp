<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Placed - SmartMart</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .success-container { max-width: 600px; margin: 4rem auto; padding: 0 1.5rem; text-align: center; }
        .success-icon { width: 100px; height: 100px; background: #d1fae5; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 2rem; font-size: 3rem; color: var(--success); }
    </style>
</head>
<body>

<header class="site-header">
    <div class="header-inner">
        <a href="index.jsp" class="logo"><i class="fas fa-shopping-cart"></i> SmartMart</a>
    </div>
</header>

<div class="success-container">
    <div class="success-icon"><i class="fas fa-check"></i></div>
    <h1 style="color:var(--success); margin-bottom:0.75rem;">Order Placed!</h1>
    <p style="color:var(--text-muted); font-size:1.1rem; margin-bottom:0.5rem;">
        Thank you for your order. Your order has been received and is being processed.
    </p>
    <% if (request.getAttribute("orderId") != null) { %>
    <p style="font-weight:600; margin-bottom:2rem;">Order ID: #<%= request.getAttribute("orderId") %></p>
    <% } %>
    <% if (request.getAttribute("orderTotal") != null) { %>
    <p style="color:var(--text-muted); margin-bottom:2rem;">
        Total: Rs <%= String.format("%.2f", (Double) request.getAttribute("orderTotal")) %>
    </p>
    <% } %>
    <div style="display:flex; gap:1rem; justify-content:center; flex-wrap:wrap;">
        <a href="my_orders.jsp" class="btn btn-primary"><i class="fas fa-list"></i> View My Orders</a>
        <a href="products.jsp" class="btn btn-outline"><i class="fas fa-shopping-bag"></i> Continue Shopping</a>
    </div>
</div>

<footer class="site-footer">
    <div class="footer-bottom"><p>&copy; 2026 SmartMart. All rights reserved.</p></div>
</footer>
</body>
</html>

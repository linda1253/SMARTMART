<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartmart.model.Product, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - SmartMart</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .cart-layout { max-width: 1100px; margin: 2rem auto; padding: 0 1.5rem; display: flex; gap: 2rem; align-items: flex-start; }
        .cart-items { flex: 1.5; }
        .cart-summary { flex: 1; background: var(--bg-card); border: 1px solid var(--border); border-radius: var(--radius-lg); padding: 1.5rem; position: sticky; top: 90px; }
        .cart-row { display: flex; align-items: center; gap: 1rem; padding: 1rem 0; border-bottom: 1px solid var(--border); }
        .cart-row:last-child { border-bottom: none; }
        .cart-product-img { width: 70px; height: 70px; background: var(--bg-main); border-radius: var(--radius); display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
        .cart-product-name { font-weight: 600; font-size: 0.95rem; margin-bottom: 0.25rem; }
        .cart-product-price { color: var(--text-muted); font-size: 0.85rem; }
        .qty-mini { display: flex; border: 1px solid var(--border); border-radius: var(--radius); overflow: hidden; }
        .qty-mini button { width: 30px; height: 30px; background: none; border: none; cursor: pointer; font-size: 0.8rem; }
        .qty-mini button:hover { background: var(--bg-main); }
        .qty-mini input { width: 40px; text-align: center; border: none; border-left: 1px solid var(--border); border-right: 1px solid var(--border); font-size: 0.85rem; }
        .summary-row { display: flex; justify-content: space-between; padding: 0.6rem 0; font-size: 0.9rem; }
        .summary-row.total { font-weight: 700; font-size: 1.1rem; border-top: 1px solid var(--border); padding-top: 1rem; margin-top: 0.5rem; }
        @media (max-width: 768px) { .cart-layout { flex-direction: column; } .cart-summary { position: static; width: 100%; } }
    </style>
</head>
<body>

<header class="site-header">
    <div class="header-inner">
        <a href="index.jsp" class="logo"><i class="fas fa-shopping-cart"></i> SmartMart</a>
        <nav class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="products.jsp">Products</a>
            <a href="about.jsp">About</a>
            <a href="contact.jsp">Contact</a>
        </nav>
        <div class="header-actions">
            <a href="CartServlet" class="header-icon">
                <i class="fas fa-shopping-bag"></i>
                <c:if test="${not empty sessionScope.cart}">
                    <span class="cart-count">${sessionScope.cart.size()}</span>
                </c:if>
            </a>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="profile.jsp" class="profile-circle">${sessionScope.user.firstName.substring(0,1)}</a>
                </c:when>
                <c:otherwise>
                    <a href="login.jsp" class="btn btn-dark btn-sm">Login</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<div style="max-width:1100px; margin:1.5rem auto; padding:0 1.5rem;">
    <h2 style="margin-bottom:0;">Shopping Cart</h2>
</div>

<% String checkoutError = (String) request.getAttribute("checkoutError");
   if (checkoutError != null) { %>
<div style="max-width:1100px; margin:0 auto 1.5rem auto; padding:1rem 1.5rem; background:#fee2e2; color:#b91c1c; border-radius:var(--radius); border:1px solid #f87171;">
    <i class="fas fa-exclamation-circle"></i> <%= checkoutError %>
</div>
<% } %>

<div class="cart-layout">
    <%
        List<int[]>   cart         = (List<int[]>)   request.getAttribute("cart");
        List<Product> cartProducts = (List<Product>) request.getAttribute("cartProducts");
        Double        cartTotal    = (Double)         request.getAttribute("cartTotal");
        if (cart == null || cart.isEmpty()) {
    %>
    <div style="flex:1; text-align:center; padding:4rem; color:var(--text-muted);">
        <i class="fas fa-shopping-cart fa-4x" style="margin-bottom:1rem; opacity:0.3;"></i>
        <h3>Your cart is empty</h3>
        <p style="margin-bottom:1.5rem;">Add some products to get started.</p>
        <a href="products.jsp" class="btn btn-primary">Browse Products</a>
    </div>
    <% } else { 
           boolean hasStockIssue = false;
    %>
    <div class="cart-items card">
        <h3 style="margin-bottom:1rem;">Cart Items (<%= cart.size() %>)</h3>
        <% for (int i = 0; i < cart.size(); i++) {
            int[] entry = cart.get(i);
            Product p   = cartProducts.get(i);
            int qty     = entry[1];
        %>
        <div class="cart-row">
            <div class="cart-product-img">
                <i class="fas fa-box" style="color:#d1d5db;"></i>
            </div>
            <div style="flex:1;">
                <p class="cart-product-name"><%= p.getProductName() %></p>
                <p class="cart-product-price">Rs <%= String.format("%.2f", p.getPrice()) %> each</p>
                <% if (qty > p.getStock()) { hasStockIssue = true; %>
                <p style="color:var(--danger); font-size:0.8rem; margin-top:0.25rem;">
                    <i class="fas fa-exclamation-triangle"></i> Insufficient stock (Available: <%= p.getStock() %>)
                </p>
                <% } %>
            </div>
            <form action="CartServlet" method="post" style="display:flex; align-items:center; gap:0.5rem;">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                <div class="qty-mini">
                    <button type="button" onclick="this.form.quantity.value=Math.max(1,parseInt(this.form.quantity.value)-1)">-</button>
                    <input type="number" name="quantity" value="<%= qty %>" min="1" max="<%= p.getStock() %>">
                    <button type="button" onclick="this.form.quantity.value=Math.min(<%= p.getStock() %>,parseInt(this.form.quantity.value)+1)">+</button>
                </div>
                <button type="submit" class="btn btn-outline btn-xs">Update</button>
            </form>
            <p style="font-weight:700; min-width:80px; text-align:right;">
                Rs <%= String.format("%.2f", p.getPrice() * qty) %>
            </p>
            <form action="CartServlet" method="post">
                <input type="hidden" name="action" value="remove">
                <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                <button type="submit" class="btn btn-danger btn-xs"><i class="fas fa-trash"></i></button>
            </form>
        </div>
        <% } %>
        <div style="margin-top:1rem; display:flex; justify-content:space-between;">
            <a href="products.jsp" class="btn btn-outline btn-sm"><i class="fas fa-arrow-left"></i> Continue Shopping</a>
            <form action="CartServlet" method="post">
                <input type="hidden" name="action" value="clear">
                <button type="submit" class="btn btn-danger btn-sm"><i class="fas fa-trash"></i> Clear Cart</button>
            </form>
        </div>
    </div>

    <div class="cart-summary">
        <h3 style="margin-bottom:1.25rem;">Order Summary</h3>
        <div class="summary-row"><span>Subtotal</span><span>Rs <%= String.format("%.2f", cartTotal) %></span></div>
        <div class="summary-row"><span>Delivery</span><span><%= cartTotal > 1250 ? "Free" : "Rs 100.00" %></span></div>
        <div class="summary-row total">
            <span>Total</span>
            <span>Rs <%= String.format("%.2f", cartTotal + (cartTotal > 1250 ? 0 : 100)) %></span>
        </div>
        <% if (hasStockIssue) { %>
        <div style="color:var(--danger); font-size:0.85rem; margin-top:1rem; text-align:center;">
            Please resolve stock issues to checkout.
        </div>
        <button disabled class="btn btn-secondary" style="width:100%; margin-top:0.5rem; padding:0.9rem; cursor:not-allowed; opacity:0.6;">
            <i class="fas fa-lock"></i> Proceed to Checkout
        </button>
        <% } else { %>
        <a href="checkout.jsp" class="btn btn-primary" style="width:100%; margin-top:1.25rem; padding:0.9rem;">
            <i class="fas fa-lock"></i> Proceed to Checkout
        </a>
        <% } %>
    </div>
    <% } %>
</div>

<footer class="site-footer">
    <div class="footer-bottom"><p>&copy; 2026 SmartMart. All rights reserved.</p></div>
</footer>
</body>
</html>

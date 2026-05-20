<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartmart.dao.ProductDAO, com.smartmart.model.Product" %>
<%
    String idParam = request.getParameter("id");
    Product product = null;
    if (idParam != null && !idParam.isEmpty()) {
        product = new ProductDAO().getProductById(Integer.parseInt(idParam));
    }
    if (product == null) {
        response.sendRedirect("products.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= product.getProductName() %> - SmartMart</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .detail-layout { max-width: 1000px; margin: 3rem auto; padding: 0 1.5rem; display: flex; gap: 3rem; }
        .detail-image { flex: 1; background: var(--bg-card); border: 1px solid var(--border); border-radius: var(--radius-lg); height: 380px; display: flex; align-items: center; justify-content: center; }
        .detail-info { flex: 1.2; }
        .detail-info .category { color: var(--text-muted); font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.5rem; }
        .detail-info h1 { font-size: 1.75rem; margin-bottom: 0.75rem; }
        .detail-info .price { font-size: 2rem; font-weight: 800; color: var(--primary); margin-bottom: 1rem; }
        .detail-info .description { color: var(--text-muted); margin-bottom: 1.5rem; line-height: 1.7; }
        .qty-row { display: flex; align-items: center; gap: 1rem; margin-bottom: 1.5rem; }
        .qty-control { display: flex; border: 1px solid var(--border); border-radius: var(--radius); overflow: hidden; }
        .qty-control button { width: 38px; height: 38px; background: none; border: none; cursor: pointer; font-size: 1rem; transition: var(--transition); }
        .qty-control button:hover { background: var(--bg-main); color: var(--primary); }
        .qty-control input { width: 50px; text-align: center; border: none; border-left: 1px solid var(--border); border-right: 1px solid var(--border); font-family: var(--font); font-weight: 600; }
        @media (max-width: 768px) { .detail-layout { flex-direction: column; } }
    </style>
</head>
<body>

<header class="site-header">
    <div class="header-inner">
        <a href="index.jsp" class="logo"><i class="fas fa-shopping-cart"></i> SmartMart</a>
        <nav class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="products.jsp" class="active">Products</a>
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

<!-- Breadcrumb -->
<div style="max-width:1000px; margin:1.5rem auto; padding:0 1.5rem; font-size:0.875rem; color:var(--text-muted);">
    <a href="index.jsp" style="color:var(--primary);">Home</a> /
    <a href="products.jsp" style="color:var(--primary);">Products</a> /
    <span><%= product.getProductName() %></span>
</div>

<div class="detail-layout">
    <div class="detail-image">
        <i class="fas fa-box fa-6x" style="color:#d1d5db;"></i>
    </div>
    <div class="detail-info">
        <p class="category"><%= product.getCategoryName() %></p>
        <h1><%= product.getProductName() %></h1>
        <p class="price">Rs <%= String.format("%.2f", product.getPrice()) %></p>


        <% if (product.getStock() > 0) { %>
        <p style="color:var(--success); font-weight:600; margin-bottom:1rem;">
            <i class="fas fa-check-circle"></i> In Stock (<%= product.getStock() %> available)
        </p>
        <form action="CartServlet" method="post">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="productId" value="<%= product.getProductId() %>">
            <div class="qty-row">
                <label style="font-weight:600;">Quantity:</label>
                <div class="qty-control">
                    <button type="button" onclick="changeQty(-1)"><i class="fas fa-minus"></i></button>
                    <input type="number" name="quantity" id="qty" value="1" min="1" max="<%= product.getStock() %>">
                    <button type="button" onclick="changeQty(1)"><i class="fas fa-plus"></i></button>
                </div>
            </div>
            <div style="display:flex; gap:1rem; flex-wrap:wrap;">
                <button type="submit" class="btn btn-primary" style="flex:1; padding:0.9rem;">
                    <i class="fas fa-cart-plus"></i> Add to Cart
                </button>
                <a href="products.jsp" class="btn btn-outline" style="flex:1; padding:0.9rem;">
                    <i class="fas fa-arrow-left"></i> Back
                </a>
            </div>
        </form>
        <% } else { %>
        <span class="badge badge-danger" style="font-size:0.9rem; padding:0.5rem 1rem;">Out of Stock</span>
        <% } %>
    </div>
</div>

<footer class="site-footer">
    <div class="footer-bottom"><p>&copy; 2026 SmartMart. All rights reserved.</p></div>
</footer>

<script>
function changeQty(delta) {
    const input = document.getElementById('qty');
    const max = parseInt(input.max);
    let val = parseInt(input.value) + delta;
    if (val < 1) val = 1;
    if (val > max) val = max;
    input.value = val;
}
</script>
</body>
</html>

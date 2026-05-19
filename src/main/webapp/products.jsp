<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartmart.dao.ProductDAO, com.smartmart.dao.CategoryDAO, com.smartmart.model.Product, com.smartmart.model.Category, java.util.List" %>
<%
    ProductDAO  pDao = new ProductDAO();
    CategoryDAO cDao = new CategoryDAO();
    String catParam = request.getParameter("categoryId");
    List<Product>  products   = (catParam != null && !catParam.isEmpty())
                                ? pDao.getProductsByCategory(Integer.parseInt(catParam))
                                : pDao.getAllProducts();
    List<Category> categories = cDao.getAllCategories();
    int selectedCat = (catParam != null && !catParam.isEmpty()) ? Integer.parseInt(catParam) : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - SmartMart</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .page-layout { display: flex; gap: 2rem; max-width: 1280px; margin: 0 auto; padding: 2rem 1.5rem; }
        .sidebar-filter { width: 240px; flex-shrink: 0; }
        .filter-card { background: var(--bg-card); border: 1px solid var(--border); border-radius: var(--radius-lg); padding: 1.5rem; margin-bottom: 1rem; }
        .filter-card h4 { font-size: 0.9rem; text-transform: uppercase; letter-spacing: 0.05em; color: var(--text-muted); margin-bottom: 1rem; }
        .filter-item { display: flex; align-items: center; gap: 0.5rem; padding: 0.5rem 0.75rem; border-radius: var(--radius); cursor: pointer; transition: var(--transition); font-size: 0.9rem; text-decoration: none; color: var(--text-main); }
        .filter-item:hover { background: var(--bg-main); color: var(--primary); }
        .filter-item.active { background: #f0f4f1; color: var(--primary); font-weight: 600; }
        .products-area { flex: 1; }
        .products-toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; }
        .products-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.5rem; }
        @media (max-width: 1024px) { .products-grid { grid-template-columns: repeat(2, 1fr); } }
        @media (max-width: 768px) { .sidebar-filter { display: none; } .products-grid { grid-template-columns: repeat(2, 1fr); } }
        @media (max-width: 480px) { .products-grid { grid-template-columns: 1fr; } }
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

<div class="page-layout">
    <!-- Sidebar filter -->
    <aside class="sidebar-filter">
        <div class="filter-card">
            <h4>Categories</h4>
            <a href="products.jsp" class="filter-item <%= selectedCat == 0 ? "active" : "" %>">
                <i class="fas fa-th"></i> All Products
            </a>
            <% for (Category cat : categories) { %>
            <a href="products.jsp?categoryId=<%= cat.getCategoryId() %>"
               class="filter-item <%= selectedCat == cat.getCategoryId() ? "active" : "" %>">
                <i class="fas fa-tag"></i> <%= cat.getCategoryName() %>
            </a>
            <% } %>
        </div>
    </aside>

    <!-- Products area -->
    <div class="products-area">
        <div class="products-toolbar">
            <p style="color:var(--text-muted); font-size:0.9rem;">
                Showing <strong><%= products.size() %></strong> products
            </p>
        </div>

        <% if (products.isEmpty()) { %>
        <div style="text-align:center; padding:4rem; color:var(--text-muted);">
            <i class="fas fa-box-open fa-4x" style="margin-bottom:1rem; opacity:0.3;"></i>
            <p>No products found in this category.</p>
        </div>
        <% } else { %>
        <div class="products-grid">
            <% for (Product p : products) { %>
            <div class="product-card">
                <div class="product-img">
                    <i class="fas fa-box fa-3x" style="color:#d1d5db;"></i>
                </div>
                <div class="product-info">
                    <p class="product-category"><%= p.getCategoryName() %></p>
                    <h3 class="product-title"><%= p.getProductName() %></h3>
                    <p class="product-price">Rs <%= String.format("%.2f", p.getPrice()) %></p>
                    <% if (p.getStock() > 0) { %>
                    <div style="display:flex; gap:0.5rem;">
                        <form action="CartServlet" method="post" style="flex:1;">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                            <button type="submit" class="btn btn-primary btn-sm" style="width:100%;">
                                <i class="fas fa-cart-plus"></i> Add to Cart
                            </button>
                        </form>
                        <a href="product_detail.jsp?id=<%= p.getProductId() %>" class="btn btn-outline btn-sm">
                            <i class="fas fa-eye"></i>
                        </a>
                    </div>
                    <% } else { %>
                    <span class="badge badge-danger">Out of Stock</span>
                    <% } %>
                </div>
            </div>
            <% } %>
        </div>
        <% } %>
    </div>
</div>

<footer class="site-footer">
    <div class="footer-grid">
        <div class="footer-col"><div class="logo" style="margin-bottom:1rem;"><i class="fas fa-shopping-cart"></i> SmartMart</div><p>Quality products at affordable prices.</p></div>
        <div class="footer-col"><h4>Quick Links</h4><a href="index.jsp">Home</a><a href="products.jsp">Products</a><a href="contact.jsp">Contact</a></div>
        <div class="footer-col"><h4>Support</h4><a href="#">Shipping</a><a href="#">Returns</a><a href="#">FAQ</a></div>
        <div class="footer-col"><h4>Contact</h4><p>support@smartmart.com</p><p>+977-9800000001</p></div>
    </div>
    <div class="footer-bottom"><p>&copy; 2026 SmartMart. All rights reserved.</p></div>
</footer>
</body>
</html>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartmart.dao.ProductDAO, com.smartmart.dao.CategoryDAO, com.smartmart.model.Product, com.smartmart.model.Category, java.util.List" %>
<%
    ProductDAO  pDao = new ProductDAO();
    CategoryDAO cDao = new CategoryDAO();
    List<Product>  featuredProducts = pDao.getAllProducts();
    List<Category> categories       = cDao.getAllCategories();
    // Limit to 8 featured products
    if (featuredProducts.size() > 8) featuredProducts = featuredProducts.subList(0, 8);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SmartMart - Department Store</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .hero { background: var(--secondary); color: white; padding: 5rem 0; }
        .hero-inner { max-width: 1280px; margin: 0 auto; padding: 0 1.5rem; display: flex; align-items: center; gap: 4rem; }
        .hero-text h1 { color: white; font-size: 3rem; line-height: 1.1; margin-bottom: 1.25rem; }
        .hero-text h1 span { color: var(--primary); }
        .hero-text p { color: rgba(255,255,255,0.75); font-size: 1.1rem; margin-bottom: 2rem; }
        .hero-image { flex: 1; min-width: 300px; height: 320px; background: rgba(255,255,255,0.05); border-radius: var(--radius-lg); display: flex; align-items: center; justify-content: center; border: 2px dashed rgba(255,255,255,0.15); }
        .section { padding: 4rem 0; }
        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        .section-header h2 { margin-bottom: 0; }
        .category-grid { display: grid; grid-template-columns: repeat(5, 1fr); gap: 1rem; }
        .category-card { background: var(--bg-card); border: 1px solid var(--border); border-radius: var(--radius-lg); padding: 1.5rem 1rem; text-align: center; cursor: pointer; transition: var(--transition); }
        .category-card:hover { border-color: var(--primary); box-shadow: var(--shadow-md); transform: translateY(-3px); }
        .category-card i { font-size: 2rem; color: var(--primary); margin-bottom: 0.75rem; display: block; }
        .category-card span { font-size: 0.875rem; font-weight: 600; color: var(--secondary); }
        .products-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1.5rem; }
        .features-bar { background: var(--bg-card); border-top: 1px solid var(--border); border-bottom: 1px solid var(--border); padding: 2rem 0; }
        .features-inner { max-width: 1280px; margin: 0 auto; padding: 0 1.5rem; display: grid; grid-template-columns: repeat(4, 1fr); gap: 1.5rem; }
        .feature-item { display: flex; align-items: center; gap: 1rem; }
        .feature-item i { font-size: 1.75rem; color: var(--primary); }
        .feature-item h4 { font-size: 0.9rem; margin-bottom: 0.15rem; }
        .feature-item p { font-size: 0.8rem; color: var(--text-muted); }
        @media (max-width: 1024px) { .category-grid { grid-template-columns: repeat(3, 1fr); } .products-grid { grid-template-columns: repeat(3, 1fr); } }
        @media (max-width: 768px) { .hero-image { display: none; } .category-grid { grid-template-columns: repeat(2, 1fr); } .products-grid { grid-template-columns: repeat(2, 1fr); } .features-inner { grid-template-columns: repeat(2, 1fr); } }
        @media (max-width: 480px) { .products-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>

<!-- ── Header ─────────────────────────────────────────────── -->
<header class="site-header">
    <div class="header-inner">
        <a href="index.jsp" class="logo"><i class="fas fa-shopping-cart"></i> SmartMart</a>
        <nav class="nav-links">
            <a href="index.jsp" class="active">Home</a>
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
                    <a href="profile.jsp" class="profile-circle" title="${sessionScope.user.firstName}">
                        ${sessionScope.user.firstName.substring(0,1)}
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="login.jsp" class="btn btn-dark btn-sm">Login</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<!-- ── Hero ───────────────────────────────────────────────── -->
<section class="hero">
    <div class="hero-inner">
        <div class="hero-text" style="flex:1.2;">
            <h1>Shop Smart,<br>Live <span>Better</span></h1>
            <p>Your one-stop department store for groceries, clothing, household essentials and more — all at unbeatable prices.</p>
            <div style="display:flex; gap:1rem; flex-wrap:wrap;">
                <a href="products.jsp" class="btn btn-primary" style="padding:0.9rem 2rem;">
                    <i class="fas fa-shopping-bag"></i> Shop Now
                </a>
                <a href="about.jsp" class="btn btn-outline" style="padding:0.9rem 2rem; color:white; border-color:rgba(255,255,255,0.3);">
                    Learn More
                </a>
            </div>
        </div>
        <div class="hero-image">
            <i class="fas fa-store fa-5x" style="color:rgba(255,255,255,0.15);"></i>
        </div>
    </div>
</section>

<!-- ── Features bar ───────────────────────────────────────── -->
<div class="features-bar">
    <div class="features-inner">
        <div class="feature-item"><i class="fas fa-truck"></i><div><h4>Free Delivery</h4><p>On orders over Rs 1,250</p></div></div>
        <div class="feature-item"><i class="fas fa-shield-alt"></i><div><h4>Secure Payment</h4><p>100% secure transactions</p></div></div>
        <div class="feature-item"><i class="fas fa-undo"></i><div><h4>Easy Returns</h4><p>7-day return policy</p></div></div>
        <div class="feature-item"><i class="fas fa-headset"></i><div><h4>24/7 Support</h4><p>Always here to help</p></div></div>
    </div>
</div>

<!-- ── Categories ─────────────────────────────────────────── -->
<section class="section" style="background:var(--bg-card);">
    <div class="container">
        <div class="section-header">
            <h2>Shop by Category</h2>
            <a href="products.jsp" style="color:var(--primary); font-weight:600; font-size:0.9rem;">View all <i class="fas fa-arrow-right"></i></a>
        </div>
        <div class="category-grid">
            <% for (Category cat : categories) { %>
            <a href="products.jsp?categoryId=<%= cat.getCategoryId() %>" class="category-card" style="text-decoration:none;">
                <i class="fas fa-tag"></i>
                <span><%= cat.getCategoryName() %></span>
            </a>
            <% } %>
        </div>
    </div>
</section>

<!-- ── Featured Products ──────────────────────────────────── -->
<section class="section">
    <div class="container">
        <div class="section-header">
            <h2>Featured Products</h2>
            <a href="products.jsp" style="color:var(--primary); font-weight:600; font-size:0.9rem;">View all <i class="fas fa-arrow-right"></i></a>
        </div>
        <div class="products-grid">
            <% for (Product p : featuredProducts) { %>
            <div class="product-card">
                <div class="product-img">
                    <i class="fas fa-box fa-3x" style="color:#d1d5db;"></i>
                </div>
                <div class="product-info">
                    <p class="product-category"><%= p.getCategoryName() %></p>
                    <h3 class="product-title"><%= p.getProductName() %></h3>
                    <p class="product-price">Rs <%= String.format("%.2f", p.getPrice()) %></p>
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
                </div>
            </div>
            <% } %>
        </div>
    </div>
</section>

<!-- ── Footer ─────────────────────────────────────────────── -->
<footer class="site-footer">
    <div class="footer-grid">
        <div class="footer-col">
            <div class="logo" style="margin-bottom:1rem;"><i class="fas fa-shopping-cart"></i> SmartMart</div>
            <p>Your trusted department store for quality products at affordable prices.</p>
            <div class="social-links">
                <a href="#"><i class="fab fa-facebook-f"></i></a>
                <a href="#"><i class="fab fa-instagram"></i></a>
                <a href="#"><i class="fab fa-twitter"></i></a>
            </div>
        </div>
        <div class="footer-col">
            <h4>Quick Links</h4>
            <a href="index.jsp">Home</a>
            <a href="products.jsp">Products</a>
            <a href="about.jsp">About Us</a>
            <a href="contact.jsp">Contact</a>
        </div>
        <div class="footer-col">
            <h4>Customer Service</h4>
            <a href="#">Shipping & Delivery</a>
            <a href="#">Returns Policy</a>
            <a href="#">FAQ</a>
            <a href="#">Track Order</a>
        </div>
        <div class="footer-col">
            <h4>Contact Us</h4>
            <p><i class="fas fa-map-marker-alt" style="color:var(--primary);margin-right:0.5rem;"></i> Kathmandu, Nepal</p>
            <p><i class="fas fa-phone" style="color:var(--primary);margin-right:0.5rem;"></i> +977-9800000001</p>
            <p><i class="fas fa-envelope" style="color:var(--primary);margin-right:0.5rem;"></i> support@smartmart.com</p>
        </div>
    </div>
    <div class="footer-bottom">
        <p>&copy; 2026 SmartMart Department Store. All rights reserved.</p>
    </div>
</footer>

</body>
</html>

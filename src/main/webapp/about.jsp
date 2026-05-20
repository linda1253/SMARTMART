<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - SmartMart</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .about-hero { background: var(--secondary); color: white; padding: 4rem 0; text-align: center; }
        .about-hero h1 { color: white; margin-bottom: 0.75rem; }
        .about-hero p { color: rgba(255,255,255,0.75); font-size: 1.1rem; }
        .values-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.5rem; margin-top: 2rem; }
        .value-card { text-align: center; padding: 2rem; }
        .value-card i { font-size: 2.5rem; color: var(--primary); margin-bottom: 1rem; display: block; }
        @media (max-width: 768px) { .values-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>

<header class="site-header">
    <div class="header-inner">
        <a href="index.jsp" class="logo"><i class="fas fa-shopping-cart"></i> SmartMart</a>
        <nav class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="products.jsp">Products</a>
            <a href="about.jsp" class="active">About</a>
            <a href="contact.jsp">Contact</a>
        </nav>
        <div class="header-actions">
            <a href="CartServlet" class="header-icon"><i class="fas fa-shopping-bag"></i></a>
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

<div class="about-hero">
    <h1>About SmartMart</h1>
    <p>Your trusted department store since 2020</p>
</div>

<section style="padding:4rem 0; background:var(--bg-card);">
    <div class="container">
        <div style="max-width:700px; margin:0 auto; text-align:center;">
            <h2>Our Story</h2>
            <p style="color:var(--text-muted); font-size:1.05rem; line-height:1.8;">
                SmartMart was founded with a simple mission: to provide quality products at affordable prices to every household in Nepal. From fresh groceries to clothing, household essentials to electronics — we bring everything under one roof so you can shop smarter.
            </p>
        </div>
    </div>
</section>

<section style="padding:4rem 0;">
    <div class="container">
        <h2 style="text-align:center;">Our Values</h2>
        <div class="values-grid">
            <div class="value-card card">
                <i class="fas fa-star"></i>
                <h3>Quality First</h3>
                <p style="color:var(--text-muted);">We source only the best products from trusted sources to ensure you get the quality you deserve.</p>
            </div>
            <div class="value-card card">
                <i class="fas fa-hand-holding-heart"></i>
                <h3>Customer Care</h3>
                <p style="color:var(--text-muted);">Our customers are at the heart of everything we do. We're always here to help and support you.</p>
            </div>
            <div class="value-card card">
                <i class="fas fa-leaf"></i>
                <h3>Sustainability</h3>
                <p style="color:var(--text-muted);">We're committed to sustainable practices and reducing our environmental footprint.</p>
            </div>
        </div>
    </div>
</section>

<section style="padding:4rem 0; background:var(--bg-card);">
    <div class="container" style="text-align:center;">
        <h2>Why Choose SmartMart?</h2>
        <div style="display:grid; grid-template-columns:repeat(4,1fr); gap:2rem; margin-top:2rem;">
            <div><div style="font-size:2.5rem; font-weight:800; color:var(--primary);">5+</div><p style="color:var(--text-muted);">Years in Business</p></div>
            <div><div style="font-size:2.5rem; font-weight:800; color:var(--primary);">500+</div><p style="color:var(--text-muted);">Products</p></div>
            <div><div style="font-size:2.5rem; font-weight:800; color:var(--primary);">10K+</div><p style="color:var(--text-muted);">Happy Customers</p></div>
            <div><div style="font-size:2.5rem; font-weight:800; color:var(--primary);">24/7</div><p style="color:var(--text-muted);">Support</p></div>
        </div>
    </div>
</section>

<footer class="site-footer">
    <div class="footer-grid">
        <div class="footer-col"><div class="logo" style="margin-bottom:1rem;"><i class="fas fa-shopping-cart"></i> SmartMart</div><p>Quality products at affordable prices.</p></div>
        <div class="footer-col"><h4>Quick Links</h4><a href="index.jsp">Home</a><a href="products.jsp">Products</a><a href="contact.jsp">Contact</a></div>
        <div class="footer-col"><h4>Support</h4><a href="#">Shipping</a><a href="#">Returns</a></div>
        <div class="footer-col"><h4>Contact</h4><p>support@smartmart.com</p></div>
    </div>
    <div class="footer-bottom"><p>&copy; 2026 SmartMart. All rights reserved.</p></div>
</footer>
</body>
</html>

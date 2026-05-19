<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - SmartMart</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .contact-layout { max-width: 1100px; margin: 3rem auto; padding: 0 1.5rem; display: grid; grid-template-columns: 1fr 1.5fr; gap: 2rem; }
        .info-item { display: flex; gap: 1rem; margin-bottom: 1.5rem; }
        .info-item .icon { width: 44px; height: 44px; background: #f0f4f1; border-radius: var(--radius); display: flex; align-items: center; justify-content: center; color: var(--primary); font-size: 1.1rem; flex-shrink: 0; }
        .info-item h4 { font-size: 0.9rem; margin-bottom: 0.2rem; }
        .info-item p { color: var(--text-muted); font-size: 0.875rem; }
        @media (max-width: 768px) { .contact-layout { grid-template-columns: 1fr; } }
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
            <a href="contact.jsp" class="active">Contact</a>
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

<div style="background:var(--secondary); color:white; padding:3rem 0; text-align:center;">
    <h1 style="color:white; margin-bottom:0.5rem;">Contact Us</h1>
    <p style="color:rgba(255,255,255,0.7);">We'd love to hear from you</p>
</div>

<div class="contact-layout">
    <div class="card">
        <h3 style="margin-bottom:1.5rem;">Get in Touch</h3>
        <div class="info-item">
            <div class="icon"><i class="fas fa-map-marker-alt"></i></div>
            <div><h4>Address</h4><p>123 Smart Street, Kathmandu, Nepal</p></div>
        </div>
        <div class="info-item">
            <div class="icon"><i class="fas fa-phone"></i></div>
            <div><h4>Phone</h4><p>+977-9800000001</p></div>
        </div>
        <div class="info-item">
            <div class="icon"><i class="fas fa-envelope"></i></div>
            <div><h4>Email</h4><p>support@smartmart.com</p></div>
        </div>
        <div class="info-item">
            <div class="icon"><i class="fas fa-clock"></i></div>
            <div><h4>Hours</h4><p>Mon–Sat: 9AM–9PM<br>Sun: 10AM–6PM</p></div>
        </div>
    </div>

    <div class="card">
        <h3 style="margin-bottom:1.5rem;">Send a Message</h3>
        <form action="#">
            <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;">
                <div class="form-group">
                    <label class="form-label">Your Name</label>
                    <input type="text" class="form-control" placeholder="Full name">
                </div>
                <div class="form-group">
                    <label class="form-label">Email</label>
                    <input type="email" class="form-control" placeholder="your@email.com">
                </div>
            </div>
            <div class="form-group">
                <label class="form-label">Subject</label>
                <input type="text" class="form-control" placeholder="How can we help?">
            </div>
            <div class="form-group">
                <label class="form-label">Message</label>
                <textarea class="form-control" rows="5" placeholder="Write your message here..."></textarea>
            </div>
            <button type="submit" class="btn btn-primary" style="width:100%; padding:0.9rem;">
                <i class="fas fa-paper-plane"></i> Send Message
            </button>
        </form>
    </div>
</div>

<footer class="site-footer">
    <div class="footer-bottom"><p>&copy; 2026 SmartMart. All rights reserved.</p></div>
</footer>
</body>
</html>

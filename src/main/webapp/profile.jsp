<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
    <title>My Profile - SmartMart</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { display: flex; min-height: 100vh; background: var(--bg-main); }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <a href="index.jsp" class="sidebar-brand" style="text-decoration:none; color:inherit;">
        <i class="fas fa-shopping-cart"></i> SmartMart
    </a>
    <ul class="sidebar-menu">
        <li><a href="dashboard_user.jsp"><i class="fas fa-th-large"></i> Dashboard</a></li>
        <li><a href="profile.jsp" class="active"><i class="fas fa-user"></i> My Profile</a></li>
        <li><a href="change_password.jsp"><i class="fas fa-lock"></i> Change Password</a></li>
        <li><a href="my_orders.jsp"><i class="fas fa-shopping-bag"></i> My Orders</a></li>
        <li><a href="products.jsp"><i class="fas fa-store"></i> Shop</a></li>
        <div class="sidebar-divider"></div>
        <li><a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
    </ul>
</div>

<div class="panel-body">
    <div class="panel-header">
        <h3 style="margin:0; font-size:1.1rem;">My Profile</h3>
        <div style="display:flex; align-items:center; gap:0.75rem;">
            <i class="fas fa-user-circle fa-2x" style="color:#cbd5e1;"></i>
            <span style="font-weight:600;"><%= u.getFirstName() %> <%= u.getLastName() %></span>
        </div>
    </div>

    <div class="panel-content">
        <% if (request.getAttribute("profileSuccess") != null) { %>
        <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${profileSuccess}</div>
        <% } %>
        <% if (request.getAttribute("profileError") != null) { %>
        <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${profileError}</div>
        <% } %>

        <div class="card" style="max-width:600px;">
            <h3 style="margin-bottom:1.5rem;"><i class="fas fa-user-edit" style="color:var(--primary);"></i> Edit Profile</h3>
            <form action="ProfileServlet" method="post">
                <input type="hidden" name="action" value="updateProfile">
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;">
                    <div class="form-group">
                        <label class="form-label">First Name</label>
                        <input type="text" name="firstName" class="form-control" value="<%= u.getFirstName() %>" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Last Name</label>
                        <input type="text" name="lastName" class="form-control" value="<%= u.getLastName() %>">
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Email Address</label>
                    <input type="email" name="email" class="form-control" value="<%= u.getEmail() %>" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Phone Number</label>
                    <input type="tel" name="phone" class="form-control" value="<%= u.getPhone() %>">
                </div>
                <div class="form-group">
                    <label class="form-label">Role</label>
                    <input type="text" class="form-control" value="<%= u.getRole() %>" readonly style="background:#f9fafb;">
                </div>
                <button type="submit" class="btn btn-primary" style="width:100%; padding:0.9rem;">
                    <i class="fas fa-save"></i> Save Changes
                </button>
            </form>
        </div>
    </div>
</div>

</body>
</html>

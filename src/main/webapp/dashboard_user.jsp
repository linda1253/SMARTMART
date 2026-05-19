<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartmart.dao.OrderDAO, com.smartmart.model.Order, com.smartmart.model.User, java.util.List" %>
<%
    User u = (User) session.getAttribute("user");
    if (u == null) { response.sendRedirect("login.jsp"); return; }
    OrderDAO oDao = new OrderDAO();
    List<Order> recentOrders = oDao.getOrdersByUser(u.getUserId());
    int totalOrders = recentOrders.size();
    long completedOrders = recentOrders.stream().filter(o -> "Completed".equals(o.getOrderStatus())).count();
    double totalSpent = recentOrders.stream().mapToDouble(Order::getTotalAmount).sum();
    if (recentOrders.size() > 5) recentOrders = recentOrders.subList(0, 5);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - SmartMart</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>body { display: flex; min-height: 100vh; background: var(--bg-main); }</style>
</head>
<body>

<div class="sidebar">
    <a href="index.jsp" class="sidebar-brand" style="text-decoration:none; color:inherit;">
        <i class="fas fa-shopping-cart"></i> SmartMart
    </a>
    <ul class="sidebar-menu">
        <li><a href="dashboard_user.jsp" class="active"><i class="fas fa-th-large"></i> Dashboard</a></li>
        <li><a href="profile.jsp"><i class="fas fa-user"></i> My Profile</a></li>
        <li><a href="change_password.jsp"><i class="fas fa-lock"></i> Change Password</a></li>
        <li><a href="my_orders.jsp"><i class="fas fa-shopping-bag"></i> My Orders</a></li>
        <li><a href="products.jsp"><i class="fas fa-store"></i> Shop</a></li>
        <div class="sidebar-divider"></div>
        <li><a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
    </ul>
</div>

<div class="panel-body">
    <div class="panel-header">
        <h3 style="margin:0; font-size:1.1rem;">Dashboard</h3>
        <div style="display:flex; align-items:center; gap:0.75rem;">
            <i class="fas fa-user-circle fa-2x" style="color:#cbd5e1;"></i>
            <span style="font-weight:600;"><%= u.getFirstName() %> <%= u.getLastName() %></span>
        </div>
    </div>

    <div class="panel-content">
        <p style="color:var(--text-muted); margin-bottom:2rem;">Welcome back, <strong><%= u.getFirstName() %></strong>!</p>

        <div class="stats-grid" style="grid-template-columns:repeat(3,1fr);">
            <div class="stats-card">
                <div class="stats-icon blue"><i class="fas fa-shopping-bag"></i></div>
                <div class="stats-info"><h3>Total Orders</h3><div class="value"><%= totalOrders %></div></div>
            </div>
            <div class="stats-card">
                <div class="stats-icon green"><i class="fas fa-check-circle"></i></div>
                <div class="stats-info"><h3>Completed</h3><div class="value"><%= completedOrders %></div></div>
            </div>
            <div class="stats-card">
                <div class="stats-icon purple"><i class="fas fa-rupee-sign"></i></div>
                <div class="stats-info"><h3>Total Spent</h3><div class="value">Rs <%= String.format("%.0f", totalSpent) %></div></div>
            </div>
        </div>

        <div class="card" style="margin-top:2rem;">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.25rem;">
                <h3 style="margin:0;">Recent Orders</h3>
                <a href="my_orders.jsp" style="color:var(--primary); font-size:0.875rem; font-weight:600;">View All</a>
            </div>
            <% if (recentOrders.isEmpty()) { %>
            <p style="color:var(--text-muted); text-align:center; padding:2rem;">No orders yet. <a href="products.jsp" style="color:var(--primary);">Start shopping!</a></p>
            <% } else { %>
            <div class="table-container">
                <table>
                    <thead><tr><th>Order ID</th><th>Date</th><th>Total</th><th>Status</th></tr></thead>
                    <tbody>
                        <% for (Order o : recentOrders) { %>
                        <tr>
                            <td>#<%= o.getOrderId() %></td>
                            <td><%= o.getOrderDate() != null ? o.getOrderDate().toLocalDate() : "-" %></td>
                            <td>Rs <%= String.format("%.2f", o.getTotalAmount()) %></td>
                            <td>
                                <% String st = o.getOrderStatus(); %>
                                <span class="badge <%= "Completed".equals(st) ? "badge-success" : "Pending".equals(st) ? "badge-warning" : "Cancelled".equals(st) ? "badge-danger" : "badge-info" %>">
                                    <%= st %>
                                </span>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>

        <div style="margin-top:2rem; display:flex; gap:1rem; flex-wrap:wrap;">
            <a href="products.jsp" class="btn btn-primary"><i class="fas fa-shopping-bag"></i> Shop Now</a>
            <a href="profile.jsp" class="btn btn-outline"><i class="fas fa-user-edit"></i> Edit Profile</a>
        </div>
    </div>
</div>

</body>
</html>

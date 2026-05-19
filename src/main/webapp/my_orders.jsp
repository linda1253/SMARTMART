<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartmart.dao.OrderDAO, com.smartmart.model.Order, com.smartmart.model.User, java.util.List" %>
<%
    User u = (User) session.getAttribute("user");
    if (u == null) { response.sendRedirect("login.jsp"); return; }
    List<Order> orders = new OrderDAO().getOrdersByUser(u.getUserId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - SmartMart</title>
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
        <li><a href="dashboard_user.jsp"><i class="fas fa-th-large"></i> Dashboard</a></li>
        <li><a href="profile.jsp"><i class="fas fa-user"></i> My Profile</a></li>
        <li><a href="change_password.jsp"><i class="fas fa-lock"></i> Change Password</a></li>
        <li><a href="my_orders.jsp" class="active"><i class="fas fa-shopping-bag"></i> My Orders</a></li>
        <li><a href="products.jsp"><i class="fas fa-store"></i> Shop</a></li>
        <div class="sidebar-divider"></div>
        <li><a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
    </ul>
</div>

<div class="panel-body">
    <div class="panel-header">
        <h3 style="margin:0; font-size:1.1rem;">My Orders</h3>
        <div style="display:flex; align-items:center; gap:0.75rem;">
            <i class="fas fa-user-circle fa-2x" style="color:#cbd5e1;"></i>
            <span style="font-weight:600;"><%= u.getFirstName() %></span>
        </div>
    </div>

    <div class="panel-content">
        <div class="table-container">
            <% if (orders.isEmpty()) { %>
            <div style="text-align:center; padding:3rem; color:var(--text-muted);">
                <i class="fas fa-shopping-bag fa-3x" style="margin-bottom:1rem; opacity:0.3;"></i>
                <p>You haven't placed any orders yet.</p>
                <a href="products.jsp" class="btn btn-primary" style="margin-top:1rem;">Start Shopping</a>
            </div>
            <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Date</th>
                        <th>Total</th>
                        <th>Status</th>
                        <th>Delivery Address</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Order o : orders) { %>
                    <tr>
                        <td><strong>#<%= o.getOrderId() %></strong></td>
                        <td><%= o.getOrderDate() != null ? o.getOrderDate().toLocalDate() : "-" %></td>
                        <td>Rs <%= String.format("%.2f", o.getTotalAmount()) %></td>
                        <td>
                            <% String st = o.getOrderStatus(); %>
                            <span class="badge <%= "Completed".equals(st) ? "badge-success" : "Pending".equals(st) ? "badge-warning" : "Cancelled".equals(st) ? "badge-danger" : "badge-info" %>">
                                <%= st %>
                            </span>
                        </td>
                        <td style="max-width:200px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">
                            <%= o.getDeliveryAddress() != null ? o.getDeliveryAddress() : "-" %>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } %>
        </div>
    </div>
</div>

</body>
</html>

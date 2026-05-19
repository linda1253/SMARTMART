<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartmart.dao.ProductDAO, com.smartmart.dao.UserDAO, com.smartmart.dao.OrderDAO, com.smartmart.model.Order, com.smartmart.model.User, java.util.List" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"Admin".equalsIgnoreCase(admin.getRole())) {
        response.sendRedirect("login.jsp"); return;
    }
    ProductDAO pDao = new ProductDAO();
    UserDAO    uDao = new UserDAO();
    OrderDAO   oDao = new OrderDAO();
    int    totalProducts  = pDao.getTotalProductCount();
    double totalSales     = pDao.getTotalSales();
    int    lowStock       = pDao.getLowStockCount();
    int    totalCustomers = uDao.getCustomerCount();
    int    totalOrders    = oDao.getTotalOrderCount();
    List<Order> recentOrders = oDao.getRecentOrders();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - SmartMart</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>body { display: flex; min-height: 100vh; background: var(--bg-main); }</style>
</head>
<body>

<!-- Admin Sidebar -->
<div class="sidebar">
    <a href="dashboard.jsp" class="sidebar-brand" style="text-decoration:none; color:inherit;">
        <i class="fas fa-shopping-cart"></i> SmartMart
    </a>
    <ul class="sidebar-menu">
        <li><a href="dashboard.jsp" class="active"><i class="fas fa-th-large"></i> Dashboard</a></li>
        <li><a href="ProductServlet"><i class="fas fa-box"></i> Products</a></li>
        <li><a href="CategoryServlet"><i class="fas fa-tags"></i> Categories</a></li>
        <li><a href="OrderServlet"><i class="fas fa-shopping-basket"></i> Orders</a></li>
        <li><a href="reports.jsp"><i class="fas fa-chart-line"></i> Reports</a></li>
        <li><a href="UserMgmtServlet"><i class="fas fa-users"></i> Users</a></li>
        <div class="sidebar-divider"></div>
        <li><a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
    </ul>
</div>

<div class="panel-body">
    <div class="panel-header">
        <h3 style="margin:0; font-size:1.1rem;">Admin Dashboard</h3>
        <div style="display:flex; align-items:center; gap:0.75rem;">
            <i class="fas fa-user-circle fa-2x" style="color:#cbd5e1;"></i>
            <span style="font-weight:600;"><%= admin.getFirstName() %></span>
            <span class="badge badge-info">Admin</span>
        </div>
    </div>

    <div class="panel-content">
        <!-- Stats -->
        <div class="stats-grid">
            <div class="stats-card">
                <div class="stats-icon blue"><i class="fas fa-box"></i></div>
                <div class="stats-info">
                    <h3>Total Products</h3>
                    <div class="value"><%= totalProducts %></div>
                    <a href="ProductServlet" style="font-size:0.75rem; color:var(--primary);">Manage →</a>
                </div>
            </div>
            <div class="stats-card">
                <div class="stats-icon green"><i class="fas fa-dollar-sign"></i></div>
                <div class="stats-info">
                    <h3>Total Sales</h3>
                    <div class="value">Rs <%= String.format("%.0f", totalSales) %></div>
                    <a href="reports.jsp" style="font-size:0.75rem; color:var(--primary);">View report →</a>
                </div>
            </div>
            <div class="stats-card">
                <div class="stats-icon orange"><i class="fas fa-exclamation-triangle"></i></div>
                <div class="stats-info">
                    <h3>Low Stock</h3>
                    <div class="value"><%= lowStock %></div>
                    <a href="ProductServlet" style="font-size:0.75rem; color:var(--primary);">View →</a>
                </div>
            </div>
            <div class="stats-card">
                <div class="stats-icon purple"><i class="fas fa-users"></i></div>
                <div class="stats-info">
                    <h3>Customers</h3>
                    <div class="value"><%= totalCustomers %></div>
                    <a href="UserMgmtServlet" style="font-size:0.75rem; color:var(--primary);">Manage →</a>
                </div>
            </div>
        </div>

        <!-- Recent Orders -->
        <div class="card">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.25rem;">
                <h3 style="margin:0;">Recent Orders</h3>
                <a href="OrderServlet" style="color:var(--primary); font-size:0.875rem; font-weight:600;">View All</a>
            </div>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Customer</th>
                            <th>Date</th>
                            <th>Total</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (recentOrders.isEmpty()) { %>
                        <tr><td colspan="5" style="text-align:center; padding:2rem; color:var(--text-muted);">No orders yet.</td></tr>
                        <% } else { for (Order o : recentOrders) { %>
                        <tr>
                            <td><strong>#<%= o.getOrderId() %></strong></td>
                            <td><%= o.getCustomerName() %></td>
                            <td><%= o.getOrderDate() != null ? o.getOrderDate().toLocalDate() : "-" %></td>
                            <td>Rs <%= String.format("%.2f", o.getTotalAmount()) %></td>
                            <td>
                                <% String st = o.getOrderStatus(); %>
                                <span class="badge <%= "Completed".equals(st) ? "badge-success" : "Pending".equals(st) ? "badge-warning" : "Cancelled".equals(st) ? "badge-danger" : "badge-info" %>">
                                    <%= st %>
                                </span>
                            </td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartmart.dao.ProductDAO, com.smartmart.dao.OrderDAO, com.smartmart.dao.UserDAO, com.smartmart.model.Order, com.smartmart.model.Product, com.smartmart.model.User, java.util.List" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"Admin".equalsIgnoreCase(admin.getRole())) {
        response.sendRedirect("login.jsp"); return;
    }
    ProductDAO pDao = new ProductDAO();
    OrderDAO   oDao = new OrderDAO();
    UserDAO    uDao = new UserDAO();
    double totalSales     = pDao.getTotalSales();
    int    totalOrders    = oDao.getTotalOrderCount();
    int    totalCustomers = uDao.getCustomerCount();
    int    lowStock       = pDao.getLowStockCount();
    List<Product> allProducts = pDao.getAllProducts();
    List<Order>   allOrders   = oDao.getAllOrders();
    // Low stock products
    List<Product> lowStockProducts = new java.util.ArrayList<>();
    for (Product p : allProducts) { if (p.getStock() < 10) lowStockProducts.add(p); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - SmartMart</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { display: flex; min-height: 100vh; background: var(--bg-main); }
        .report-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-top: 1.5rem; }
        @media (max-width: 900px) { .report-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>

<div class="sidebar">
    <a href="dashboard.jsp" class="sidebar-brand" style="text-decoration:none; color:inherit;">
        <i class="fas fa-shopping-cart"></i> SmartMart
    </a>
    <ul class="sidebar-menu">
        <li><a href="dashboard.jsp"><i class="fas fa-th-large"></i> Dashboard</a></li>
        <li><a href="ProductServlet"><i class="fas fa-box"></i> Products</a></li>
        <li><a href="CategoryServlet"><i class="fas fa-tags"></i> Categories</a></li>
        <li><a href="SupplierServlet"><i class="fas fa-truck"></i> Suppliers</a></li>
        <li><a href="OrderServlet"><i class="fas fa-shopping-basket"></i> Orders</a></li>
        <li><a href="reports.jsp" class="active"><i class="fas fa-chart-line"></i> Reports</a></li>
        <li><a href="UserMgmtServlet"><i class="fas fa-users"></i> Users</a></li>
        <div class="sidebar-divider"></div>
        <li><a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
    </ul>
</div>

<div class="panel-body">
    <div class="panel-header">
        <h3 style="margin:0; font-size:1.1rem;">Reports</h3>
        <div style="display:flex; align-items:center; gap:0.75rem;">
            <i class="fas fa-user-circle fa-2x" style="color:#cbd5e1;"></i>
            <span style="font-weight:600;"><%= admin.getFirstName() %></span>
        </div>
    </div>

    <div class="panel-content">
        <h2 style="margin-bottom:1.5rem;">Business Reports</h2>

        <!-- Summary KPIs -->
        <div class="stats-grid">
            <div class="stats-card">
                <div class="stats-icon green"><i class="fas fa-dollar-sign"></i></div>
                <div class="stats-info"><h3>Total Revenue</h3><div class="value">Rs <%= String.format("%.0f", totalSales) %></div></div>
            </div>
            <div class="stats-card">
                <div class="stats-icon blue"><i class="fas fa-shopping-cart"></i></div>
                <div class="stats-info"><h3>Total Orders</h3><div class="value"><%= totalOrders %></div></div>
            </div>
            <div class="stats-card">
                <div class="stats-icon purple"><i class="fas fa-users"></i></div>
                <div class="stats-info"><h3>Customers</h3><div class="value"><%= totalCustomers %></div></div>
            </div>
            <div class="stats-card">
                <div class="stats-icon orange"><i class="fas fa-exclamation-triangle"></i></div>
                <div class="stats-info"><h3>Low Stock Items</h3><div class="value"><%= lowStock %></div></div>
            </div>
        </div>

        <div class="report-grid">
            <!-- Recent Orders -->
            <div class="card">
                <h3 style="margin-bottom:1rem;"><i class="fas fa-shopping-basket" style="color:var(--primary);"></i> Recent Orders</h3>
                <div class="table-container">
                    <table>
                        <thead><tr><th>Order ID</th><th>Customer</th><th>Total</th><th>Status</th></tr></thead>
                        <tbody>
                            <% int count = 0; for (Order o : allOrders) { if (count++ >= 8) break; %>
                            <tr>
                                <td>#<%= o.getOrderId() %></td>
                                <td><%= o.getCustomerName() %></td>
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
            </div>

            <!-- Low Stock Products -->
            <div class="card">
                <h3 style="margin-bottom:1rem;"><i class="fas fa-exclamation-triangle" style="color:var(--warning);"></i> Low Stock Products</h3>
                <% if (lowStockProducts.isEmpty()) { %>
                <p style="color:var(--text-muted); text-align:center; padding:2rem;">All products are well stocked.</p>
                <% } else { %>
                <div class="table-container">
                    <table>
                        <thead><tr><th>Product</th><th>Category</th><th>Stock</th></tr></thead>
                        <tbody>
                            <% for (Product p : lowStockProducts) { %>
                            <tr>
                                <td><%= p.getProductName() %></td>
                                <td><%= p.getCategoryName() %></td>
                                <td><span class="badge badge-danger"><%= p.getStock() %></span></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

</body>
</html>

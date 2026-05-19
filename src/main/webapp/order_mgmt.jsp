<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartmart.model.Order, com.smartmart.model.User, java.util.List" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"Admin".equalsIgnoreCase(admin.getRole())) {
        response.sendRedirect("login.jsp"); return;
    }
    List<Order> orderList = (List<Order>) request.getAttribute("orderList");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Management - SmartMart</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>body { display: flex; min-height: 100vh; background: var(--bg-main); }</style>
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
        <li><a href="OrderServlet" class="active"><i class="fas fa-shopping-basket"></i> Orders</a></li>
        <li><a href="reports.jsp"><i class="fas fa-chart-line"></i> Reports</a></li>
        <li><a href="UserMgmtServlet"><i class="fas fa-users"></i> Users</a></li>
        <div class="sidebar-divider"></div>
        <li><a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
    </ul>
</div>

<div class="panel-body">
    <div class="panel-header">
        <h3 style="margin:0; font-size:1.1rem;">Order Management</h3>
        <div style="display:flex; align-items:center; gap:0.75rem;">
            <i class="fas fa-user-circle fa-2x" style="color:#cbd5e1;"></i>
            <span style="font-weight:600;"><%= admin.getFirstName() %></span>
        </div>
    </div>

    <div class="panel-content">
        <% if ("updated".equals(msg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Order status updated.</div><% } %>
        <% if ("error".equals(msg)) { %><div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> Operation failed.</div><% } %>

        <h2 style="margin-bottom:1.5rem;">All Orders</h2>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Customer</th>
                        <th>Date</th>
                        <th>Total</th>
                        <th>Status</th>
                        <th>Update Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (orderList == null || orderList.isEmpty()) { %>
                    <tr><td colspan="6" style="text-align:center; padding:2rem; color:var(--text-muted);">No orders found.</td></tr>
                    <% } else { for (Order o : orderList) { %>
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
                        <td>
                            <form action="OrderServlet" method="post" style="display:flex; gap:0.4rem; align-items:center;">
                                <input type="hidden" name="action" value="updateStatus">
                                <input type="hidden" name="orderId" value="<%= o.getOrderId() %>">
                                <select name="status" class="form-control" style="padding:0.35rem 0.6rem; font-size:0.8rem; width:auto;">
                                    <option value="Pending"    <%= "Pending".equals(st)    ? "selected" : "" %>>Pending</option>
                                    <option value="Processing" <%= "Processing".equals(st) ? "selected" : "" %>>Processing</option>
                                    <option value="Completed"  <%= "Completed".equals(st)  ? "selected" : "" %>>Completed</option>
                                    <option value="Cancelled"  <%= "Cancelled".equals(st)  ? "selected" : "" %>>Cancelled</option>
                                </select>
                                <button type="submit" class="btn btn-primary btn-xs">Update</button>
                            </form>
                        </td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>

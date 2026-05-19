<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartmart.model.User, java.util.List" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"Admin".equalsIgnoreCase(admin.getRole())) {
        response.sendRedirect("login.jsp"); return;
    }
    List<User> userList = (List<User>) request.getAttribute("userList");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - SmartMart</title>
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
        <li><a href="OrderServlet"><i class="fas fa-shopping-basket"></i> Orders</a></li>
        <li><a href="reports.jsp"><i class="fas fa-chart-line"></i> Reports</a></li>
        <li><a href="UserMgmtServlet" class="active"><i class="fas fa-users"></i> Users</a></li>
        <div class="sidebar-divider"></div>
        <li><a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
    </ul>
</div>

<div class="panel-body">
    <div class="panel-header">
        <h3 style="margin:0; font-size:1.1rem;">User Management</h3>
        <div style="display:flex; align-items:center; gap:0.75rem;">
            <i class="fas fa-user-circle fa-2x" style="color:#cbd5e1;"></i>
            <span style="font-weight:600;"><%= admin.getFirstName() %></span>
        </div>
    </div>

    <div class="panel-content">
        <% if ("approve".equals(msg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> User approved.</div><% } %>
        <% if ("reject".equals(msg)) { %><div class="alert alert-warning"><i class="fas fa-info-circle"></i> User set to Pending.</div><% } %>
        <% if ("delete".equals(msg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> User deleted.</div><% } %>
        <% if ("error".equals(msg)) { %><div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> Operation failed.</div><% } %>

        <h2 style="margin-bottom:1.5rem;">All Users</h2>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Registered</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (userList == null || userList.isEmpty()) { %>
                    <tr><td colspan="8" style="text-align:center; padding:2rem; color:var(--text-muted);">No users found.</td></tr>
                    <% } else { for (User u : userList) { %>
                    <tr>
                        <td>#<%= u.getUserId() %></td>
                        <td><strong><%= u.getFirstName() %> <%= u.getLastName() %></strong></td>
                        <td><%= u.getEmail() %></td>
                        <td><%= u.getPhone() %></td>
                        <td><span class="badge <%= "Admin".equals(u.getRole()) ? "badge-info" : "badge-neutral" %>"><%= u.getRole() %></span></td>
                        <td><span class="badge <%= "Approved".equals(u.getApprovalStatus()) ? "badge-success" : "badge-warning" %>"><%= u.getApprovalStatus() %></span></td>
                        <td style="font-size:0.8rem; color:var(--text-muted);">
                            <%= u.getCreatedAt() != null ? u.getCreatedAt().toLocalDate() : "-" %>
                        </td>
                        <td>
                            <% if (!"Admin".equals(u.getRole())) { %>
                            <div style="display:flex; gap:0.4rem; flex-wrap:wrap;">
                                <% if ("Pending".equals(u.getApprovalStatus())) { %>
                                <form action="UserMgmtServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="approve">
                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                    <button type="submit" class="btn btn-success btn-xs"><i class="fas fa-check"></i> Approve</button>
                                </form>
                                <% } else { %>
                                <form action="UserMgmtServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="reject">
                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                    <button type="submit" class="btn btn-outline btn-xs"><i class="fas fa-ban"></i> Revoke</button>
                                </form>
                                <% } %>
                                <form action="UserMgmtServlet" method="post" onsubmit="return confirm('Delete this user?');" style="display:inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                    <button type="submit" class="btn btn-danger btn-xs"><i class="fas fa-trash"></i></button>
                                </form>
                            </div>
                            <% } else { %>
                            <span style="color:var(--text-muted); font-size:0.8rem;">—</span>
                            <% } %>
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

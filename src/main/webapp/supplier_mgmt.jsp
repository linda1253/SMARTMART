<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartmart.model.Supplier, com.smartmart.model.User, java.util.List" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"Admin".equalsIgnoreCase(admin.getRole())) {
        response.sendRedirect("login.jsp"); return;
    }
    List<Supplier> supplierList = (List<Supplier>) request.getAttribute("supplierList");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Supplier Management - SmartMart</title>
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
        <li><a href="SupplierServlet" class="active"><i class="fas fa-truck"></i> Suppliers</a></li>
        <li><a href="OrderServlet"><i class="fas fa-shopping-basket"></i> Orders</a></li>
        <li><a href="reports.jsp"><i class="fas fa-chart-line"></i> Reports</a></li>
        <li><a href="UserMgmtServlet"><i class="fas fa-users"></i> Users</a></li>
        <div class="sidebar-divider"></div>
        <li><a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
    </ul>
</div>

<div class="panel-body">
    <div class="panel-header">
        <h3 style="margin:0; font-size:1.1rem;">Supplier Management</h3>
        <div style="display:flex; align-items:center; gap:0.75rem;">
            <i class="fas fa-user-circle fa-2x" style="color:#cbd5e1;"></i>
            <span style="font-weight:600;"><%= admin.getFirstName() %></span>
        </div>
    </div>

    <div class="panel-content">
        <% if ("added".equals(msg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Supplier added.</div><% } %>
        <% if ("updated".equals(msg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Supplier updated.</div><% } %>
        <% if ("deleted".equals(msg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Supplier deleted.</div><% } %>
        <% if ("error".equals(msg)) { %><div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> Operation failed.</div><% } %>

        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.5rem;">
            <h2 style="margin:0;">Suppliers</h2>
            <button class="btn btn-primary" onclick="openModal('addModal')"><i class="fas fa-plus"></i> Add Supplier</button>
        </div>

        <div class="table-container">
            <table>
                <thead><tr><th>ID</th><th>Supplier Name</th><th>Contact</th><th>Email</th><th>Phone</th><th>Actions</th></tr></thead>
                <tbody>
                    <% if (supplierList == null || supplierList.isEmpty()) { %>
                    <tr><td colspan="6" style="text-align:center; padding:2rem; color:var(--text-muted);">No suppliers found.</td></tr>
                    <% } else { for (Supplier s : supplierList) { %>
                    <tr>
                        <td>#<%= s.getSupplierId() %></td>
                        <td><strong><%= s.getSupplierName() %></strong></td>
                        <td><%= s.getContactName() != null ? s.getContactName() : "-" %></td>
                        <td><%= s.getEmail() != null ? s.getEmail() : "-" %></td>
                        <td><%= s.getPhone() != null ? s.getPhone() : "-" %></td>
                        <td>
                            <div style="display:flex; gap:0.5rem;">
                                <button class="btn btn-outline btn-xs"
                                    onclick="openEditModal(<%= s.getSupplierId() %>, '<%= s.getSupplierName().replace("'","\'") %>', '<%= s.getContactName() != null ? s.getContactName().replace("'","\'") : "" %>', '<%= s.getEmail() != null ? s.getEmail() : "" %>', '<%= s.getPhone() != null ? s.getPhone() : "" %>', '<%= s.getAddress() != null ? s.getAddress().replace("'","\'") : "" %>')">
                                    <i class="fas fa-edit"></i> Edit
                                </button>
                                <form action="SupplierServlet" method="post" onsubmit="return confirm('Delete this supplier?');" style="display:inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="supplierId" value="<%= s.getSupplierId() %>">
                                    <button type="submit" class="btn btn-danger btn-xs"><i class="fas fa-trash"></i></button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Add Modal -->
<div class="modal-overlay" id="addModal">
    <div class="modal">
        <div class="modal-header"><h3>Add Supplier</h3><button class="modal-close" onclick="closeModal('addModal')">&times;</button></div>
        <form action="SupplierServlet" method="post">
            <input type="hidden" name="action" value="add">
            <div class="form-group"><label class="form-label">Supplier Name *</label><input type="text" name="supplierName" class="form-control" required></div>
            <div class="form-group"><label class="form-label">Contact Person</label><input type="text" name="contactName" class="form-control"></div>
            <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;">
                <div class="form-group"><label class="form-label">Email</label><input type="email" name="email" class="form-control"></div>
                <div class="form-group"><label class="form-label">Phone</label><input type="tel" name="phone" class="form-control"></div>
            </div>
            <div class="form-group"><label class="form-label">Address</label><textarea name="address" class="form-control" rows="2"></textarea></div>
            <div style="display:flex; gap:1rem;">
                <button type="submit" class="btn btn-primary" style="flex:1;">Add</button>
                <button type="button" class="btn btn-outline" style="flex:1;" onclick="closeModal('addModal')">Cancel</button>
            </div>
        </form>
    </div>
</div>

<!-- Edit Modal -->
<div class="modal-overlay" id="editModal">
    <div class="modal">
        <div class="modal-header"><h3>Edit Supplier</h3><button class="modal-close" onclick="closeModal('editModal')">&times;</button></div>
        <form action="SupplierServlet" method="post">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="supplierId" id="editSupId">
            <div class="form-group"><label class="form-label">Supplier Name *</label><input type="text" name="supplierName" id="editSupName" class="form-control" required></div>
            <div class="form-group"><label class="form-label">Contact Person</label><input type="text" name="contactName" id="editSupContact" class="form-control"></div>
            <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;">
                <div class="form-group"><label class="form-label">Email</label><input type="email" name="email" id="editSupEmail" class="form-control"></div>
                <div class="form-group"><label class="form-label">Phone</label><input type="tel" name="phone" id="editSupPhone" class="form-control"></div>
            </div>
            <div class="form-group"><label class="form-label">Address</label><textarea name="address" id="editSupAddress" class="form-control" rows="2"></textarea></div>
            <div style="display:flex; gap:1rem;">
                <button type="submit" class="btn btn-primary" style="flex:1;">Save</button>
                <button type="button" class="btn btn-outline" style="flex:1;" onclick="closeModal('editModal')">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script>
function openModal(id) { document.getElementById(id).classList.add('active'); }
function closeModal(id) { document.getElementById(id).classList.remove('active'); }
function openEditModal(id, name, contact, email, phone, address) {
    document.getElementById('editSupId').value      = id;
    document.getElementById('editSupName').value    = name;
    document.getElementById('editSupContact').value = contact;
    document.getElementById('editSupEmail').value   = email;
    document.getElementById('editSupPhone').value   = phone;
    document.getElementById('editSupAddress').value = address;
    openModal('editModal');
}
document.querySelectorAll('.modal-overlay').forEach(o => o.addEventListener('click', e => { if (e.target === o) o.classList.remove('active'); }));
</script>
</body>
</html>

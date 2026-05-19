<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartmart.model.Product, com.smartmart.model.Category, com.smartmart.model.Supplier, com.smartmart.model.User, java.util.List" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"Admin".equalsIgnoreCase(admin.getRole())) {
        response.sendRedirect("login.jsp"); return;
    }
    List<Product>  productList  = (List<Product>)  request.getAttribute("productList");
    List<Category> categoryList = (List<Category>) request.getAttribute("categoryList");
    List<Supplier> supplierList = (List<Supplier>) request.getAttribute("supplierList");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Management - SmartMart</title>
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
        <li><a href="ProductServlet" class="active"><i class="fas fa-box"></i> Products</a></li>
        <li><a href="CategoryServlet"><i class="fas fa-tags"></i> Categories</a></li>
        <li><a href="SupplierServlet"><i class="fas fa-truck"></i> Suppliers</a></li>
        <li><a href="OrderServlet"><i class="fas fa-shopping-basket"></i> Orders</a></li>
        <li><a href="reports.jsp"><i class="fas fa-chart-line"></i> Reports</a></li>
        <li><a href="UserMgmtServlet"><i class="fas fa-users"></i> Users</a></li>
        <div class="sidebar-divider"></div>
        <li><a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
    </ul>
</div>

<div class="panel-body">
    <div class="panel-header">
        <h3 style="margin:0; font-size:1.1rem;">Product Management</h3>
        <div style="display:flex; align-items:center; gap:0.75rem;">
            <i class="fas fa-user-circle fa-2x" style="color:#cbd5e1;"></i>
            <span style="font-weight:600;"><%= admin.getFirstName() %></span>
        </div>
    </div>

    <div class="panel-content">
        <% if ("added".equals(msg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Product added successfully.</div><% } %>
        <% if ("updated".equals(msg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Product updated successfully.</div><% } %>
        <% if ("deleted".equals(msg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Product deleted successfully.</div><% } %>
        <% if ("error".equals(msg)) { %><div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> Operation failed. Please try again.</div><% } %>
        <% if (request.getAttribute("error") != null) { %><div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div><% } %>

        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.5rem;">
            <h2 style="margin:0;">Products</h2>
            <button class="btn btn-primary" onclick="openModal('addModal')">
                <i class="fas fa-plus"></i> Add Product
            </button>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Product Name</th>
                        <th>Category</th>
                        <th>Price (Rs)</th>
                        <th>Stock</th>
                        <th>Supplier</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (productList == null || productList.isEmpty()) { %>
                    <tr><td colspan="7" style="text-align:center; padding:2rem; color:var(--text-muted);">No products found.</td></tr>
                    <% } else { for (Product p : productList) { %>
                    <tr>
                        <td>#<%= p.getProductId() %></td>
                        <td><strong><%= p.getProductName() %></strong></td>
                        <td><%= p.getCategoryName() %></td>
                        <td>Rs <%= String.format("%.2f", p.getPrice()) %></td>
                        <td>
                            <span class="badge <%= p.getStock() < 10 ? "badge-danger" : p.getStock() < 30 ? "badge-warning" : "badge-success" %>">
                                <%= p.getStock() %>
                            </span>
                        </td>
                        <td><%= p.getSupplierName() != null ? p.getSupplierName() : "-" %></td>
                        <td>
                            <div style="display:flex; gap:0.5rem;">
                                <button class="btn btn-outline btn-xs"
                                    onclick="openEditModal(<%= p.getProductId() %>, '<%= p.getProductName().replace("'","\'") %>', '<%= p.getDescription() != null ? p.getDescription().replace("'","\'") : "" %>', <%= p.getPrice() %>, <%= p.getStock() %>, <%= p.getCategoryId() %>, '<%= p.getSupplierId() != null ? p.getSupplierId() : "" %>')">
                                    <i class="fas fa-edit"></i> Edit
                                </button>
                                <form action="ProductServlet" method="post" onsubmit="return confirm('Delete this product?');" style="display:inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                                    <button type="submit" class="btn btn-danger btn-xs"><i class="fas fa-trash"></i> Delete</button>
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

<!-- Add Product Modal -->
<div class="modal-overlay" id="addModal">
    <div class="modal">
        <div class="modal-header">
            <h3>Add New Product</h3>
            <button class="modal-close" onclick="closeModal('addModal')">&times;</button>
        </div>
        <form action="ProductServlet" method="post">
            <input type="hidden" name="action" value="add">
            <div class="form-group">
                <label class="form-label">Product Name *</label>
                <input type="text" name="productName" class="form-control" required>
            </div>
            <div class="form-group">
                <label class="form-label">Description</label>
                <textarea name="description" class="form-control" rows="2"></textarea>
            </div>
            <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;">
                <div class="form-group">
                    <label class="form-label">Price (Rs) *</label>
                    <input type="number" name="price" class="form-control" step="0.01" min="0.01" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Stock *</label>
                    <input type="number" name="stock" class="form-control" min="0" required>
                </div>
            </div>
            <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;">
                <div class="form-group">
                    <label class="form-label">Category *</label>
                    <select name="categoryId" class="form-control" required>
                        <option value="">Select category</option>
                        <% if (categoryList != null) { for (Category c : categoryList) { %>
                        <option value="<%= c.getCategoryId() %>"><%= c.getCategoryName() %></option>
                        <% } } %>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Supplier</label>
                    <select name="supplierId" class="form-control">
                        <option value="">None</option>
                        <% if (supplierList != null) { for (Supplier s : supplierList) { %>
                        <option value="<%= s.getSupplierId() %>"><%= s.getSupplierName() %></option>
                        <% } } %>
                    </select>
                </div>
            </div>
            <div style="display:flex; gap:1rem; margin-top:0.5rem;">
                <button type="submit" class="btn btn-primary" style="flex:1;">Add Product</button>
                <button type="button" class="btn btn-outline" style="flex:1;" onclick="closeModal('addModal')">Cancel</button>
            </div>
        </form>
    </div>
</div>

<!-- Edit Product Modal -->
<div class="modal-overlay" id="editModal">
    <div class="modal">
        <div class="modal-header">
            <h3>Edit Product</h3>
            <button class="modal-close" onclick="closeModal('editModal')">&times;</button>
        </div>
        <form action="ProductServlet" method="post">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="productId" id="editProductId">
            <div class="form-group">
                <label class="form-label">Product Name *</label>
                <input type="text" name="productName" id="editProductName" class="form-control" required>
            </div>
            <div class="form-group">
                <label class="form-label">Description</label>
                <textarea name="description" id="editDescription" class="form-control" rows="2"></textarea>
            </div>
            <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;">
                <div class="form-group">
                    <label class="form-label">Price (Rs) *</label>
                    <input type="number" name="price" id="editPrice" class="form-control" step="0.01" min="0.01" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Stock *</label>
                    <input type="number" name="stock" id="editStock" class="form-control" min="0" required>
                </div>
            </div>
            <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;">
                <div class="form-group">
                    <label class="form-label">Category *</label>
                    <select name="categoryId" id="editCategoryId" class="form-control" required>
                        <% if (categoryList != null) { for (Category c : categoryList) { %>
                        <option value="<%= c.getCategoryId() %>"><%= c.getCategoryName() %></option>
                        <% } } %>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Supplier</label>
                    <select name="supplierId" id="editSupplierId" class="form-control">
                        <option value="">None</option>
                        <% if (supplierList != null) { for (Supplier s : supplierList) { %>
                        <option value="<%= s.getSupplierId() %>"><%= s.getSupplierName() %></option>
                        <% } } %>
                    </select>
                </div>
            </div>
            <div style="display:flex; gap:1rem; margin-top:0.5rem;">
                <button type="submit" class="btn btn-primary" style="flex:1;">Save Changes</button>
                <button type="button" class="btn btn-outline" style="flex:1;" onclick="closeModal('editModal')">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script>
function openModal(id) { document.getElementById(id).classList.add('active'); }
function closeModal(id) { document.getElementById(id).classList.remove('active'); }
function openEditModal(id, name, desc, price, stock, catId, supId) {
    document.getElementById('editProductId').value   = id;
    document.getElementById('editProductName').value = name;
    document.getElementById('editDescription').value = desc;
    document.getElementById('editPrice').value       = price;
    document.getElementById('editStock').value       = stock;
    document.getElementById('editCategoryId').value  = catId;
    document.getElementById('editSupplierId').value  = supId;
    openModal('editModal');
}
// Close modal on overlay click
document.querySelectorAll('.modal-overlay').forEach(overlay => {
    overlay.addEventListener('click', e => { if (e.target === overlay) overlay.classList.remove('active'); });
});
</script>
</body>
</html>

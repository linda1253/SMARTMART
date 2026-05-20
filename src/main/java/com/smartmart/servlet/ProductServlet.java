package com.smartmart.servlet;

import com.smartmart.dao.CategoryDAO;
import com.smartmart.dao.ProductDAO;
import com.smartmart.model.Product;
import com.smartmart.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Controller for product management (Admin only).
 *
 * <p><b>GET /ProductServlet</b> — loads the product management page with all products,
 * categories for the add/edit form dropdowns.</p>
 *
 * <p><b>POST /ProductServlet</b> — handles add, edit, and delete actions via the
 * hidden {@code action} parameter:
 * <ul>
 *   <li>{@code action=add}    — inserts a new product</li>
 *   <li>{@code action=edit}   — updates an existing product</li>
 *   <li>{@code action=delete} — deletes a product by ID</li>
 * </ul>
 * </p>
 */
@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {

    private final ProductDAO  productDAO  = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    /**
     * Loads the product management page.
     *
     * <p><b>Input:</b> none (optional query param {@code msg} for flash messages)</p>
     * <p><b>Output:</b> forwards to product_mgmt.jsp with request attributes:
     *   {@code productList}, {@code categoryList}</p>
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("productList",  productDAO.getAllProducts());
        request.setAttribute("categoryList", categoryDAO.getAllCategories());
        request.getRequestDispatcher("product_mgmt.jsp").forward(request, response);
    }

    /**
     * Handles add, edit, and delete product actions.
     *
     * <p><b>Input parameters:</b>
     * <ul>
     *   <li>{@code action}      — "add" | "edit" | "delete"</li>
     *   <li>{@code productId}   — required for edit/delete</li>
     *   <li>{@code productName} — product name</li>
     *   <li>{@code description} — product description</li>
     *   <li>{@code price}       — decimal price</li>
     *   <li>{@code stock}       — integer stock quantity</li>
     *   <li>{@code categoryId}  — FK to Category</li>
     * </ul>
     * </p>
     * <p><b>Output:</b> redirects to ProductServlet with a {@code msg} flash message.</p>
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            handleDelete(request, response);
            return;
        }

        // Shared validation for add and edit
        String productName  = request.getParameter("productName");
        String priceStr     = request.getParameter("price");
        String stockStr     = request.getParameter("stock");
        String categoryStr  = request.getParameter("categoryId");

        if (ValidationUtil.isNullOrEmpty(productName, priceStr, stockStr, categoryStr)) {
            request.setAttribute("error", "Product name, price, stock, and category are required.");
            doGet(request, response);
            return;
        }
        if (!ValidationUtil.isPositiveNumber(priceStr)) {
            request.setAttribute("error", "Price must be a positive number.");
            doGet(request, response);
            return;
        }
        if (!ValidationUtil.isNonNegativeInt(stockStr)) {
            request.setAttribute("error", "Stock must be a non-negative integer.");
            doGet(request, response);
            return;
        }

        Product product = new Product();
        product.setProductName(productName.trim());
        product.setPrice(Double.parseDouble(priceStr));
        product.setStock(Integer.parseInt(stockStr));
        product.setCategoryId(Integer.parseInt(categoryStr));

        if ("add".equals(action)) {
            boolean ok = productDAO.addProduct(product);
            response.sendRedirect("ProductServlet?msg=" + (ok ? "added" : "error"));
        } else if ("edit".equals(action)) {
            String idStr = request.getParameter("productId");
            if (idStr == null || idStr.isEmpty()) {
                response.sendRedirect("ProductServlet?msg=error");
                return;
            }
            product.setProductId(Integer.parseInt(idStr));
            boolean ok = productDAO.updateProduct(product);
            response.sendRedirect("ProductServlet?msg=" + (ok ? "updated" : "error"));
        } else {
            response.sendRedirect("ProductServlet");
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("productId");
        if (idStr != null && !idStr.isEmpty()) {
            boolean ok = productDAO.deleteProduct(Integer.parseInt(idStr));
            response.sendRedirect("ProductServlet?msg=" + (ok ? "deleted" : "error"));
        } else {
            response.sendRedirect("ProductServlet?msg=error");
        }
    }
}

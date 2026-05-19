package com.smartmart.servlet;

import com.smartmart.dao.CategoryDAO;
import com.smartmart.model.Category;
import com.smartmart.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Controller for category management (Admin only).
 *
 * <p>GET  /CategoryServlet — loads category_mgmt.jsp with all categories.</p>
 * <p>POST /CategoryServlet — handles add, edit, delete via {@code action} param.</p>
 */
@WebServlet("/CategoryServlet")
public class CategoryServlet extends HttpServlet {

    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("categoryList", categoryDAO.getAllCategories());
        request.getRequestDispatcher("category_mgmt.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            String idStr = request.getParameter("categoryId");
            if (idStr != null && !idStr.isEmpty()) {
                boolean ok = categoryDAO.deleteCategory(Integer.parseInt(idStr));
                response.sendRedirect("CategoryServlet?msg=" + (ok ? "deleted" : "error"));
            } else {
                response.sendRedirect("CategoryServlet?msg=error");
            }
            return;
        }

        String categoryName = request.getParameter("categoryName");
        String description  = request.getParameter("description");

        if (ValidationUtil.isNullOrEmpty(categoryName)) {
            request.setAttribute("error", "Category name is required.");
            doGet(request, response);
            return;
        }

        Category category = new Category();
        category.setCategoryName(categoryName.trim());
        category.setDescription(description != null ? description.trim() : "");

        if ("add".equals(action)) {
            boolean ok = categoryDAO.addCategory(category);
            response.sendRedirect("CategoryServlet?msg=" + (ok ? "added" : "error"));
        } else if ("edit".equals(action)) {
            String idStr = request.getParameter("categoryId");
            if (idStr == null || idStr.isEmpty()) {
                response.sendRedirect("CategoryServlet?msg=error");
                return;
            }
            category.setCategoryId(Integer.parseInt(idStr));
            boolean ok = categoryDAO.updateCategory(category);
            response.sendRedirect("CategoryServlet?msg=" + (ok ? "updated" : "error"));
        } else {
            response.sendRedirect("CategoryServlet");
        }
    }
}

package com.smartmart.servlet;

import com.smartmart.dao.SupplierDAO;
import com.smartmart.model.Supplier;
import com.smartmart.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Controller for supplier management (Admin only).
 *
 * <p>GET  /SupplierServlet — loads supplier_mgmt.jsp with all suppliers.</p>
 * <p>POST /SupplierServlet — handles add, edit, delete via {@code action} param.</p>
 */
@WebServlet("/SupplierServlet")
public class SupplierServlet extends HttpServlet {

    private final SupplierDAO supplierDAO = new SupplierDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("supplierList", supplierDAO.getAllSuppliers());
        request.getRequestDispatcher("supplier_mgmt.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            String idStr = request.getParameter("supplierId");
            if (idStr != null && !idStr.isEmpty()) {
                boolean ok = supplierDAO.deleteSupplier(Integer.parseInt(idStr));
                response.sendRedirect("SupplierServlet?msg=" + (ok ? "deleted" : "error"));
            } else {
                response.sendRedirect("SupplierServlet?msg=error");
            }
            return;
        }

        String supplierName = request.getParameter("supplierName");
        String contactName  = request.getParameter("contactName");
        String email        = request.getParameter("email");
        String phone        = request.getParameter("phone");
        String address      = request.getParameter("address");

        if (ValidationUtil.isNullOrEmpty(supplierName)) {
            request.setAttribute("error", "Supplier name is required.");
            doGet(request, response);
            return;
        }

        Supplier supplier = new Supplier();
        supplier.setSupplierName(supplierName.trim());
        supplier.setContactName(contactName != null ? contactName.trim() : "");
        supplier.setEmail(email != null ? email.trim() : "");
        supplier.setPhone(phone != null ? phone.trim() : "");
        supplier.setAddress(address != null ? address.trim() : "");

        if ("add".equals(action)) {
            boolean ok = supplierDAO.addSupplier(supplier);
            response.sendRedirect("SupplierServlet?msg=" + (ok ? "added" : "error"));
        } else if ("edit".equals(action)) {
            String idStr = request.getParameter("supplierId");
            if (idStr == null || idStr.isEmpty()) {
                response.sendRedirect("SupplierServlet?msg=error");
                return;
            }
            supplier.setSupplierId(Integer.parseInt(idStr));
            boolean ok = supplierDAO.updateSupplier(supplier);
            response.sendRedirect("SupplierServlet?msg=" + (ok ? "updated" : "error"));
        } else {
            response.sendRedirect("SupplierServlet");
        }
    }
}

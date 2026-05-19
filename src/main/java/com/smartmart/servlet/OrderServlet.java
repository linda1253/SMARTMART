package com.smartmart.servlet;

import com.smartmart.dao.OrderDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Controller for order management (Admin only).
 *
 * <p>GET  /OrderServlet — loads order_mgmt.jsp with all orders.</p>
 * <p>POST /OrderServlet — updates order status via {@code action=updateStatus}.</p>
 */
@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("orderList", orderDAO.getAllOrders());
        request.getRequestDispatcher("order_mgmt.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("updateStatus".equals(action)) {
            String orderIdStr = request.getParameter("orderId");
            String status     = request.getParameter("status");
            if (orderIdStr != null && status != null) {
                boolean ok = orderDAO.updateOrderStatus(Integer.parseInt(orderIdStr), status);
                response.sendRedirect("OrderServlet?msg=" + (ok ? "updated" : "error"));
            } else {
                response.sendRedirect("OrderServlet?msg=error");
            }
        } else {
            response.sendRedirect("OrderServlet");
        }
    }
}

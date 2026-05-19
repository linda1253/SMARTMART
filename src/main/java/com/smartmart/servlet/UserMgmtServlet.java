package com.smartmart.servlet;

import com.smartmart.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Controller for user management (Admin only).
 *
 * <p>GET  /UserMgmtServlet — loads user_mgmt.jsp with all users.</p>
 * <p>POST /UserMgmtServlet — handles approve, reject, delete actions.</p>
 */
@WebServlet("/UserMgmtServlet")
public class UserMgmtServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("userList", userDAO.getAllUsers());
        request.getRequestDispatcher("user_mgmt.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action    = request.getParameter("action");
        String userIdStr = request.getParameter("userId");

        if (userIdStr == null || userIdStr.isEmpty()) {
            response.sendRedirect("UserMgmtServlet?msg=error");
            return;
        }

        int userId = Integer.parseInt(userIdStr);
        boolean ok = false;

        switch (action != null ? action : "") {
            case "approve":
                ok = userDAO.updateApprovalStatus(userId, "Approved");
                break;
            case "reject":
                ok = userDAO.updateApprovalStatus(userId, "Pending");
                break;
            case "delete":
                ok = userDAO.deleteUser(userId);
                break;
            default:
                break;
        }

        response.sendRedirect("UserMgmtServlet?msg=" + (ok ? action : "error"));
    }
}

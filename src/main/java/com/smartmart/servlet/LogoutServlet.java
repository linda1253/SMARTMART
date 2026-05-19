package com.smartmart.servlet;

import com.smartmart.util.SessionUtil;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Handles user logout (GET /logout).
 * Invalidates the session and redirects to the home page.
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        SessionUtil.invalidateSession(request);
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}

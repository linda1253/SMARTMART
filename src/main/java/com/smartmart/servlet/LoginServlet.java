package com.smartmart.servlet;

import com.smartmart.dao.UserDAO;
import com.smartmart.model.User;
import com.smartmart.util.SessionUtil;
import com.smartmart.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Handles user login (POST /login).
 *
 * <p><b>Input:</b> email, password (form parameters)</p>
 * <p><b>Output:</b>
 *   <ul>
 *     <li>On success: stores {@link User} in session, redirects Admin → dashboard.jsp,
 *         User → index.jsp</li>
 *     <li>On failure: forwards back to login.jsp with error attributes</li>
 *   </ul>
 * </p>
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        boolean hasError = false;

        // Validate email
        if (ValidationUtil.isNullOrEmpty(email)) {
            request.setAttribute("emailError", "Email is required");
            hasError = true;
        } else if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("emailError", "Invalid email format");
            hasError = true;
        }

        // Validate password presence
        if (ValidationUtil.isNullOrEmpty(password)) {
            request.setAttribute("passwordError", "Password is required");
            hasError = true;
        }

        if (hasError) {
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Authenticate against database
        User user = userDAO.loginUser(email, password);

        if (user != null) {
            SessionUtil.setAttribute(request, "user", user);

            if ("Admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("dashboard.jsp");
            } else {
                response.sendRedirect("index.jsp");
            }
        } else {
            request.setAttribute("invalid", "Invalid credentials or account not yet approved.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}

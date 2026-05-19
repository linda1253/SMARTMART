package com.smartmart.servlet;

import com.smartmart.dao.UserDAO;
import com.smartmart.model.User;
import com.smartmart.util.PasswordUtil;
import com.smartmart.util.SessionUtil;
import com.smartmart.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Controller for user profile and password management.
 *
 * <p>POST /ProfileServlet with {@code action=updateProfile} — updates name, email, phone.</p>
 * <p>POST /ProfileServlet with {@code action=changePassword} — changes password after
 * verifying the current password.</p>
 */
@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User sessionUser = (User) SessionUtil.getAttribute(request, "user");
        if (sessionUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("updateProfile".equals(action)) {
            handleProfileUpdate(request, response, sessionUser);
        } else if ("changePassword".equals(action)) {
            handlePasswordChange(request, response, sessionUser);
        } else {
            response.sendRedirect("profile.jsp");
        }
    }

    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response,
                                     User sessionUser) throws ServletException, IOException {
        String firstName = request.getParameter("firstName");
        String lastName  = request.getParameter("lastName");
        String email     = request.getParameter("email");
        String phone     = request.getParameter("phone");

        if (ValidationUtil.isNullOrEmpty(firstName, email, phone)) {
            request.setAttribute("profileError", "First name, email, and phone are required.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }
        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("profileError", "Invalid email format.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        User updated = new User();
        updated.setUserId(sessionUser.getUserId());
        updated.setFirstName(firstName.trim());
        updated.setLastName(lastName != null ? lastName.trim() : "");
        updated.setEmail(email.trim());
        updated.setPhone(phone.trim());

        if (userDAO.updateProfile(updated)) {
            // Refresh session with updated data
            User refreshed = userDAO.getUserById(sessionUser.getUserId());
            SessionUtil.setAttribute(request, "user", refreshed);
            request.setAttribute("profileSuccess", "Profile updated successfully.");
        } else {
            request.setAttribute("profileError", "Update failed. Please try again.");
        }
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    private void handlePasswordChange(HttpServletRequest request, HttpServletResponse response,
                                      User sessionUser) throws ServletException, IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword     = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (ValidationUtil.isNullOrEmpty(currentPassword, newPassword, confirmPassword)) {
            request.setAttribute("passError", "All password fields are required.");
            request.getRequestDispatcher("change_password.jsp").forward(request, response);
            return;
        }

        // Verify current password
        User dbUser = userDAO.getUserById(sessionUser.getUserId());
        if (!PasswordUtil.verifyPassword(currentPassword, dbUser.getPassword())) {
            request.setAttribute("passError", "Current password is incorrect.");
            request.getRequestDispatcher("change_password.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtil.isValidPassword(newPassword)) {
            request.setAttribute("passError", "New password must be at least 8 characters.");
            request.getRequestDispatcher("change_password.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtil.doPasswordsMatch(newPassword, confirmPassword)) {
            request.setAttribute("passError", "New passwords do not match.");
            request.getRequestDispatcher("change_password.jsp").forward(request, response);
            return;
        }

        String hashed = PasswordUtil.hashPassword(newPassword);
        if (userDAO.updatePassword(sessionUser.getUserId(), hashed)) {
            request.setAttribute("passSuccess", "Password changed successfully.");
        } else {
            request.setAttribute("passError", "Password change failed. Please try again.");
        }
        request.getRequestDispatcher("change_password.jsp").forward(request, response);
    }
}

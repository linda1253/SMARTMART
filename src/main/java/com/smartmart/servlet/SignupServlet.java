package com.smartmart.servlet;

import com.smartmart.dao.UserDAO;
import com.smartmart.model.User;
import com.smartmart.util.PasswordUtil;
import com.smartmart.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Handles new user registration (POST /signup).
 *
 * <p><b>Input:</b> fullName, email, phone, password, confirmPassword</p>
 * <p><b>Output:</b>
 *   <ul>
 *     <li>On success: redirects to login.jsp</li>
 *     <li>On validation failure: forwards back to signup.jsp with error attributes</li>
 *   </ul>
 * </p>
 * <p>New users are created with role="User" and approvalStatus="Pending".
 * An admin must approve them before they can log in.</p>
 */
@WebServlet("/signup")
public class SignupServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName        = request.getParameter("fullName");
        String email           = request.getParameter("email");
        String phone           = request.getParameter("phone");
        String password        = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        boolean hasError = false;

        // ── Empty check ────────────────────────────────────────
        if (ValidationUtil.isNullOrEmpty(fullName, email, phone, password, confirmPassword)) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        // ── Split full name ────────────────────────────────────
        String[] parts     = fullName.trim().split("\\s+", 2);
        String firstName   = parts[0];
        String lastName    = parts.length > 1 ? parts[1] : "";

        // ── Name validation ────────────────────────────────────
        if (!ValidationUtil.isAlphabetic(firstName)) {
            request.setAttribute("nameError", "First name must contain only letters.");
            hasError = true;
        }
        if (!lastName.isEmpty() && !lastName.matches("^[a-zA-Z ]+$")) {
            request.setAttribute("nameError", "Last name must contain only letters.");
            hasError = true;
        }

        // ── Email validation ───────────────────────────────────
        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("emailError", "Invalid email format.");
            hasError = true;
        } else if (userDAO.emailExists(email)) {
            request.setAttribute("emailError", "Email is already registered.");
            hasError = true;
        }

        // ── Phone validation ───────────────────────────────────
        if (!ValidationUtil.isValidPhoneNumber(phone)) {
            request.setAttribute("phoneError", "Phone must be a valid Nepal number (97/98XXXXXXXX).");
            hasError = true;
        }

        // ── Password validation ────────────────────────────────
        if (!ValidationUtil.isValidPassword(password)) {
            request.setAttribute("passwordError", "Password must be at least 8 characters.");
            hasError = true;
        } else if (!ValidationUtil.doPasswordsMatch(password, confirmPassword)) {
            request.setAttribute("confirmError", "Passwords do not match.");
            hasError = true;
        }

        if (hasError) {
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        // ── Build and persist user ─────────────────────────────
        User user = new User();
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setPassword(PasswordUtil.hashPassword(password));
        user.setRole("User");
        user.setApprovalStatus("Pending");

        if (userDAO.registerUser(user)) {
            request.setAttribute("success", "Registration successful! Please wait for admin approval.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        }
    }
}

package com.smartmart.filter;

import com.smartmart.model.User;
import com.smartmart.util.SessionUtil;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Servlet filter that enforces authentication and role-based access control.
 *
 * <ul>
 *   <li>Public routes (login, signup, static assets, home) pass through freely.</li>
 *   <li>Admin-only routes (/admin/*) redirect non-admins to the home page.</li>
 *   <li>All other protected routes redirect unauthenticated users to login.</li>
 *   <li>Logged-in users visiting login/signup are redirected to their dashboard.</li>
 * </ul>
 */
@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig config) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req = (HttpServletRequest)  request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri         = req.getRequestURI();
        String contextPath = req.getContextPath();

        // ── 1. Always allow static resources ──────────────────
        if (uri.endsWith(".css") || uri.endsWith(".js")
                || uri.endsWith(".png") || uri.endsWith(".jpg")
                || uri.endsWith(".jpeg") || uri.endsWith(".gif")
                || uri.endsWith(".ico") || uri.endsWith(".woff")
                || uri.endsWith(".woff2") || uri.endsWith(".ttf")) {
            chain.doFilter(request, response);
            return;
        }

        // ── 2. Always allow public servlet endpoints ───────────
        if (uri.contains("/login") || uri.contains("/signup")
                || uri.contains("/LoginServlet") || uri.contains("/SignupServlet")) {
            chain.doFilter(request, response);
            return;
        }

        // ── 3. Always allow public JSP pages ──────────────────
        if (uri.endsWith("login.jsp") || uri.endsWith("signup.jsp")
                || uri.endsWith("index.jsp") || uri.endsWith("/")
                || uri.endsWith("about.jsp") || uri.endsWith("contact.jsp")
                || uri.endsWith("products.jsp") || uri.endsWith("product_detail.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        User loggedInUser = (User) SessionUtil.getAttribute(req, "user");
        boolean isLoggedIn = (loggedInUser != null);

        // ── 4. Admin-only routes ───────────────────────────────
        if (uri.contains("/admin/") || uri.endsWith("dashboard.jsp")
                || uri.endsWith("product_mgmt.jsp") || uri.endsWith("category_mgmt.jsp")
                || uri.endsWith("supplier_mgmt.jsp") || uri.endsWith("order_mgmt.jsp")
                || uri.endsWith("user_mgmt.jsp") || uri.endsWith("reports.jsp")
                || uri.endsWith("settings.jsp")) {
            if (!isLoggedIn) {
                res.sendRedirect(contextPath + "/login.jsp");
                return;
            }
            if (!"Admin".equalsIgnoreCase(loggedInUser.getRole())) {
                res.sendRedirect(contextPath + "/index.jsp");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        // ── 5. User-only routes ────────────────────────────────
        if (uri.endsWith("profile.jsp") || uri.endsWith("my_orders.jsp")
                || uri.endsWith("dashboard_user.jsp") || uri.endsWith("change_password.jsp")
                || uri.endsWith("cart.jsp") || uri.endsWith("checkout.jsp")
                || uri.contains("/checkout") || uri.contains("/cart")
                || uri.contains("/profile") || uri.contains("/order")) {
            if (!isLoggedIn) {
                res.sendRedirect(contextPath + "/login.jsp");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        // ── 6. Redirect logged-in users away from auth pages ──
        if (isLoggedIn && (uri.endsWith("login.jsp") || uri.endsWith("signup.jsp"))) {
            if ("Admin".equalsIgnoreCase(loggedInUser.getRole())) {
                res.sendRedirect(contextPath + "/dashboard.jsp");
            } else {
                res.sendRedirect(contextPath + "/index.jsp");
            }
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}

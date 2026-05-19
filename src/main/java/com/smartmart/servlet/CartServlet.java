package com.smartmart.servlet;

import com.smartmart.dao.ProductDAO;
import com.smartmart.model.Product;
import com.smartmart.model.User;
import com.smartmart.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Controller for the server-side shopping cart.
 *
 * <p>The cart is stored in the session as {@code List<int[]>} where each
 * {@code int[]} is {@code {productId, quantity}}.</p>
 *
 * <p>POST /CartServlet with {@code action} parameter:
 * <ul>
 *   <li>{@code add}    — adds a product (or increments quantity)</li>
 *   <li>{@code remove} — removes a product from the cart</li>
 *   <li>{@code update} — sets a specific quantity for a product</li>
 *   <li>{@code clear}  — empties the cart</li>
 * </ul>
 * </p>
 * <p>GET /CartServlet — loads cart.jsp with cart items and totals.</p>
 */
@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User sessionUser = (User) SessionUtil.getAttribute(request, "user");
        if (sessionUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<int[]> cart = getCart(request);
        List<Product> cartProducts = new ArrayList<>();
        double total = 0.0;

        for (int[] entry : cart) {
            Product p = productDAO.getProductById(entry[0]);
            if (p != null) {
                // Attach quantity to product for JSP display via a wrapper approach
                // We use a simple parallel list approach: cartProducts + cart stay in sync
                cartProducts.add(p);
                total += p.getPrice() * entry[1];
            }
        }

        request.setAttribute("cart",         cart);
        request.setAttribute("cartProducts", cartProducts);
        request.setAttribute("cartTotal",    total);
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User sessionUser = (User) SessionUtil.getAttribute(request, "user");
        if (sessionUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action    = request.getParameter("action");
        String productIdStr = request.getParameter("productId");
        String quantityStr  = request.getParameter("quantity");

        List<int[]> cart = getCart(request);

        switch (action != null ? action : "") {
            case "add": {
                int productId = Integer.parseInt(productIdStr);
                int qty = (quantityStr != null && !quantityStr.isEmpty())
                          ? Integer.parseInt(quantityStr) : 1;
                addToCart(cart, productId, qty);
                break;
            }
            case "remove": {
                int productId = Integer.parseInt(productIdStr);
                cart.removeIf(e -> e[0] == productId);
                break;
            }
            case "update": {
                int productId = Integer.parseInt(productIdStr);
                int qty = Integer.parseInt(quantityStr);
                for (int[] entry : cart) {
                    if (entry[0] == productId) {
                        entry[1] = Math.max(1, qty);
                        break;
                    }
                }
                break;
            }
            case "clear":
                cart.clear();
                break;
            default:
                break;
        }

        SessionUtil.setAttribute(request, "cart", cart);

        // Redirect back to referring page or cart
        String referer = request.getHeader("Referer");
        response.sendRedirect(referer != null ? referer : "CartServlet");
    }

    /** Retrieves the cart from the session, creating an empty one if absent. */
    @SuppressWarnings("unchecked")
    private List<int[]> getCart(HttpServletRequest request) {
        List<int[]> cart = (List<int[]>) SessionUtil.getAttribute(request, "cart");
        if (cart == null) {
            cart = new ArrayList<>();
            SessionUtil.setAttribute(request, "cart", cart);
        }
        return cart;
    }

    /** Adds qty to an existing cart entry, or creates a new entry. */
    private void addToCart(List<int[]> cart, int productId, int qty) {
        for (int[] entry : cart) {
            if (entry[0] == productId) {
                entry[1] += qty;
                return;
            }
        }
        cart.add(new int[]{productId, qty});
    }
}

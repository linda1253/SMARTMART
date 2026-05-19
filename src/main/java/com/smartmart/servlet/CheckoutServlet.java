package com.smartmart.servlet;

import com.smartmart.dao.OrderDAO;
import com.smartmart.dao.ProductDAO;
import com.smartmart.model.Order;
import com.smartmart.model.OrderItem;
import com.smartmart.model.User;
import com.smartmart.model.Product;
import com.smartmart.util.SessionUtil;
import com.smartmart.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Controller for the checkout process.
 *
 * <p>POST /CheckoutServlet — places an order from the session cart.
 * <ul>
 *   <li>Reads cart items from the session ({@code cart} attribute)</li>
 *   <li>Validates delivery address</li>
 *   <li>Creates the order and decrements stock in a transaction</li>
 *   <li>Clears the session cart on success</li>
 *   <li>Redirects to order_success.jsp or back to checkout.jsp on failure</li>
 * </ul>
 * </p>
 */
@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {

    private final OrderDAO   orderDAO   = new OrderDAO();
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User sessionUser = (User) SessionUtil.getAttribute(request, "user");
        if (sessionUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String deliveryAddress = request.getParameter("deliveryAddress");
        if (ValidationUtil.isNullOrEmpty(deliveryAddress)) {
            request.setAttribute("checkoutError", "Delivery address is required.");
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
            return;
        }

        // Retrieve cart from session
        @SuppressWarnings("unchecked")
        List<int[]> cart = (List<int[]>) SessionUtil.getAttribute(request, "cart");
        // cart items: int[]{productId, quantity}

        if (cart == null || cart.isEmpty()) {
            request.setAttribute("checkoutError", "Your cart is empty.");
            request.getRequestDispatcher("cart.jsp").forward(request, response);
            return;
        }

        // Build order items and calculate total
        List<OrderItem> items = new ArrayList<>();
        double total = 0.0;

        for (int[] entry : cart) {
            int productId = entry[0];
            int quantity  = entry[1];
            Product product = productDAO.getProductById(productId);
            if (product == null || product.getStock() < quantity) {
                request.setAttribute("checkoutError",
                    "Product '" + (product != null ? product.getProductName() : "unknown")
                    + "' is out of stock or unavailable.");
                request.getRequestDispatcher("cart.jsp").forward(request, response);
                return;
            }
            OrderItem item = new OrderItem(productId, quantity, product.getPrice());
            items.add(item);
            total += product.getPrice() * quantity;
        }

        Order order = new Order();
        order.setUserId(sessionUser.getUserId());
        order.setDeliveryAddress(deliveryAddress.trim());
        order.setTotalAmount(total);
        order.setItems(items);

        int orderId = orderDAO.createOrder(order);

        if (orderId > 0) {
            // Clear cart from session
            SessionUtil.removeAttribute(request, "cart");
            request.setAttribute("orderId", orderId);
            request.setAttribute("orderTotal", total);
            request.getRequestDispatcher("order_success.jsp").forward(request, response);
        } else {
            request.setAttribute("checkoutError",
                "Order could not be placed. A product may be out of stock.");
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }
}

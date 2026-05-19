package com.smartmart.dao;

import com.smartmart.model.Order;
import com.smartmart.model.OrderItem;
import com.smartmart.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Order and OrderItem database operations.
 */
public class OrderDAO {

    // ── Read ──────────────────────────────────────────────────

    /**
     * Returns all orders with customer names (admin view), newest first.
     *
     * @return list of all {@link Order} objects
     */
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, CONCAT(u.FirstName,' ',u.LastName) AS CustomerName "
                   + "FROM Orders o JOIN User u ON o.UserId = u.UserId "
                   + "ORDER BY o.OrderDate DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Returns the 10 most recent orders (for the admin dashboard widget).
     *
     * @return list of up to 10 recent {@link Order} objects
     */
    public List<Order> getRecentOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, CONCAT(u.FirstName,' ',u.LastName) AS CustomerName "
                   + "FROM Orders o JOIN User u ON o.UserId = u.UserId "
                   + "ORDER BY o.OrderDate DESC LIMIT 10";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Returns all orders placed by a specific user.
     *
     * @param userId the user's ID
     * @return list of the user's {@link Order} objects
     */
    public List<Order> getOrdersByUser(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, CONCAT(u.FirstName,' ',u.LastName) AS CustomerName "
                   + "FROM Orders o JOIN User u ON o.UserId = u.UserId "
                   + "WHERE o.UserId = ? ORDER BY o.OrderDate DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Retrieves a single order with all its line items.
     *
     * @param orderId the order ID
     * @return the {@link Order} with items populated, or {@code null} if not found
     */
    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, CONCAT(u.FirstName,' ',u.LastName) AS CustomerName "
                   + "FROM Orders o JOIN User u ON o.UserId = u.UserId "
                   + "WHERE o.OrderId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = mapRow(rs);
                    order.setItems(getOrderItems(orderId));
                    return order;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Returns all line items for a given order.
     *
     * @param orderId the order ID
     * @return list of {@link OrderItem} objects
     */
    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, p.ProductName FROM OrderItem oi "
                   + "JOIN Product p ON oi.ProductId = p.ProductId "
                   + "WHERE oi.OrderId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setOrderItemId(rs.getInt("OrderItemId"));
                    item.setOrderId(rs.getInt("OrderId"));
                    item.setProductId(rs.getInt("ProductId"));
                    item.setProductName(rs.getString("ProductName"));
                    item.setQuantity(rs.getInt("Quantity"));
                    item.setPrice(rs.getDouble("Price"));
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    /**
     * Returns the total number of orders in the system.
     *
     * @return order count
     */
    public int getTotalOrderCount() {
        String sql = "SELECT COUNT(*) FROM Orders";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ── Write ─────────────────────────────────────────────────

    /**
     * Creates a new order and inserts all its line items in a single transaction.
     * Also decrements product stock for each item.
     *
     * @param order the order to create (items must be populated)
     * @return the generated orderId, or -1 on failure
     */
    public int createOrder(Order order) {
        String insertOrder = "INSERT INTO Orders (OrderDate, OrderStatus, TotalAmount, DeliveryAddress, UserId) "
                           + "VALUES (NOW(), 'Pending', ?, ?, ?)";
        String insertItem  = "INSERT INTO OrderItem (OrderId, ProductId, Quantity, Price) VALUES (?, ?, ?, ?)";
        String updateStock = "UPDATE Product SET Stock = Stock - ? WHERE ProductId = ? AND Stock >= ?";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Insert order header
            int orderId;
            try (PreparedStatement ps = conn.prepareStatement(insertOrder, Statement.RETURN_GENERATED_KEYS)) {
                ps.setDouble(1, order.getTotalAmount());
                ps.setString(2, order.getDeliveryAddress());
                ps.setInt(3, order.getUserId());
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (!keys.next()) { conn.rollback(); return -1; }
                    orderId = keys.getInt(1);
                }
            }

            // Insert line items and decrement stock
            for (OrderItem item : order.getItems()) {
                try (PreparedStatement ps = conn.prepareStatement(insertItem)) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, item.getProductId());
                    ps.setInt(3, item.getQuantity());
                    ps.setDouble(4, item.getPrice());
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement(updateStock)) {
                    ps.setInt(1, item.getQuantity());
                    ps.setInt(2, item.getProductId());
                    ps.setInt(3, item.getQuantity());
                    int updated = ps.executeUpdate();
                    if (updated == 0) {
                        conn.rollback();
                        return -1; // insufficient stock
                    }
                }
            }

            conn.commit();
            return orderId;

        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { ex.printStackTrace(); }
        }
        return -1;
    }

    /**
     * Updates the status of an order (Admin action).
     *
     * @param orderId the order ID
     * @param status  new status string
     * @return {@code true} if the update succeeded
     */
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE Orders SET OrderStatus=? WHERE OrderId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Maps the current ResultSet row to an Order object. */
    private Order mapRow(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("OrderId"));
        Timestamp ts = rs.getTimestamp("OrderDate");
        if (ts != null) o.setOrderDate(ts.toLocalDateTime());
        o.setOrderStatus(rs.getString("OrderStatus"));
        o.setTotalAmount(rs.getDouble("TotalAmount"));
        o.setDeliveryAddress(rs.getString("DeliveryAddress"));
        o.setUserId(rs.getInt("UserId"));
        o.setCustomerName(rs.getString("CustomerName"));
        return o;
    }
}

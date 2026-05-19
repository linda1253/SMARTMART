package com.smartmart.dao;

import com.smartmart.model.Product;
import com.smartmart.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Product-related database operations.
 */
public class ProductDAO {

    // ── Read ──────────────────────────────────────────────────

    /**
     * Returns all products joined with their category and supplier names.
     *
     * @return list of all {@link Product} objects
     */
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, c.CategoryName, s.SupplierName "
                   + "FROM Product p "
                   + "JOIN Category c ON p.CategoryId = c.CategoryId "
                   + "LEFT JOIN Supplier s ON p.SupplierId = s.SupplierId "
                   + "ORDER BY p.ProductName";
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
     * Returns products filtered by category.
     *
     * @param categoryId the category to filter by
     * @return list of matching {@link Product} objects
     */
    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, c.CategoryName, s.SupplierName "
                   + "FROM Product p "
                   + "JOIN Category c ON p.CategoryId = c.CategoryId "
                   + "LEFT JOIN Supplier s ON p.SupplierId = s.SupplierId "
                   + "WHERE p.CategoryId = ? ORDER BY p.ProductName";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Retrieves a single product by its primary key.
     *
     * @param productId the product ID
     * @return the {@link Product}, or {@code null} if not found
     */
    public Product getProductById(int productId) {
        String sql = "SELECT p.*, c.CategoryName, s.SupplierName "
                   + "FROM Product p "
                   + "JOIN Category c ON p.CategoryId = c.CategoryId "
                   + "LEFT JOIN Supplier s ON p.SupplierId = s.SupplierId "
                   + "WHERE p.ProductId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Returns the total number of products in the store.
     *
     * @return product count
     */
    public int getTotalProductCount() {
        String sql = "SELECT COUNT(*) FROM Product";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Returns the total revenue from all completed order items.
     *
     * @return total sales amount
     */
    public double getTotalSales() {
        String sql = "SELECT COALESCE(SUM(oi.Quantity * oi.Price), 0) "
                   + "FROM OrderItem oi "
                   + "JOIN Orders o ON oi.OrderId = o.OrderId "
                   + "WHERE o.OrderStatus = 'Completed'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    /**
     * Returns the number of products with stock below 10.
     *
     * @return low-stock product count
     */
    public int getLowStockCount() {
        String sql = "SELECT COUNT(*) FROM Product WHERE Stock < 10";
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
     * Inserts a new product into the database.
     *
     * @param product the product to add
     * @return {@code true} if the insert succeeded
     */
    public boolean addProduct(Product product) {
        String sql = "INSERT INTO Product (ProductName, Description, Price, Stock, CategoryId, SupplierId) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, product.getProductName());
            ps.setString(2, product.getDescription());
            ps.setDouble(3, product.getPrice());
            ps.setInt(4, product.getStock());
            ps.setInt(5, product.getCategoryId());
            if (product.getSupplierId() != null) ps.setInt(6, product.getSupplierId());
            else ps.setNull(6, Types.INTEGER);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Updates an existing product.
     *
     * @param product product with updated fields (productId must be set)
     * @return {@code true} if the update succeeded
     */
    public boolean updateProduct(Product product) {
        String sql = "UPDATE Product SET ProductName=?, Description=?, Price=?, Stock=?, "
                   + "CategoryId=?, SupplierId=? WHERE ProductId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, product.getProductName());
            ps.setString(2, product.getDescription());
            ps.setDouble(3, product.getPrice());
            ps.setInt(4, product.getStock());
            ps.setInt(5, product.getCategoryId());
            if (product.getSupplierId() != null) ps.setInt(6, product.getSupplierId());
            else ps.setNull(6, Types.INTEGER);
            ps.setInt(7, product.getProductId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Deletes a product by ID.
     *
     * @param productId the product ID to delete
     * @return {@code true} if the delete succeeded
     */
    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM Product WHERE ProductId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Maps the current ResultSet row to a Product object. */
    private Product mapRow(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setProductId(rs.getInt("ProductId"));
        p.setProductName(rs.getString("ProductName"));
        p.setDescription(rs.getString("Description"));
        p.setPrice(rs.getDouble("Price"));
        p.setStock(rs.getInt("Stock"));
        p.setCategoryId(rs.getInt("CategoryId"));
        p.setCategoryName(rs.getString("CategoryName"));
        int sid = rs.getInt("SupplierId");
        if (!rs.wasNull()) {
            p.setSupplierId(sid);
            p.setSupplierName(rs.getString("SupplierName"));
        }
        return p;
    }
}

package com.smartmart.dao;

import com.smartmart.model.Category;
import com.smartmart.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Category-related database operations.
 */
public class CategoryDAO {

    /**
     * Returns all categories ordered by name.
     *
     * @return list of all {@link Category} objects
     */
    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM Category ORDER BY CategoryName";
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
     * Retrieves a single category by its primary key.
     *
     * @param categoryId the category ID
     * @return the {@link Category}, or {@code null} if not found
     */
    public Category getCategoryById(int categoryId) {
        String sql = "SELECT * FROM Category WHERE CategoryId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Inserts a new category.
     *
     * @param category the category to add
     * @return {@code true} if the insert succeeded
     */
    public boolean addCategory(Category category) {
        String sql = "INSERT INTO Category (CategoryName, Description) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Updates an existing category.
     *
     * @param category category with updated fields (categoryId must be set)
     * @return {@code true} if the update succeeded
     */
    public boolean updateCategory(Category category) {
        String sql = "UPDATE Category SET CategoryName=?, Description=? WHERE CategoryId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.setInt(3, category.getCategoryId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Deletes a category by ID.
     * Will fail if products still reference this category (FK constraint).
     *
     * @param categoryId the category ID to delete
     * @return {@code true} if the delete succeeded
     */
    public boolean deleteCategory(int categoryId) {
        String sql = "DELETE FROM Category WHERE CategoryId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Maps the current ResultSet row to a Category object. */
    private Category mapRow(ResultSet rs) throws SQLException {
        return new Category(
            rs.getInt("CategoryId"),
            rs.getString("CategoryName"),
            rs.getString("Description")
        );
    }
}

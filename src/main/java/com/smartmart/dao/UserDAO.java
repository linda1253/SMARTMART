package com.smartmart.dao;

import com.smartmart.model.User;
import com.smartmart.util.DBConnection;
import com.smartmart.util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for User-related database operations.
 */
public class UserDAO {

    // ── Read ──────────────────────────────────────────────────

    /**
     * Checks whether an email address is already registered.
     *
     * @param email email to check
     * @return {@code true} if the email exists in the database
     */
    public boolean emailExists(String email) {
        String sql = "SELECT 1 FROM User WHERE Email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Authenticates a user by email and password.
     * Only users with ApprovalStatus = 'Approved' can log in.
     *
     * @param email    user's email
     * @param password plain-text password to verify
     * @return the matching {@link User} object, or {@code null} if credentials are invalid
     */
    public User loginUser(String email, String password) {
        String sql = "SELECT * FROM User WHERE Email = ? AND ApprovalStatus = 'Approved'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("Password");
                    if (PasswordUtil.verifyPassword(password, storedHash)) {
                        return mapRow(rs);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Retrieves a user by their primary key.
     *
     * @param userId the user's ID
     * @return the {@link User}, or {@code null} if not found
     */
    public User getUserById(int userId) {
        String sql = "SELECT * FROM User WHERE UserId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Returns all users in the system (admin view).
     *
     * @return list of all {@link User} objects
     */
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM User ORDER BY CreatedAt DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) users.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    /**
     * Returns the total number of customers (Role = 'User').
     *
     * @return customer count
     */
    public int getCustomerCount() {
        String sql = "SELECT COUNT(*) FROM User WHERE Role = 'User'";
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
     * Inserts a new user into the database.
     * The password in the User object must already be BCrypt-hashed.
     *
     * @param user the user to register
     * @return {@code true} if the insert succeeded
     */
    public boolean registerUser(User user) {
        String sql = "INSERT INTO User (FirstName, LastName, Email, Phone, Password, Role, ApprovalStatus) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFirstName());
            ps.setString(2, user.getLastName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getPassword());
            ps.setString(6, user.getRole());
            ps.setString(7, user.getApprovalStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Updates a user's profile (name, email, phone).
     *
     * @param user user with updated fields (userId must be set)
     * @return {@code true} if the update succeeded
     */
    public boolean updateProfile(User user) {
        String sql = "UPDATE User SET FirstName=?, LastName=?, Email=?, Phone=? WHERE UserId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFirstName());
            ps.setString(2, user.getLastName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhone());
            ps.setInt(5, user.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Updates a user's password (expects a pre-hashed password).
     *
     * @param userId         the user's ID
     * @param hashedPassword the new BCrypt-hashed password
     * @return {@code true} if the update succeeded
     */
    public boolean updatePassword(int userId, String hashedPassword) {
        String sql = "UPDATE User SET Password=? WHERE UserId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Updates a user's approval status (Admin action: Approve / Reject).
     *
     * @param userId the user's ID
     * @param status "Approved" or "Pending"
     * @return {@code true} if the update succeeded
     */
    public boolean updateApprovalStatus(int userId, String status) {
        String sql = "UPDATE User SET ApprovalStatus=? WHERE UserId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Deletes a user by ID.
     *
     * @param userId the user's ID
     * @return {@code true} if the delete succeeded
     */
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM User WHERE UserId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ── Helper ────────────────────────────────────────────────

    /** Maps the current ResultSet row to a User object. */
    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("UserId"));
        u.setFirstName(rs.getString("FirstName"));
        u.setLastName(rs.getString("LastName"));
        u.setEmail(rs.getString("Email"));
        u.setPassword(rs.getString("Password"));
        u.setPhone(rs.getString("Phone"));
        u.setRole(rs.getString("Role"));
        u.setApprovalStatus(rs.getString("ApprovalStatus"));
        Timestamp ts = rs.getTimestamp("CreatedAt");
        if (ts != null) u.setCreatedAt(ts.toLocalDateTime());
        return u;
    }
}

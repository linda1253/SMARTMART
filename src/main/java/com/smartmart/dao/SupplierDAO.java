package com.smartmart.dao;

import com.smartmart.model.Supplier;
import com.smartmart.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Supplier-related database operations.
 */
public class SupplierDAO {

    /**
     * Returns all suppliers ordered by name.
     *
     * @return list of all {@link Supplier} objects
     */
    public List<Supplier> getAllSuppliers() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT * FROM Supplier ORDER BY SupplierName";
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
     * Retrieves a single supplier by primary key.
     *
     * @param supplierId the supplier ID
     * @return the {@link Supplier}, or {@code null} if not found
     */
    public Supplier getSupplierById(int supplierId) {
        String sql = "SELECT * FROM Supplier WHERE SupplierId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Inserts a new supplier.
     *
     * @param supplier the supplier to add
     * @return {@code true} if the insert succeeded
     */
    public boolean addSupplier(Supplier supplier) {
        String sql = "INSERT INTO Supplier (SupplierName, ContactName, Email, Phone, Address) "
                   + "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, supplier.getSupplierName());
            ps.setString(2, supplier.getContactName());
            ps.setString(3, supplier.getEmail());
            ps.setString(4, supplier.getPhone());
            ps.setString(5, supplier.getAddress());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Updates an existing supplier.
     *
     * @param supplier supplier with updated fields (supplierId must be set)
     * @return {@code true} if the update succeeded
     */
    public boolean updateSupplier(Supplier supplier) {
        String sql = "UPDATE Supplier SET SupplierName=?, ContactName=?, Email=?, Phone=?, Address=? "
                   + "WHERE SupplierId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, supplier.getSupplierName());
            ps.setString(2, supplier.getContactName());
            ps.setString(3, supplier.getEmail());
            ps.setString(4, supplier.getPhone());
            ps.setString(5, supplier.getAddress());
            ps.setInt(6, supplier.getSupplierId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Deletes a supplier by ID.
     *
     * @param supplierId the supplier ID to delete
     * @return {@code true} if the delete succeeded
     */
    public boolean deleteSupplier(int supplierId) {
        String sql = "DELETE FROM Supplier WHERE SupplierId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Maps the current ResultSet row to a Supplier object. */
    private Supplier mapRow(ResultSet rs) throws SQLException {
        return new Supplier(
            rs.getInt("SupplierId"),
            rs.getString("SupplierName"),
            rs.getString("ContactName"),
            rs.getString("Email"),
            rs.getString("Phone"),
            rs.getString("Address")
        );
    }
}

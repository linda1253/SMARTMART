package com.smartmart.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utility class for obtaining a JDBC connection to the MySQL database.
 * Update URL, USERNAME, and PASSWORD to match your environment.
 */
public class DBConnection {

    private static final String URL      = "jdbc:mysql://localhost:3306/DepartmentStore?useSSL=false&serverTimezone=UTC";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "";   // change for production

    /**
     * Returns a new JDBC Connection.
     * Throws RuntimeException if the driver is missing or the DB is unreachable.
     */
    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            throw new RuntimeException("Database connection failed: " + e.getMessage(), e);
        }
    }
}

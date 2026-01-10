package com.flowershop;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DBUtil {

    // JDBC connection settings (update to match your local MySQL configuration)
    private static final String URL =
            "jdbc:mysql://localhost:3306/flowershop_db?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASS = "123456shuo";

    /**
     * Creates and returns a new database connection.
     * Uses MySQL Connector/J (CJ driver) for MySQL 8.0+.
     */
    public static Connection getConnection() throws Exception {
        // Ensure the MySQL JDBC driver is loaded
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASS);
    }

    /**
     * Checks whether the given username/password exists in the users table.
     * Returns true if a matching record is found.
     */
    public boolean validateUser(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";

        // try-with-resources automatically closes Connection / PreparedStatement / ResultSet
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Bind parameters to prevent SQL injection
            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                // rs.next() is true if at least one row matches
                return rs.next();
            }
        } catch (Exception e) {
            // Any DB or driver error -> treat as invalid login
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Returns the role (e.g., "admin" or "customer") for the given username.
     * Falls back to "customer" if not found or on error.
     */
    public String getUserRole(String username) {
        String sql = "SELECT role FROM users WHERE username = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("role");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Default role if user not found or query failed
        return "customer";
    }

    /**
     * Registers a new user with default role "customer".
     * Returns true if insertion succeeds.
     */
    public boolean registerUser(String username, String password) {
        String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, 'customer')";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            // executeUpdate() returns affected row count
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            // Insert may fail due to duplicate username, DB issues, etc.
            e.printStackTrace();
            return false;
        }
    }
}

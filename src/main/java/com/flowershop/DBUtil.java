package com.flowershop;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DBUtil {
    // Database connection parameters
    private static final String URL = "jdbc:mysql://localhost:3306/flowershop_db?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASS = "123456shuo";

    /**
     * Establishes a connection to the MySQL database.
     * @return Connection object
     * @throws Exception if driver not found or connection fails
     */
    public static Connection getConnection() throws Exception {
        // Load MySQL JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASS);
    }

    /**
     * Validates user credentials during login.
     * Checks if the username and password exist in the 'users' table.
     * @param username Input username
     * @param password Input password
     * @return true if credentials are valid, false otherwise
     */
    public boolean validateUser(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                // If a record is found, credentials are correct
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Retrieves the role of a specific user (e.g., 'admin' or 'customer').
     * @param username The username to look up
     * @return The role string from the database
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
        // Default role if not found
        return "customer";
    }

    /**
     * Registers a new user account into the database.
     * By default, new registrations are assigned the 'customer' role.
     * @param username New username
     * @param password New password
     * @return true if registration is successful, false if username exists or error occurs
     */
    public boolean registerUser(String username, String password) {
        String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, 'customer')";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            int rowsAffected = ps.executeUpdate();
            // Returns true if one row was successfully inserted
            return rowsAffected > 0;
        } catch (Exception e) {
            // Usually fails if the username violates the UNIQUE constraint
            e.printStackTrace();
            return false;
        }
    }
}
package com.flowershop;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DBUtil {
    // Database connection parameters: Ensure URL, USER, and PASS match your local MySQL settings
    private static final String URL = "jdbc:mysql://localhost:3306/flowershop_db?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASS = "@LHlh1251136972";

    /**
     * Establishes a connection to the MySQL database using the CJ driver for MySQL 8.0+
     */
    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASS);
    }

    /**
     * Validates if the username and password match a record in the database
     */
    public boolean validateUser(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        // Using try-with-resources to automatically close database resources
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Returns true if credentials are valid
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Gets the role ('admin' or 'customer') for a specific user
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
        return "customer"; // Default fallback role
    }

    /**
     * Inserts a new user with 'customer' as the default role
     */
    public boolean registerUser(String username, String password) {
        String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, 'customer')";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
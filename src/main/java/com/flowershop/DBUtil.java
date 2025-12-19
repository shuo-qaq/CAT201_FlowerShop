package com.flowershop;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBUtil {
    // Database connection URL pointing to flowershop_db
    private static final String URL = "jdbc:mysql://localhost:3306/flowershop_db?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    // IMPORTANT: Replace '123456' with the password you verified during MySQL installation
    private static final String PASS = "123456shuo";

    public static Connection getConnection() throws Exception {
        // Load the MySQL JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASS);
    }
}

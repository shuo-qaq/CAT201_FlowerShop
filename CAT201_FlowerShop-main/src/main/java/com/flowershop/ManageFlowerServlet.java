package com.flowershop;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/manageFlower")
public class ManageFlowerServlet extends HttpServlet {

    private DBUtil dbUtil = new DBUtil();

    /**
     * Handles GET requests: Logout and Delete operations
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        // 1. Process Logout: Invalidate session and redirect to portal index
        if ("logout".equals(action)) {
            session.invalidate();
            response.sendRedirect("index.jsp");
            return;
        }

        // 2. Security Check: Only admins are allowed to perform deletion
        String role = (String) session.getAttribute("role");
        if (!"admin".equals(role)) {
            response.sendRedirect("admin_login.jsp");
            return;
        }

        // 3. Process Flower Deletion by ID
        if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                executeSql("DELETE FROM flowers WHERE id = ?", id);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        // Redirect back to management dashboard after deletion
        response.sendRedirect("showFlowers?target=management");
    }

    /**
     * Handles POST requests: Login, Register, Add, and Update operations
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set character encoding to support Chinese characters in form inputs
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("login".equals(action)) {
            handleLogin(request, response);
        } else if ("register".equals(action)) {
            handleRegister(request, response);
        } else {
            // Administrative tasks: Add or Update flowers
            HttpSession session = request.getSession();
            String role = (String) session.getAttribute("role");
            if ("admin".equals(role)) {
                processFlowerManagement(request, action);
                response.sendRedirect("showFlowers?target=management");
            } else {
                response.sendRedirect("admin_login.jsp");
            }
        }
    }

    /**
     * Authenticates users and routes back to the specific login page on failure to avoid 404
     */
    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        // loginType is sent via hidden input to identify the source (Admin vs Customer)
        String loginType = request.getParameter("loginType");

        HttpSession session = request.getSession();

        if (dbUtil.validateUser(user, pass)) {
            String role = dbUtil.getUserRole(user);
            session.setAttribute("user", user);
            session.setAttribute("role", role);

            // Redirect based on user role
            if ("admin".equals(role)) {
                response.sendRedirect("showFlowers?target=management");
            } else {
                response.sendRedirect("showFlowers");
            }
        } else {
            // FIX 404: Use loginType to decide which page to return to
            if ("admin".equals(loginType)) {
                response.sendRedirect("admin_login.jsp?status=failed");
            } else {
                response.sendRedirect("user_login.jsp?status=failed");
            }
        }
    }

    /**
     * Handles user registration and redirects to user login page
     */
    private void handleRegister(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        if (dbUtil.registerUser(user, pass)) {
            // Registration success: Redirect to customer login
            response.sendRedirect("user_login.jsp?status=registered");
        } else {
            // Registration failure: Redirect back to registration page
            response.sendRedirect("register.jsp?error=exists");
        }
    }

    /**
     * Common method to handle Add and Update SQL operations
     */
    private void processFlowerManagement(HttpServletRequest request, String action) {
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String imageUrl = request.getParameter("imageUrl");
        String description = request.getParameter("description");

        double price = 0.0;
        try {
            String priceStr = request.getParameter("price");
            if (priceStr != null) price = Double.parseDouble(priceStr);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        if ("add".equals(action)) {
            executeSql("INSERT INTO flowers (name, price, category, image_url, description) VALUES (?, ?, ?, ?, ?)",
                    name, price, category, imageUrl, description);
        } else if ("update".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                executeSql("UPDATE flowers SET name = ?, price = ?, category = ?, image_url = ?, description = ? WHERE id = ?",
                        name, price, category, imageUrl, description, id);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * General helper to execute SQL Update statements using DBUtil connection
     */
    private void executeSql(String sql, Object... params) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
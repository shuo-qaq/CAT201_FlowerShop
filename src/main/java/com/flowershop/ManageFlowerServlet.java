package com.flowershop;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * ManageFlowerServlet handles authentication (via database) and administrative
 * flower management (CRUD) operations.
 */
@WebServlet("/manageFlower")
public class ManageFlowerServlet extends HttpServlet {

    // Instance of DBUtil to access database logic
    private DBUtil dbUtil = new DBUtil();

    /**
     * Handles GET requests: LOGOUT and DELETE actions.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        // 1. Process Logout
        if ("logout".equals(action)) {
            session.invalidate();
            response.sendRedirect("showFlowers");
            return;
        }

        // 2. Admin Security Check for Delete Action
        String role = (String) session.getAttribute("role");
        if (!"admin".equals(role)) {
            response.sendRedirect("admin_login.jsp");
            return;
        }

        if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                // You can add a delete method in DBUtil or use direct SQL
                executeSql("DELETE FROM flowers WHERE id = ?", id);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect("showFlowers?target=management");
    }

    /**
     * Handles POST requests: LOGIN and REGISTER actions.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        // 1. Process Login
        if ("login".equals(action)) {
            handleLogin(request, response);
        }
        // 2. Process Registration
        else if ("register".equals(action)) {
            handleRegister(request, response);
        }
        // 3. Process Flower Management (Only for logged-in admins)
        else {
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
     * Authenticates users against the database.
     * Replaces the previous "any credentials" logic.
     */
    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        HttpSession session = request.getSession();

        // Database-driven validation
        if (dbUtil.validateUser(user, pass)) {
            String role = dbUtil.getUserRole(user);
            session.setAttribute("user", user);
            session.setAttribute("role", role);

            // Redirect based on role
            if ("admin".equals(role)) {
                response.sendRedirect("showFlowers?target=management");
            } else {
                response.sendRedirect("showFlowers");
            }
        } else {
            // Redirect back with error message if authentication fails
            response.sendRedirect("user_login.jsp?error=invalid");
        }
    }

    /**
     * Handles new user account creation.
     */
    private void handleRegister(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        if (dbUtil.registerUser(user, pass)) {
            // Success: Proceed to login page
            response.sendRedirect("user_login.jsp?status=registered");
        } else {
            // Failure: User might already exist
            response.sendRedirect("register.jsp?error=exists");
        }
    }

    /**
     * Helper to handle Add or Update flower data.
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
     * Utility method to execute SQL updates using DBUtil connection.
     */
    private void executeSql(String sql, Object... params) {
        try (java.sql.Connection conn = DBUtil.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
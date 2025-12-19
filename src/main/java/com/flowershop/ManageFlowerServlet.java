package com.flowershop;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

/**
 * ManageFlowerServlet handles multi-role authentication and administrative
 * flower management (CRUD) operations.
 */
@WebServlet("/manageFlower")
public class ManageFlowerServlet extends HttpServlet {

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

        // 2. Admin Role Security Check for Deletion
        String role = (String) session.getAttribute("role");
        if (!"admin".equals(role)) {
            response.sendRedirect("admin_login.jsp");
            return;
        }

        // 3. Process Delete Action
        if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                executeSql("DELETE FROM flowers WHERE id = ?", id);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect("showFlowers?target=management");
    }

    /**
     * Handles POST requests: LOGIN (Admin/User), ADD, and UPDATE actions.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        // 1. Unified Login Logic with Role Separation
        if ("login".equals(action)) {
            String userParam = request.getParameter("username");
            String passParam = request.getParameter("password");
            String loginType = request.getParameter("loginType"); // "admin" or "customer"

            if ("admin".equals(loginType)) {
                // ADMIN LOGIN: Strict database verification
                handleAdminLogin(userParam, passParam, session, response);
            } else {
                // USER LOGIN: Dummy flow - allows any credentials for demonstration
                session.setAttribute("user", userParam);
                session.setAttribute("role", "customer");
                response.sendRedirect("showFlowers");
            }
            return;
        }

        // 2. Admin Security Check for Modification Actions (Add/Update)
        String role = (String) session.getAttribute("role");
        if (!"admin".equals(role)) {
            response.sendRedirect("admin_login.jsp");
            return;
        }

        // 3. Process Flower Management (Add/Update)
        processFlowerManagement(request, action);

        response.sendRedirect("showFlowers?target=management");
    }

    /**
     * Private helper to handle strict Admin database authentication.
     */
    private void handleAdminLogin(String user, String pass, HttpSession session, HttpServletResponse response) throws IOException {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement("SELECT role FROM users WHERE username = ? AND password = ? AND role = 'admin'")) {

            pstmt.setString(1, user);
            pstmt.setString(2, pass);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    session.setAttribute("user", user);
                    session.setAttribute("role", "admin");
                    response.sendRedirect("showFlowers?target=management");
                } else {
                    response.sendRedirect("admin_login.jsp?status=failed");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin_login.jsp?status=failed");
        }
    }

    /**
     * Private helper to extract parameters and execute Add or Update SQL.
     */
    private void processFlowerManagement(HttpServletRequest request, String action) {
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String imageUrl = request.getParameter("imageUrl");

        double price = 0.0;
        try {
            String priceStr = request.getParameter("price");
            if (priceStr != null) price = Double.parseDouble(priceStr);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        if ("add".equals(action)) {
            executeSql("INSERT INTO flowers (name, price, category, image_url) VALUES (?, ?, ?, ?)",
                    name, price, category, imageUrl);
        } else if ("update".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                executeSql("UPDATE flowers SET name = ?, price = ?, category = ?, image_url = ? WHERE id = ?",
                        name, price, category, imageUrl, id);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Utility method to execute SQL updates securely.
     */
    private void executeSql(String sql, Object... params) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
package com.flowershop;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/manageFlower")
public class ManageFlowerServlet extends HttpServlet {

    // Handles DELETE and LOGOUT
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("logout".equals(action)) {
            session.invalidate();
            response.sendRedirect("index.jsp");
            return;
        }

        // Check if admin is logged in
        if (session.getAttribute("isAdmin") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                executeSql("DELETE FROM flowers WHERE id=?", id);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect("showFlowers?target=management");
    }

    // Handles LOGIN, ADD, and UPDATE
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        // 1. Login Logic
        if ("login".equals(action)) {
            String user = request.getParameter("username");
            String pass = request.getParameter("password");
            // You can change "123456" to your preferred password
            if ("admin".equals(user) && "123456".equals(pass)) {
                session.setAttribute("isAdmin", true);
                response.sendRedirect("showFlowers?target=management");
            } else {
                response.sendRedirect("login.jsp?status=failed");
            }
            return;
        }

        // 2. Security Check for Admin Actions
        if (session.getAttribute("isAdmin") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 3. Process Add or Update
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String imageUrl = request.getParameter("imageUrl");

        // Use try-catch for double conversion to avoid crashes on invalid input
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
                executeSql("UPDATE flowers SET name=?, price=?, category=?, image_url=? WHERE id=?",
                        name, price, category, imageUrl, id);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // Redirect to refresh the list in management page
        response.sendRedirect("showFlowers?target=management");
    }

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
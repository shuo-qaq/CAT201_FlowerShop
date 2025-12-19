package com.flowershop;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/showFlowers")
public class FlowerServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Flower> flowerList = new ArrayList<>();

        // 1. Get parameters for filtering and navigation
        String filterCategory = request.getParameter("category");
        String target = request.getParameter("target");

        // 2. Construct dynamic SQL query
        StringBuilder sql = new StringBuilder("SELECT id, name, price, category, image_url FROM flowers");
        boolean isFiltering = (filterCategory != null && !filterCategory.isEmpty() && !filterCategory.equalsIgnoreCase("all"));

        if (isFiltering) {
            sql.append(" WHERE category = ?");
        }

        // 3. Database operations using try-with-resources
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            if (isFiltering) {
                pstmt.setString(1, filterCategory);
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    flowerList.add(new Flower(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getDouble("price"),
                            rs.getString("category"),
                            rs.getString("image_url")
                    ));
                }
            }
        } catch (SQLException e) {
            // Error logging
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 4. Set attribute for JSP rendering
        request.setAttribute("allFlowers", flowerList);

        // 5. Routing logic based on target parameter
        // If target is 'management', go to management page; otherwise, go to shop page.
        String destination = "/shop.jsp";
        if ("management".equalsIgnoreCase(target)) {
            destination = "/management.jsp";
        }

        request.getRequestDispatcher(destination).forward(request, response);
    }
}
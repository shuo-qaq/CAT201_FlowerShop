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
        // IMPORTANT: Added 'description' to the SELECT statement
        StringBuilder sql = new StringBuilder("SELECT id, name, price, category, image_url, description FROM flowers");
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
                    // IMPORTANT: Pass 6 arguments to the constructor to match the updated Flower class
                    flowerList.add(new Flower(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getDouble("price"),
                            rs.getString("category"),
                            rs.getString("image_url"),
                            rs.getString("description") // This line fixes the red error
                    ));
                }
            }
        } catch (SQLException e) {
            // Error logging
            System.err.println("SQL Error in FlowerServlet: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 4. Set attribute for JSP rendering
        request.setAttribute("allFlowers", flowerList);

        // 5. Routing logic based on target parameter
        String destination = "/shop.jsp";
        if ("management".equalsIgnoreCase(target)) {
            destination = "/management.jsp";
        }

        request.getRequestDispatcher(destination).forward(request, response);
    }
}
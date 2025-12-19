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

        // 1. Get optional category filter from request (e.g., showFlowers?category=Tools)
        String filterCategory = request.getParameter("category");

        // 2. Build Dynamic SQL based on category filter
        String sql = "SELECT id, name, price, category, image_url FROM flowers";
        if (filterCategory != null && !filterCategory.isEmpty() && !filterCategory.equals("All")) {
            sql += " WHERE category = ?";
        }

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            // 3. Set parameter if filtering is active
            if (filterCategory != null && !filterCategory.isEmpty() && !filterCategory.equals("All")) {
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
        } catch (Exception e) {
            // Log the error for debugging
            e.printStackTrace();
        }

        // 4. Send data to JSP
        request.setAttribute("allFlowers", flowerList);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
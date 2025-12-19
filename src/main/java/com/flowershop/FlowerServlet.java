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

        // 1. Get optional category filter from request
        String filterCategory = request.getParameter("category");

        // 2. Build Dynamic SQL
        String sql = "SELECT id, name, price, category, image_url FROM flowers";
        if (filterCategory != null && !filterCategory.isEmpty() && !filterCategory.equalsIgnoreCase("all")) {
            sql += " WHERE category = ?";
        }

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            // 3. Set parameter if filtering is applied
            if (filterCategory != null && !filterCategory.isEmpty() && !filterCategory.equalsIgnoreCase("all")) {
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
            e.printStackTrace();
        }

        // 4. Send data to the dedicated SHOP page (shop.jsp)
        request.setAttribute("allFlowers", flowerList);

        // CRITICAL CHANGE: Forward to shop.jsp instead of index.jsp
        request.getRequestDispatcher("/shop.jsp").forward(request, response);
    }
}
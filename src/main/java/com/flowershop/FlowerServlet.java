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

        // Updated SQL to include ID, Category, and Image_URL
        String sql = "SELECT id, name, price, category, image_url FROM flowers";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                // Matching the new fields in your database and Flower class
                int id = rs.getInt("id");
                String name = rs.getString("name");
                double price = rs.getDouble("price");
                String category = rs.getString("category");
                String imageUrl = rs.getString("image_url");

                // Using the updated constructor
                flowerList.add(new Flower(id, name, price, category, imageUrl));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("allFlowers", flowerList);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
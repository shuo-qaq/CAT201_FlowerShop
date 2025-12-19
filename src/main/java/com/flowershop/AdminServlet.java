package com.flowershop;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 * Servlet handling administrative data input
 */
@WebServlet("/adminAction")
public class AdminServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve input parameters from the web form
        String name = request.getParameter("name");
        String priceStr = request.getParameter("price");
        String category = request.getParameter("category");

        double price = Double.parseDouble(priceStr);

        // Database insert logic demonstrating Java processing requirement
        String sql = "INSERT INTO flowers (name, price, category, image_url) VALUES (?, ?, ?, 'default.jpg')";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, name);
            pstmt.setDouble(2, price);
            pstmt.setString(3, category);

            int result = pstmt.executeUpdate();

            if (result > 0) {
                // Redirect back to shop to see the new item
                response.sendRedirect("showFlowers");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Database Error: " + e.getMessage());
        }
    }
}
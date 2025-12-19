package com.flowershop;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet("/productDetails")
public class ProductDetailServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get the product ID from the request parameter
        String idStr = request.getParameter("id");
        Flower flower = null;

        if (idStr != null && !idStr.isEmpty()) {
            try {
                // 2. Database connection and query
                Connection conn = DBUtil.getConnection();
                String sql = "SELECT id, name, price, category, image_url FROM flowers WHERE id = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(idStr));

                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    flower = new Flower(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getDouble("price"),
                            rs.getString("category"),
                            rs.getString("image_url")
                    );
                }

                // Close resources
                rs.close();
                pstmt.close();
                conn.close();

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // 3. Forward the flower object to details.jsp
        request.setAttribute("flower", flower);
        request.getRequestDispatcher("/details.jsp").forward(request, response);
    }
}
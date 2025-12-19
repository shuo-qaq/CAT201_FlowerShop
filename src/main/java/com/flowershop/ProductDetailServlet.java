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

        String idStr = request.getParameter("id");
        Flower flower = null;

        if (idStr != null && !idStr.isEmpty()) {
            // Ensure 'description' is included in the SELECT statement
            String sql = "SELECT id, name, price, category, image_url, description FROM flowers WHERE id = ?";

            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {

                pstmt.setInt(1, Integer.parseInt(idStr));

                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        // Crucial: The order of arguments must match the Constructor
                        flower = new Flower(
                                rs.getInt("id"),
                                rs.getString("name"),
                                rs.getDouble("price"),
                                rs.getString("category"),
                                rs.getString("image_url"),
                                rs.getString("description")
                        );
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("flower", flower);
        // Forward to your JSP (ensure the filename matches your webapp folder)
        request.getRequestDispatcher("/details.jsp").forward(request, response);
    }
}
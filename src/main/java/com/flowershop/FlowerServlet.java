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

        // 1. Database Connection Logic
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT name, price FROM flowers";
            try (PreparedStatement pstmt = conn.prepareStatement(sql);
                 ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {
                    String name = rs.getString("name");
                    double price = rs.getDouble("price");
                    flowerList.add(new Flower(name, price));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 2. Forward data to JSP
        request.setAttribute("allFlowers", flowerList);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
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

@WebServlet("/showFlowers") // Handles listing flowers for shop/management pages
public class FlowerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Holds query results to be rendered in JSP
        List<Flower> flowerList = new ArrayList<>();

        // 1) Read optional request parameters
        // category: filter by category; target: decide which JSP page to forward to
        String filterCategory = request.getParameter("category");
        String target = request.getParameter("target");

        // 2) Build SQL dynamically based on whether filtering is applied
        // Includes 'description' so it matches the updated Flower constructor/model
        StringBuilder sql = new StringBuilder(
                "SELECT id, name, price, category, image_url, description FROM flowers"
        );

        // Treat "all" / empty / null as no filter
        boolean isFiltering =
                (filterCategory != null && !filterCategory.isEmpty()
                        && !filterCategory.equalsIgnoreCase("all"));

        if (isFiltering) {
            sql.append(" WHERE category = ?");
        }

        // 3) Query database (try-with-resources ensures resources are closed properly)
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            // Bind filter parameter to prevent SQL injection
            if (isFiltering) {
                pstmt.setString(1, filterCategory);
            }

            // Execute query and map each row -> Flower object
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    // Create Flower using all required fields (including description)
                    flowerList.add(new Flower(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getDouble("price"),
                            rs.getString("category"),
                            rs.getString("image_url"),
                            rs.getString("description")
                    ));
                }
            }

        } catch (SQLException e) {
            // SQL-level errors (bad query, missing column/table, etc.)
            System.err.println("SQL Error in FlowerServlet: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            // Driver/connection/other unexpected errors
            e.printStackTrace();
        }

        // 4) Expose results to JSP via request scope
        request.setAttribute("allFlowers", flowerList);

        // 5) Forward to the correct page (shop view vs management view)
        String destination = "/shop.jsp";
        if ("management".equalsIgnoreCase(target)) {
            destination = "/management.jsp";
        }

        request.getRequestDispatcher(destination).forward(request, response);
    }
}

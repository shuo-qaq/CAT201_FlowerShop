package com.flowershop;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    /**
     * Handles cart updates: add, decrease, and clear items.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get action parameter (add / decrease / clear)
        String action = request.getParameter("action");

        // Get current session
        HttpSession session = request.getSession();

        // Get cart from session, cart stores (productId -> quantity)
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

        // If cart does not exist, create a new one
        if (cart == null) {
            cart = new HashMap<>();
        }

        // If action is provided, perform cart operation
        if (action != null) {
            try {
                // Get product id from request
                String idParam = request.getParameter("id");
                Integer id = (idParam != null) ? Integer.parseInt(idParam) : null;

                // Handle different cart actions
                switch (action) {
                    case "add":
                        // Increase quantity by 1
                        if (id != null) cart.put(id, cart.getOrDefault(id, 0) + 1);
                        break;

                    case "decrease":
                        // Decrease quantity by 1, remove item if quantity becomes 0
                        if (id != null && cart.containsKey(id)) {
                            int currentQty = cart.get(id);
                            if (currentQty > 1) {
                                cart.put(id, currentQty - 1);
                            } else {
                                cart.remove(id);
                            }
                        }
                        break;

                    case "clear":
                        // Clear all items in cart
                        cart.clear();
                        break;
                }
            } catch (NumberFormatException e) {
                // If id is not a valid number
                e.printStackTrace();
            }
        }

        // Save updated cart back to session
        session.setAttribute("cart", cart);

        // Check if request is from AJAX
        String ajax = request.getHeader("X-Requested-With");

        // Get previous page URL
        String referer = request.getHeader("Referer");

        // If AJAX request, just return OK status
        if ("XMLHttpRequest".equals(ajax)) {
            response.setStatus(HttpServletResponse.SC_OK);

            // If not from cart.jsp, redirect back to previous page
        } else if (referer != null && !referer.contains("cart.jsp")) {
            response.sendRedirect(referer);

            // Otherwise redirect to cart page
        } else {
            response.sendRedirect("cart.jsp");
        }
    }

    /**
     * Handles the Checkout process and saves order to the database.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get action parameter (e.g. checkout)
        String action = request.getParameter("action");

        // Get current session
        HttpSession session = request.getSession();

        // 1. Check if the user is logged in
        String username = (String) session.getAttribute("user");

        // If user is not logged in, redirect to login page
        if (username == null) {
            response.sendRedirect("user_login.jsp");
            return;
        }

        // Only handle checkout action
        if ("checkout".equals(action)) {

            // 2. Get shipping details and total price from request
            String address = request.getParameter("address");
            String phone = request.getParameter("phone");
            String totalStr = request.getParameter("grandTotal");

            // Parse total price, default is 0.0 if missing
            double totalPrice = (totalStr != null) ? Double.parseDouble(totalStr) : 0.0;

            // 3. SQL to insert order into orders table
            String sql = "INSERT INTO orders (username, total_price, shipping_address, phone_number, order_status) " +
                    "VALUES (?, ?, ?, ?, 'Pending')";

            // 4. Insert order into database
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {

                // Set parameters for SQL statement
                pstmt.setString(1, username);
                pstmt.setDouble(2, totalPrice);
                pstmt.setString(3, address);
                pstmt.setString(4, phone);

                // Execute insert
                int rows = pstmt.executeUpdate();

                // If insert successful
                if (rows > 0) {

                    // Clear cart after checkout
                    session.removeAttribute("cart");

                    // Save last order info for receipt page
                    session.setAttribute("lastOrderAddress", address);
                    session.setAttribute("lastOrderPhone", phone);
                    session.setAttribute("lastOrderTotal", totalPrice);

                    // Redirect to success page
                    response.sendRedirect("payment_success.jsp");

                } else {

                    response.sendRedirect("cart.jsp?error=db_fail");
                }

            } catch (Exception e) {

                e.printStackTrace();
                response.sendRedirect("cart.jsp?error=server_error");
            }
        }
    }
}

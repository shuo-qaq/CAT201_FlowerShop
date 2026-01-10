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
     * Handles cart actions such as add, decrease, and clear.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get the action type from URL (add / decrease / clear)
        String action = request.getParameter("action");

        // Get current user session
        HttpSession session = request.getSession();

        // Get cart data from session (productId -> quantity)
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

        // Create a new cart if it does not exist
        if (cart == null) {
            cart = new HashMap<>();
        }

        // Perform cart action if action exists
        if (action != null) {
            try {
                // Get product id from request
                String idParam = request.getParameter("id");
                Integer id = (idParam != null) ? Integer.parseInt(idParam) : null;

                // Process different actions
                switch (action) {
                    case "add":
                        // Add 1 item into the cart
                        if (id != null) cart.put(id, cart.getOrDefault(id, 0) + 1);
                        break;

                    case "decrease":
                        // Reduce item quantity by 1
                        if (id != null && cart.containsKey(id)) {
                            int currentQty = cart.get(id);
                            if (currentQty > 1) {
                                cart.put(id, currentQty - 1);
                            } else {
                                // Remove item if quantity becomes 0
                                cart.remove(id);
                            }
                        }
                        break;

                    case "clear":
                        // Remove all items from the cart
                        cart.clear();
                        break;
                }
            } catch (NumberFormatException e) {
                // Handle invalid product id format
                e.printStackTrace();
            }
        }

        // Save updated cart back to session
        session.setAttribute("cart", cart);

        // Check if request comes from AJAX
        String ajax = request.getHeader("X-Requested-With");

        // Get the previous page link
        String referer = request.getHeader("Referer");

        // If AJAX request, return success status only
        if ("XMLHttpRequest".equals(ajax)) {
            response.setStatus(HttpServletResponse.SC_OK);

            // If not from cart.jsp, go back to the previous page
        } else if (referer != null && !referer.contains("cart.jsp")) {
            response.sendRedirect(referer);

            // Otherwise, go to cart page
        } else {
            response.sendRedirect("cart.jsp");
        }
    }

    /**
     * Handles checkout and saves the order into database.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get request action (checkout)
        String action = request.getParameter("action");

        // Get current user session
        HttpSession session = request.getSession();

        // Check login status by session username
        String username = (String) session.getAttribute("user");

        // Redirect to login page if not logged in
        if (username == null) {
            response.sendRedirect("user_login.jsp");
            return;
        }

        // Process checkout request only
        if ("checkout".equals(action)) {

            // Get shipping information and total price
            String address = request.getParameter("address");
            String phone = request.getParameter("phone");
            String totalStr = request.getParameter("grandTotal");

            // Convert total price string to number
            double totalPrice = (totalStr != null) ? Double.parseDouble(totalStr) : 0.0;

            // SQL statement for inserting new order
            String sql = "INSERT INTO orders (username, total_price, shipping_address, phone_number, order_status) " +
                    "VALUES (?, ?, ?, ?, 'Pending')";

            // Insert the order into database
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {

                // Set SQL parameters
                pstmt.setString(1, username);
                pstmt.setDouble(2, totalPrice);
                pstmt.setString(3, address);
                pstmt.setString(4, phone);

                // Execute database insert
                int rows = pstmt.executeUpdate();

                // If insert success
                if (rows > 0) {

                    // Clear cart after successful checkout
                    session.removeAttribute("cart");

                    // Store order info for success page display
                    session.setAttribute("lastOrderAddress", address);
                    session.setAttribute("lastOrderPhone", phone);
                    session.setAttribute("lastOrderTotal", totalPrice);

                    // Go to success page
                    response.sendRedirect("payment_success.jsp");

                } else {
                    // Insert failed
                    response.sendRedirect("cart.jsp?error=db_fail");
                }

            } catch (Exception e) {

                e.printStackTrace();
                response.sendRedirect("cart.jsp?error=server_error");
            }
        }
    }
}

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

@WebServlet("/cart") // Maps all /cart requests to this servlet
public class CartServlet extends HttpServlet {

    /**
     * Handles cart updates via query parameters:
     * action=add|decrease|clear and optional id=<productId>.
     * Cart is stored in HttpSession as Map<productId, quantity>.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        // Cart structure: key = productId, value = quantity
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        if (cart == null) {
            // Create a new cart for first-time users / new session
            cart = new HashMap<>();
        }

        if (action != null) {
            try {
                // Product id comes from query string (e.g., /cart?action=add&id=5)
                String idParam = request.getParameter("id");
                Integer id = (idParam != null) ? Integer.parseInt(idParam) : null;

                switch (action) {
                    case "add":
                        // Increase quantity by 1 (default 0)
                        if (id != null) cart.put(id, cart.getOrDefault(id, 0) + 1);
                        break;

                    case "decrease":
                        // Decrease quantity; remove item if it reaches 0/1
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
                        // Remove all items from the cart
                        cart.clear();
                        break;
                }
            } catch (NumberFormatException e) {
                // Invalid product id format (e.g., id=abc)
                e.printStackTrace();
            }
        }

        // Persist updated cart back into session
        session.setAttribute("cart", cart);

        // If request is AJAX, return 200 without redirect; otherwise redirect to proper page
        String ajax = request.getHeader("X-Requested-With");
        String referer = request.getHeader("Referer");

        if ("XMLHttpRequest".equals(ajax)) {
            response.setStatus(HttpServletResponse.SC_OK);
        } else if (referer != null && !referer.contains("cart.jsp")) {
            // Go back to the previous page (product list/details page)
            response.sendRedirect(referer);
        } else {
            // Fallback to cart page
            response.sendRedirect("cart.jsp");
        }
    }

    /**
     * Handles checkout:
     * - Requires user login (username stored in session).
     * - Inserts an order record into database.
     * - Clears cart on success and redirects to success page.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        // Login check: "user" session attribute is the username
        String username = (String) session.getAttribute("user");
        if (username == null) {
            // Session expired or not logged in
            response.sendRedirect("user_login.jsp");
            return;
        }

        if ("checkout".equals(action)) {
            // Read shipping and payment summary data from form
            String address = request.getParameter("address");
            String phone = request.getParameter("phone");

            // Note: grandTotal comes from client side; should be validated server-side in a real app
            String totalStr = request.getParameter("grandTotal");
            double totalPrice = (totalStr != null) ? Double.parseDouble(totalStr) : 0.0;

            // Insert a new order with default status 'Pending'
            String sql =
                    "INSERT INTO orders (username, total_price, shipping_address, phone_number, order_status) " +
                            "VALUES (?, ?, ?, ?, 'Pending')";

            // Use try-with-resources to auto-close DB connection and statement
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {

                // Bind parameters to prevent SQL injection
                pstmt.setString(1, username);
                pstmt.setDouble(2, totalPrice);
                pstmt.setString(3, address);
                pstmt.setString(4, phone);

                int rows = pstmt.executeUpdate();
                if (rows > 0) {
                    // Success: clear cart and store last order info for receipt page
                    session.removeAttribute("cart");
                    session.setAttribute("lastOrderAddress", address);
                    session.setAttribute("lastOrderPhone", phone);
                    session.setAttribute("lastOrderTotal", totalPrice);

                    response.sendRedirect("payment_success.jsp");
                } else {
                    // Insert failed (unexpected)
                    response.sendRedirect("cart.jsp?error=db_fail");
                }

            } catch (Exception e) {
                // Handle DB/server errors safely
                e.printStackTrace();
                response.sendRedirect("cart.jsp?error=server_error");
            }
        }
    }
}

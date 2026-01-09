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

/**
  *CartServlet (Session-based Shopping Cart)
  *This servlet manages the shopping cart and checkout workflow.

 * Design choice:
 *- The cart is stored in HttpSession as Map<productId, quantity>.
 * Endpoints:
 * - GET  /cart?action=add&id=xx       -> add item
 * - GET  /cart?action=decrease&id=xx  -> decrease item quantity
 * - GET  /cart?action=clear           -> clear cart
 * - POST /cart with action=checkout   -> create order in database
 */
@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    /**
     * GET: Handles cart updates (add, decrease, clear).
     * Why GET for cart update?
     * - Simple link/button operations can call /cart?action=... easily.
     * - The actual cart state is stored in session, not in URL.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1) Read action parameter from query string
        // Example: ?action=add or ?action=decrease or ?action=clear
        String action = request.getParameter("action");
        // 2) Get/Create session (session is used to store cart)
        HttpSession session = request.getSession();
        // 3) Read cart from session. If not exist, initialize an empty cart.
        // Cart structure: key = flower/product ID, value = quantity


        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
        }

        // 4) Execute cart operation based on action
        if (action != null) {
            try {
                // id is required for add/decrease actions; clear doesn't need id
                String idParam = request.getParameter("id");
                Integer id = (idParam != null) ? Integer.parseInt(idParam) : null;

                switch (action) {
                    case "add":
                        // Add one unit of the item; if item not exist in cart, start from 0
                        if (id != null) cart.put(id, cart.getOrDefault(id, 0) + 1);
                        break;
                    case "decrease":
                        // Decrease quantity by 1. If quantity becomes 0, remove the item entirely
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
                // If id is not a number, ignore the operation and log error
                e.printStackTrace();
            }
        }
        // 5) Save updated cart back into session
        session.setAttribute("cart", cart);

        // 6) Different response behavior for AJAX vs normal browser request
        // Frontend may update cart asynchronously (AJAX), or via page navigation
        String ajax = request.getHeader("X-Requested-With");
        String referer = request.getHeader("Referer");

        if ("XMLHttpRequest".equals(ajax)) {
            // AJAX request: return 200 only; do not redirect to another page
            response.setStatus(HttpServletResponse.SC_OK);
        } else if (referer != null && !referer.contains("cart.jsp")) {
            // Normal request from other pages (e.g., shop.jsp):
            // redirect back to the page where the user clicked "add to cart"
            response.sendRedirect(referer);
        } else {
            // If no referer or already on cart page, go to cart.jsp
            response.sendRedirect("cart.jsp");
        }
    }

    /**
     * POST: Handles checkout and saves order into database.
     * Workflow:
     * 1) Verify user login (session contains "user")
     * 2) Read checkout form fields (address, phone, total)
     * 3) Insert order record into orders table with status 'Pending'
     * 4) On success: clear session cart and redirect to success page
     */

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1) Action in POST body (e.g., action=checkout)
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        // 2) Security check: Only logged-in users can checkout
        // Session attribute "user" stores current username
        String username = (String) session.getAttribute("user");
        if (username == null) {
            // If session expired or user not logged in, redirect to login page
            response.sendRedirect("user_login.jsp");
            return;
        }

        // 3) Checkout logic
        if ("checkout".equals(action)) {
            // 3.1 Read shipping details and total price from submitted form
            String address = request.getParameter("address");
            String phone = request.getParameter("phone");
            String totalStr = request.getParameter("grandTotal");
            // Parse total price safely; default to 0.0 if missing
            double totalPrice = (totalStr != null) ? Double.parseDouble(totalStr) : 0.0;

            // 3.2 Insert into orders table (only order header information)
            // Note: This code stores a single order summary. It does NOT store order items detail.
            String sql = "INSERT INTO orders (username, total_price, shipping_address, phone_number, order_status) VALUES (?, ?, ?, ?, 'Pending')";

            // 3.3 Use try-with-resources to auto-close Connection and PreparedStatement
            // PreparedStatement prevents SQL injection and handles data binding safely
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {

                // Bind parameters (username, total, address, phone)
                pstmt.setString(1, username);
                pstmt.setDouble(2, totalPrice);
                pstmt.setString(3, address);
                pstmt.setString(4, phone);

                // Execute insert
                int rows = pstmt.executeUpdate();
                if (rows > 0) {
                    // 4) Success:
                    // - clear the cart from session
                    // - store last order info to display on success/receipt page
                    session.removeAttribute("cart");
                    session.setAttribute("lastOrderAddress", address);
                    session.setAttribute("lastOrderPhone", phone);
                    session.setAttribute("lastOrderTotal", totalPrice);

                    // Redirect to success page
                    response.sendRedirect("payment_success.jsp");
                } else {
                    // Insert failed (no rows affected)
                    response.sendRedirect("cart.jsp?error=db_fail");
                }

            } catch (Exception e) {
                // Any database/server error
                e.printStackTrace();
                response.sendRedirect("cart.jsp?error=server_error");
            }
        }
    }
}
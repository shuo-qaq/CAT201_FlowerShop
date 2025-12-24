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

        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
        }

        if (action != null) {
            try {
                String idParam = request.getParameter("id");
                Integer id = (idParam != null) ? Integer.parseInt(idParam) : null;

                switch (action) {
                    case "add":
                        if (id != null) cart.put(id, cart.getOrDefault(id, 0) + 1);
                        break;
                    case "decrease":
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
                        cart.clear();
                        break;
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        session.setAttribute("cart", cart);

        String ajax = request.getHeader("X-Requested-With");
        String referer = request.getHeader("Referer");

        if ("XMLHttpRequest".equals(ajax)) {
            response.setStatus(HttpServletResponse.SC_OK);
        } else if (referer != null && !referer.contains("cart.jsp")) {
            response.sendRedirect(referer);
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

        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        // 1. Check if the user is logged in
        String username = (String) session.getAttribute("user");
        if (username == null) {
            // Redirect to login if session expired or not logged in
            response.sendRedirect("user_login.jsp");
            return;
        }

        if ("checkout".equals(action)) {
            // 2. Capture shipping details and total price from the form
            String address = request.getParameter("address");
            String phone = request.getParameter("phone");
            String totalStr = request.getParameter("grandTotal");
            double totalPrice = (totalStr != null) ? Double.parseDouble(totalStr) : 0.0;

            // 3. Database operation to save the order
            String sql = "INSERT INTO orders (username, total_price, shipping_address, phone_number, order_status) VALUES (?, ?, ?, ?, 'Pending')";

            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {

                pstmt.setString(1, username);
                pstmt.setDouble(2, totalPrice);
                pstmt.setString(3, address);
                pstmt.setString(4, phone);

                int rows = pstmt.executeUpdate();
                if (rows > 0) {
                    // 4. Success: Clear the cart and save info for the receipt page
                    session.removeAttribute("cart");
                    session.setAttribute("lastOrderAddress", address);
                    session.setAttribute("lastOrderPhone", phone);
                    session.setAttribute("lastOrderTotal", totalPrice);

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
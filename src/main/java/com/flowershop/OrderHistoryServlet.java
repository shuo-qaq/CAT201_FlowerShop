package com.flowershop;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Order History Servlet
 * - Customer: view only their own orders (by username in session)
 * - Admin (optional): view all orders
 */
@WebServlet("/orderHistory")
public class OrderHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String username = (String) session.getAttribute("user");
        String role = (String) session.getAttribute("role");

        // Login required (both customer/admin must be logged in)
        if (username == null) {
            response.sendRedirect("user_login.jsp");
            return;
        }

        List<OrderRecord> orders = new ArrayList<>();

        // Admin can view all orders; customer sees only their own
        boolean isAdmin = "admin".equalsIgnoreCase(role);

        String sql = isAdmin
                ? "SELECT order_id, username, total_price, shipping_address, phone_number, order_status, order_date " +
                "FROM orders ORDER BY order_date DESC"
                : "SELECT order_id, username, total_price, shipping_address, phone_number, order_status, order_date " +
                "FROM orders WHERE username = ? ORDER BY order_date DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            if (!isAdmin) {
                pstmt.setString(1, username);
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    orders.add(new OrderRecord(
                            rs.getInt("order_id"),
                            rs.getString("username"),
                            rs.getDouble("total_price"),
                            rs.getString("shipping_address"),
                            rs.getString("phone_number"),
                            rs.getString("order_status"),
                            rs.getTimestamp("order_date")
                    ));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("orders", orders);
        request.setAttribute("isAdmin", isAdmin);

        request.getRequestDispatcher("/order_history.jsp").forward(request, response);
    }

    /**
     * Simple Order DTO (inner class for simplicity in coursework)
     */
    public static class OrderRecord {
        private int orderId;
        private String username;
        private double totalPrice;
        private String shippingAddress;
        private String phoneNumber;
        private String orderStatus;
        private Timestamp orderDate;

        public OrderRecord(int orderId, String username, double totalPrice,
                           String shippingAddress, String phoneNumber,
                           String orderStatus, Timestamp orderDate) {
            this.orderId = orderId;
            this.username = username;
            this.totalPrice = totalPrice;
            this.shippingAddress = shippingAddress;
            this.phoneNumber = phoneNumber;
            this.orderStatus = orderStatus;
            this.orderDate = orderDate;
        }

        public int getOrderId() { return orderId; }
        public String getUsername() { return username; }
        public double getTotalPrice() { return totalPrice; }
        public String getShippingAddress() { return shippingAddress; }
        public String getPhoneNumber() { return phoneNumber; }
        public String getOrderStatus() { return orderStatus; }
        public Timestamp getOrderDate() { return orderDate; }
    }
}

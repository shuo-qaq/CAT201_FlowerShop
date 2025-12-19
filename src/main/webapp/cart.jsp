<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.sql.*, com.flowershop.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Review Your Cart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container my-5">
    <h2 class="fw-bold mb-4">Shopping Cart Review</h2>
    <div class="card shadow border-0">
        <div class="card-body p-0">
            <table class="table table-hover mb-0">
                <thead class="table-dark">
                    <tr>
                        <th class="ps-4">Item Name</th>
                        <th>Price</th>
                        <th>Qty</th>
                        <th>Subtotal</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
                        double grandTotal = 0;
                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;

                        try {
                            if (cart != null && !cart.isEmpty()) {
                                conn = DBUtil.getConnection();
                                for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                                    pstmt = conn.prepareStatement("SELECT name, price FROM flowers WHERE id = ?");
                                    pstmt.setInt(1, entry.getKey());
                                    rs = pstmt.executeQuery();
                                    if (rs.next()) {
                                        String name = rs.getString("name");
                                        double price = rs.getDouble("price");
                                        int qty = entry.getValue();
                                        double subtotal = price * qty;
                                        grandTotal += subtotal;
                    %>
                    <tr>
                        <td class="ps-4 fw-bold"><%= name %></td>
                        <td>$<%= String.format("%.2f", price) %></td>
                        <td><%= qty %></td>
                        <td class="text-success fw-bold">$<%= String.format("%.2f", subtotal) %></td>
                    </tr>
                    <%
                                    }
                                    if (rs != null) rs.close();
                                    if (pstmt != null) pstmt.close();
                                }
                            } else {
                    %>
                    <tr><td colspan="4" class="text-center py-5 text-muted">No items in cart.</td></tr>
                    <%      }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException e) {}
                            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
                            if (conn != null) try { conn.close(); } catch (SQLException e) {}
                        }
                    %>
                </tbody>
            </table>
        </div>
        <div class="card-footer bg-white p-4 text-end">
            <h4>Total Amount: <span class="text-danger fw-bold">$<%= String.format("%.2f", grandTotal) %></span></h4>
            <hr>
            <a href="showFlowers" class="btn btn-outline-dark">Back to Shop</a>
            <button class="btn btn-success px-5" onclick="alert('Order Placed!')">PAY NOW</button>
        </div>
    </div>
</div>
</body>
</html>
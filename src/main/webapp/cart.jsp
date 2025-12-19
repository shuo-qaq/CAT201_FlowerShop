<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.sql.*, com.flowershop.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Review Your Cart - Flower Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f4f7f6; font-family: 'Segoe UI', sans-serif; }
        .cart-header { background: linear-gradient(135deg, #198754 0%, #146c43 100%); color: white; padding: 2rem 0; margin-bottom: 2rem; }
        .table shadow-sm { background: white; border-radius: 10px; overflow: hidden; }
        .checkout-card { border-radius: 15px; border: none; }
        .product-icon { width: 40px; height: 40px; background: #e8f5e9; border-radius: 8px; display: flex; align-items: center; justify-content: center; }
    </style>
</head>
<body>

<div class="cart-header text-center shadow-sm">
    <div class="container">
        <h1 class="fw-bold"><i class="fas fa-shopping-cart me-2"></i>Order Summary</h1>
        <p class="lead mb-0">Please review your items before finalizing payment</p>
    </div>
</div>

<div class="container mb-5">
    <div class="row">
        <div class="col-lg-8">
            <div class="card shadow-sm border-0 mb-4">
                <div class="card-body p-0">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4 py-3">Product Description</th>
                                <th class="py-3 text-center">Unit Price</th>
                                <th class="py-3 text-center">Qty</th>
                                <th class="py-3 text-end pe-4">Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
                                double grandTotal = 0;
                                int totalQty = 0;

                                Connection conn = null;
                                PreparedStatement pstmt = null;
                                ResultSet rs = null;

                                try {
                                    if (cart != null && !cart.isEmpty()) {
                                        conn = DBUtil.getConnection();
                                        String sql = "SELECT name, price FROM flowers WHERE id = ?";
                                        pstmt = conn.prepareStatement(sql);

                                        for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                                            pstmt.setInt(1, entry.getKey());
                                            rs = pstmt.executeQuery();

                                            if (rs.next()) {
                                                String name = rs.getString("name");
                                                double price = rs.getDouble("price");
                                                int qty = entry.getValue();
                                                double subtotal = price * qty;
                                                grandTotal += subtotal;
                                                totalQty += qty;
                            %>
                            <tr>
                                <td class="ps-4 py-3">
                                    <div class="d-flex align-items-center">
                                        <div class="product-icon me-3">
                                            <i class="fas fa-leaf text-success"></i>
                                        </div>
                                        <span class="fw-bold"><%= name %></span>
                                    </div>
                                </td>
                                <td class="text-center text-muted">$<%= String.format("%.2f", price) %></td>
                                <td class="text-center">
                                    <span class="badge bg-white text-dark border px-3 py-2"><%= qty %></span>
                                </td>
                                <td class="text-end pe-4 fw-bold text-success">$<%= String.format("%.2f", subtotal) %></td>
                            </tr>
                            <%
                                            }
                                            if (rs != null) rs.close();
                                        }
                                    } else {
                            %>
                            <tr>
                                <td colspan="4" class="text-center py-5">
                                    <i class="fas fa-shopping-basket fa-3x text-muted mb-3 d-block"></i>
                                    <p class="text-muted">Your cart is empty. Let's add some flowers!</p>
                                    <a href="showFlowers" class="btn btn-success px-4">Browse Collection</a>
                                </td>
                            </tr>
                            <%
                                    }
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
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card shadow-sm border-0 checkout-card p-2">
                <div class="card-body p-4">
                    <h4 class="fw-bold mb-4">Cart Totals</h4>
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Total Quantity:</span>
                        <span class="fw-bold"><%= totalQty %> Items</span>
                    </div>
                    <div class="d-flex justify-content-between mb-4">
                        <span class="text-muted">Shipping:</span>
                        <span class="text-success fw-bold">FREE</span>
                    </div>
                    <hr>
                    <div class="d-flex justify-content-between mb-4">
                        <span class="h5 fw-bold">Total Amount:</span>
                        <span class="h4 fw-bold text-danger">$<%= String.format("%.2f", grandTotal) %></span>
                    </div>

                    <button class="btn btn-success w-100 fw-bold py-3 mb-3 shadow-sm" onclick="processPayment()">
                        CONFIRM AND PAY
                    </button>
                    <a href="showFlowers" class="btn btn-outline-dark w-100 py-2">
                        <i class="fas fa-arrow-left me-2"></i>CONTINUE SHOPPING
                    </a>
                </div>
            </div>

            <div class="text-center mt-4">
                <img src="https://upload.wikimedia.org/wikipedia/commons/b/b5/PayPal.svg" alt="PayPal" height="25" class="opacity-50 mx-2">
                <img src="https://upload.wikimedia.org/wikipedia/commons/0/04/Visa.svg" alt="Visa" height="20" class="opacity-50 mx-2">
            </div>
        </div>
    </div>
</div>

<script>
    function processPayment() {
        const hasItems = <%= (cart != null && !cart.isEmpty()) ? "true" : "false" %>;
        if (!hasItems) {
            alert("Your cart is empty. Please add items before checking out.");
            return;
        }

        // Simulating payment process
        const confirmPay = confirm("Are you sure you want to proceed with the payment of $<%= String.format("%.2f", grandTotal) %>?");
        if (confirmPay) {
            // Redirecting to the success page we created
            window.location.href = "payment_success.jsp";
        }
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
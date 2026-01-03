<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.sql.*, com.flowershop.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure Checkout - Flower Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        body { background-color: #f4f7f6; font-family: 'Segoe UI', Tahoma, sans-serif; }
        .cart-header { background: linear-gradient(135deg, #198754 0%, #146c43 100%); color: white; padding: 2.5rem 0; margin-bottom: 2rem; }
        .qty-control { display: flex; align-items: center; justify-content: center; gap: 10px; }
        .btn-qty { width: 30px; height: 30px; padding: 0; display: flex; align-items: center; justify-content: center; border-radius: 50%; }

        /* Payment Card Styling - NO IMAGES */
        .payment-method-card {
            border: 1px solid #e0e0e0;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 12px;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            background: #fff;
            color: #333;
        }
        .payment-method-card:hover {
            border-color: #198754;
            background-color: #f8fffb;
            transform: translateY(-2px);
        }
        .payment-method-card input[type="radio"] {
            margin-right: 15px;
            accent-color: #198754;
            width: 18px;
            height: 18px;
        }
        .payment-method-card label {
            cursor: pointer;
            display: flex;
            align-items: center;
            width: 100%;
            margin-bottom: 0;
            font-weight: 500;
        }
        /* Icon Sizing */
        .pay-icon-brand {
            font-size: 1.6rem;
            width: 40px;
            text-align: center;
            margin-right: 10px;
        }
        .card-icons-group {
            margin-left: auto;
            display: flex;
            gap: 8px;
            font-size: 1.2rem;
        }
        .summary-card { border: none; border-radius: 15px; }
    </style>
</head>
<body>

<div class="cart-header text-center shadow-sm">
    <div class="container">
        <h1 class="fw-bold"><i class="fas fa-shopping-basket me-2"></i>Review Your Order</h1>
        <p class="lead mb-0">Please verify your items and provide shipping details</p>
    </div>
</div>

<div class="container mb-5">
    <div class="row">
        <div class="col-lg-8">
            <div class="card shadow-sm border-0 mb-4 text-dark summary-card">
                <div class="card-body p-0">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4 py-3">Product Description</th>
                                <th class="py-3 text-center">Price</th>
                                <th class="py-3 text-center">Quantity</th>
                                <th class="py-3 text-end pe-4">Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
                                double grandTotal = 0;
                                int totalQty = 0;
                                Connection conn = null;
                                try {
                                    if (cart != null && !cart.isEmpty()) {
                                        conn = DBUtil.getConnection();
                                        String sql = "SELECT name, price FROM flowers WHERE id = ?";
                                        PreparedStatement pstmt = conn.prepareStatement(sql);

                                        for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                                            pstmt.setInt(1, entry.getKey());
                                            ResultSet rs = pstmt.executeQuery();
                                            if (rs.next()) {
                                                String name = rs.getString("name");
                                                double price = rs.getDouble("price");
                                                int qty = entry.getValue();
                                                double subtotal = price * qty;
                                                grandTotal += subtotal;
                                                totalQty += qty;
                            %>
                            <tr>
                                <td class="ps-4 py-3"><span class="fw-bold text-capitalize text-dark"><%= name %></span></td>
                                <td class="text-center text-muted">$<%= String.format("%.2f", price) %></td>
                                <td class="text-center">
                                    <div class="qty-control">
                                        <a href="cart?action=decrease&id=<%= entry.getKey() %>" class="btn btn-outline-danger btn-qty btn-sm">
                                            <i class="fas fa-minus"></i>
                                        </a>
                                        <span class="fw-bold px-2 text-dark"><%= qty %></span>
                                        <a href="cart?action=add&id=<%= entry.getKey() %>" class="btn btn-outline-success btn-qty btn-sm">
                                            <i class="fas fa-plus"></i>
                                        </a>
                                    </div>
                                </td>
                                <td class="text-end pe-4 fw-bold text-success">$<%= String.format("%.2f", subtotal) %></td>
                            </tr>
                            <%
                                            }
                                        }
                                    } else {
                            %>
                            <tr>
                                <td colspan="4" class="text-center py-5">
                                    <i class="fas fa-shopping-cart fa-3x text-muted mb-3 d-block"></i>
                                    <p class="text-muted">Your shopping cart is currently empty.</p>
                                    <a href="showFlowers" class="btn btn-success px-4">Browse Collection</a>
                                </td>
                            </tr>
                            <% } } catch (Exception e) { e.printStackTrace(); } finally { if (conn != null) conn.close(); } %>
                        </tbody>
                    </table>
                </div>
                <% if (cart != null && !cart.isEmpty()) { %>
                <div class="card-footer bg-white border-0 py-3 text-start ps-4">
                    <a href="cart?action=clear" class="btn btn-sm btn-outline-danger" onclick="return confirm('Clear all items from your cart?')">
                        <i class="fas fa-trash-alt me-1"></i> Clear Cart
                    </a>
                </div>
                <% } %>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card shadow-sm border-0 p-2 summary-card">
                <div class="card-body p-4 text-dark">
                    <h4 class="fw-bold mb-4">Order Summary</h4>

                    <form id="checkoutForm" action="cart" method="POST">
                        <input type="hidden" name="action" value="checkout">
                        <input type="hidden" name="grandTotal" value="<%= grandTotal %>">

                        <div class="mb-3 text-start">
                            <label class="form-label small fw-bold">Shipping Address</label>
                            <textarea name="address" class="form-control" rows="2" placeholder="Street, City, Postcode" required></textarea>
                        </div>

                        <div class="mb-4 text-start">
                            <label class="form-label small fw-bold">Contact Phone</label>
                            <input type="tel" name="phone" class="form-control" placeholder="E.g. +1 234 567 890" required>
                        </div>

                        <div class="mb-4 text-start">
                            <label class="form-label small text-muted text-uppercase mb-3 fw-bold">Payment Method</label>

                            <div class="payment-method-card" onclick="document.getElementById('alipay').checked=true">
                                <input type="radio" name="paymentType" id="alipay" value="alipay" checked>
                                <label for="alipay">
                                    <i class="fab fa-alipay pay-icon-brand text-primary"></i>
                                    Alipay
                                </label>
                            </div>

                            <div class="payment-method-card" onclick="document.getElementById('wechat').checked=true">
                                <input type="radio" name="paymentType" id="wechat" value="wechat">
                                <label for="wechat">
                                    <i class="fab fa-weixin pay-icon-brand text-success"></i>
                                    WeChat Pay
                                </label>
                            </div>

                            <div class="payment-method-card" onclick="document.getElementById('cards').checked=true">
                                <input type="radio" name="paymentType" id="cards" value="cards">
                                <label for="cards">
                                    <i class="fas fa-credit-card pay-icon-brand text-secondary"></i>
                                    Credit Cards
                                    <div class="card-icons-group">
                                        <i class="fab fa-cc-visa text-primary"></i>
                                        <i class="fab fa-cc-mastercard text-danger"></i>
                                    </div>
                                </label>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Quantity Total:</span>
                            <span class="fw-bold"><%= totalQty %> Items</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Delivery:</span>
                            <span class="text-success fw-bold">FREE</span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between mb-4">
                            <span class="h5 fw-bold">Grand Total:</span>
                            <span class="h4 fw-bold text-danger">$<%= String.format("%.2f", grandTotal) %></span>
                        </div>

                        <button type="button" class="btn btn-success w-100 fw-bold py-3 mb-3 shadow-sm" onclick="validateAndSubmit()">
                            PLACE ORDER & PAY
                        </button>
                    </form>

                    <a href="showFlowers" class="btn btn-outline-dark w-100 py-2">
                        <i class="fas fa-arrow-left me-2"></i>Continue Shopping
                    </a>
                </div>
            </div>

            <div class="text-center mt-3 text-muted">
                <small><i class="fas fa-lock me-1"></i> Secure SSL Encrypted Payment</small>
            </div>
        </div>
    </div>
</div>

<script>
    function validateAndSubmit() {
        <% if (cart == null || cart.isEmpty()) { %>
            alert("Please add some items to your cart before proceeding to payment.");
            return;
        <% } %>
        const form = document.getElementById('checkoutForm');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        const method = document.querySelector('input[name="paymentType"]:checked').value;
        const formattedMethod = method.toUpperCase();

        if (confirm("Proceed with payment via " + formattedMethod + " for a total of: $<%= String.format("%.2f", grandTotal) %>?")) {
            form.submit();
        }
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
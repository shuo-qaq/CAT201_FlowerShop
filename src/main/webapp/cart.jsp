<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.sql.*, com.flowershop.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Your Cart - Flower Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f4f7f6; font-family: 'Segoe UI', sans-serif; }
        .cart-header { background: linear-gradient(135deg, #198754 0%, #146c43 100%); color: white; padding: 2rem 0; margin-bottom: 2rem; }
        .qty-control { display: flex; align-items: center; justify-content: center; gap: 10px; }
        .btn-qty { width: 30px; height: 30px; padding: 0; display: flex; align-items: center; justify-content: center; border-radius: 50%; }
        .form-label { font-weight: 600; color: #444; }
    </style>
</head>
<body>

<div class="cart-header text-center shadow-sm">
    <div class="container">
        <h1 class="fw-bold"><i class="fas fa-shopping-basket me-2"></i>My Shopping Cart</h1>
        <p class="lead mb-0">Modify your items or proceed to checkout</p>
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
                                <th class="ps-4 py-3">Product</th>
                                <th class="py-3 text-center">Unit Price</th>
                                <th class="py-3 text-center">Quantity</th>
                                <th class="py-3 text-end pe-4">Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                // English Comments: Retrieve cart from session and initialize totals
                                Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
                                double grandTotal = 0;
                                int totalQty = 0;

                                Connection conn = null;
                                PreparedStatement pstmt = null;
                                ResultSet rs = null;

                                try {
                                    if (cart != null && !cart.isEmpty()) {
                                        conn = DBUtil.getConnection();
                                        // English Comments: Fetch flower details based on ID stored in cart
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
                                    <span class="fw-bold text-dark text-capitalize"><%= name %></span>
                                </td>
                                <td class="text-center text-muted">$<%= String.format("%.2f", price) %></td>
                                <td class="text-center">
                                    <div class="qty-control">
                                        <a href="cart?action=decrease&id=<%= entry.getKey() %>" class="btn btn-outline-danger btn-qty btn-sm">
                                            <i class="fas fa-minus"></i>
                                        </a>
                                        <span class="fw-bold px-2" style="min-width: 30px;"><%= qty %></span>
                                        <a href="cart?action=add&id=<%= entry.getKey() %>" class="btn btn-outline-success btn-qty btn-sm">
                                            <i class="fas fa-plus"></i>
                                        </a>
                                    </div>
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
                                    <i class="fas fa-shopping-cart fa-3x text-muted mb-3 d-block"></i>
                                    <p class="text-muted">Your cart is currently empty.</p>
                                    <a href="showFlowers" class="btn btn-success px-4">Start Shopping</a>
                                </td>
                            </tr>
                            <%
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (conn != null) conn.close();
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                <% if (cart != null && !cart.isEmpty()) { %>
                <div class="card-footer bg-white border-0 py-3 text-start ps-4">
                    <a href="cart?action=clear" class="btn btn-sm btn-outline-danger" onclick="return confirm('Empty your entire cart?')">
                        <i class="fas fa-trash-alt me-1"></i> Clear Cart
                    </a>
                </div>
                <% } %>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card shadow-sm border-0 p-2">
                <div class="card-body p-4">
                    <h4 class="fw-bold mb-4">Checkout Details</h4>

                    <form id="checkoutForm" action="cart" method="POST">
                        <input type="hidden" name="action" value="checkout">
                        <input type="hidden" name="grandTotal" value="<%= grandTotal %>">

                        <div class="mb-3">
                            <label class="form-label small">Shipping Address</label>
                            <textarea name="address" class="form-control" rows="2" placeholder="Street, City, Postcode" required></textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small">Phone Number</label>
                            <input type="tel" name="phone" class="form-control" placeholder="E.g. +123456789" required>
                        </div>

                        <div class="d-flex justify-content-between mb-2 mt-4">
                            <span class="text-muted">Total Quantity:</span>
                            <span class="fw-bold text-dark"><%= totalQty %> Items</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Shipping:</span>
                            <span class="text-success fw-bold">Free</span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between mb-4">
                            <span class="h5 fw-bold">Total Payable:</span>
                            <span class="h4 fw-bold text-danger">$<%= String.format("%.2f", grandTotal) %></span>
                        </div>

                        <button type="button" class="btn btn-success w-100 fw-bold py-3 mb-3 shadow-sm" onclick="validateAndSubmit()">
                            PAY AND PLACE ORDER
                        </button>
                    </form>

                    <a href="showFlowers" class="btn btn-outline-dark w-100 py-2">
                        <i class="fas fa-arrow-left me-2"></i>CONTINUE SHOPPING
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    /* English Comments: Validate inputs and confirm total before submitting the form */
    function validateAndSubmit() {
        <% if (cart == null || cart.isEmpty()) { %>
            alert("Please add some flowers to your cart before paying!");
            return;
        <% } %>

        const form = document.getElementById('checkoutForm');
        // English Comments: Check if address and phone fields are filled (HTML5 validation)
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        if (confirm("Confirm order with total amount: $<%= String.format("%.2f", grandTotal) %>?")) {
            form.submit();
        }
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
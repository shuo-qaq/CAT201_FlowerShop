<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.flowershop.Flower" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Product Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        .product-img { max-height: 500px; object-fit: cover; }
        .description-box { line-height: 1.6; color: #555; white-space: pre-line; }
        /* Style for a small floating cart notification if needed */
        .toast-container { position: fixed; bottom: 20px; right: 20px; z-index: 1050; }
    </style>
</head>
<body class="bg-light">
    <div class="container py-5">
        <a href="showFlowers" class="btn btn-outline-secondary mb-4">
            <i class="bi bi-arrow-left"></i> Back to Shop
        </a>

        <% Flower f = (Flower) request.getAttribute("flower");
           if (f != null) { %>
        <div class="row bg-white p-4 shadow-sm rounded">
            <div class="col-md-6 text-center border-end">
                <img src="img/<%= f.getImageUrl() %>" class="img-fluid rounded shadow product-img" alt="<%= f.getName() %>">
            </div>

            <div class="col-md-6 p-4">
                <span class="badge bg-success mb-2 text-uppercase"><%= f.getCategory() %></span>
                <h1 class="fw-bold"><%= f.getName() %></h1>
                <h2 class="text-success mb-4">$<%= String.format("%.2f", f.getPrice()) %></h2>

                <h5 class="fw-bold border-bottom pb-2">Product Description</h5>
                <div class="description-box mb-4">
                    <%= (f.getDescription() != null && !f.getDescription().isEmpty()) ?
                        f.getDescription() : "This beautiful " + f.getName() + " is currently in stock." %>
                </div>

                <div class="d-grid gap-2">
                    <button class="btn btn-primary btn-lg" onclick="addToCart(<%= f.getId() %>)">
                        <i class="bi bi-cart-plus"></i> Add to Cart
                    </button>
                    <a href="cart.jsp" class="btn btn-outline-success">
                        <i class="bi bi-bag-check"></i> View My Cart
                    </a>
                </div>
            </div>
        </div>
        <% } else { %>
            <div class="alert alert-danger text-center">
                <h4>Oops! Product details not found.</h4>
                <a href="showFlowers" class="btn btn-primary mt-3">Return to Shop</a>
            </div>
        <% } %>
    </div>

    <div class="toast-container">
        <div id="cartToast" class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">
                    Added to cart successfully!
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function addToCart(productId) {
            // 1. We use AJAX (fetch) so the page DOES NOT reload
            fetch('cart?action=add&id=' + productId, {
                headers: { 'X-Requested-With': 'XMLHttpRequest' }
            })
            .then(response => {
                if (response.ok) {
                    // 2. Show a success message
                    alert('Success: Item added to cart!');

                    // 3. DO NOT REDIRECT. This keeps the user on the detail page.
                    // If you want to update the navbar cart count, you would trigger it here.

                    // Optional: Refresh the page to show changes in a sidebar/dropdown cart
                    // location.reload();
                } else {
                    alert('Error: Could not add item.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Connection error.');
            });
        }
    </script>
</body>
</html>
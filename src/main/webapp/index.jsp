<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.flowershop.Flower" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FlowerShop | Premium Flowers</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .hero-section {
            background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)), url('https://images.unsplash.com/photo-1519306110291-4a38392b3a9c?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80');
            background-size: cover;
            color: white;
            padding: 100px 0;
            text-align: center;
        }
        .flower-card {
            transition: transform 0.3s;
        }
        .flower-card:hover {
            transform: translateY(-10px);
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="index.jsp">FlowerShop</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="showFlowers">Shop</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Cart</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-warning fw-bold" href="admin.jsp"
                       onclick="return confirm('You are redirecting to the Management Panel. Continue?')">
                       Go to Admin Panel
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<header class="hero-section">
    <div class="container">
        <h1 class="display-4 font-weight-bold">Fresh Flowers for Your Loved Ones</h1>
        <p class="lead">Exquisite bouquets delivered to your doorstep.</p>
        <a href="showFlowers" class="btn btn-primary btn-lg">Browse Inventory</a>
    </div>
</header>

<main class="container my-5">
    <h2 class="text-center mb-4">Our Flower Inventory</h2>

    <div class="row">
        <%
            List<Flower> list = (List<Flower>) request.getAttribute("allFlowers");
            if (list != null && !list.isEmpty()) {
                for (Flower f : list) {
        %>
            <div class="col-md-4 mb-4">
                <div class="card h-100 shadow-sm flower-card">
                    <div class="card-body text-center">
                        <h5 class="card-title font-weight-bold text-uppercase"><%= f.getName() %></h5>
                        <p class="card-text text-muted small">Hand-picked fresh <%= f.getName().toLowerCase() %> bouquet.</p>
                        <h4 class="text-primary">$<%= f.getPrice() %></h4>
                        <button class="btn btn-outline-success mt-3" onclick="addToCart('<%= f.getName() %>')">Add to Cart</button>
                    </div>
                </div>
            </div>
        <%
                }
            } else {
        %>
            <div class="col-12 text-center py-5">
                <div class="alert alert-info">
                    <h5>No flowers in stock?</h5>
                    <p>Please <a href="showFlowers" class="alert-link">click here to refresh the inventory</a> from the database.</p>
                </div>
            </div>
        <%
            }
        %>
    </div>
</main>

<footer class="bg-dark text-white text-center py-4">
    <div class="container">
        <p>&copy; 2025 CAT201 Flower Shop Project. All rights reserved.</p>
    </div>
</footer>

<script>
    function addToCart(flowerName) {
        alert(flowerName + " has been added to your cart!");
    }
</script>

</body>
</html>
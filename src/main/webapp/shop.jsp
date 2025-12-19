<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="com.flowershop.Flower" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Flower Shop - Premium Collection</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8fbf9; font-family: 'Segoe UI', Tahoma, sans-serif; overflow-x: hidden; }
        .flower-card { border: none; border-radius: 15px; overflow: hidden; transition: 0.3s; background: white; }
        .flower-card:hover { transform: translateY(-10px); box-shadow: 0 15px 30px rgba(0,0,0,0.1); }
        .card-img-top { height: 200px; object-fit: cover; }
        .category-badge {
            position: absolute; top: 15px; right: 15px;
            background: rgba(255,255,255,0.9); padding: 4px 10px;
            border-radius: 20px; color: #198754; font-weight: bold; font-size: 0.75rem; z-index: 2;
        }
        .search-box { border-radius: 20px; padding-left: 20px; border: 2px solid #eee; }
        .search-box:focus { border-color: #198754; box-shadow: none; }
        .cart-count { position: absolute; top: -5px; right: -10px; padding: 2px 6px; border-radius: 50%; font-size: 10px; }

        /* Sidebar Styling */
        #cartSidebar {
            position: fixed; top: 0; right: -400px;
            width: 350px; height: 100%;
            background: white; z-index: 2000;
            transition: 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: -5px 0 15px rgba(0,0,0,0.1);
            border-left: 4px solid #198754;
        }
        #cartSidebar.active { right: 0; }
        #cartOverlay {
            position: fixed; top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.5);
            display: none; z-index: 1999;
        }
    </style>
</head>
<body>

<div id="cartOverlay" onclick="toggleCart()"></div>

<div id="cartSidebar">
    <div class="p-4 d-flex flex-column h-100">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="fw-bold m-0 text-success"><i class="fas fa-shopping-basket me-2"></i>Cart Summary</h4>
            <button onclick="toggleCart()" class="btn-close"></button>
        </div>

        <div id="sidebarContent" class="flex-grow-1 overflow-auto">
            <div class="text-center py-5">
                <p class="text-muted">Loading your items...</p>
            </div>
        </div>

        <div class="mt-auto border-top pt-3">
            <a href="cart.jsp" class="btn btn-success w-100 fw-bold mb-2 py-2">CHECKOUT NOW</a>
            <button onclick="toggleCart()" class="btn btn-outline-secondary w-100 btn-sm">CONTINUE SHOPPING</button>
        </div>
    </div>
</div>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow">
    <div class="container">
        <a class="navbar-brand fw-bold" href="showFlowers">FLOWER<span class="text-success">SHOP</span></a>

        <div class="ms-auto d-flex align-items-center">
            <a class="nav-link text-white me-3" href="index.jsp">Home</a>

            <% if (session.getAttribute("user") != null) { %>
                <span class="text-white me-2 small">Welcome, <strong><%= session.getAttribute("user") %></strong></span>
                <% if ("admin".equals(session.getAttribute("role"))) { %>
                    <a href="showFlowers?target=management" class="btn btn-sm btn-warning me-2">Admin Panel</a>
                <% } %>
                <a href="manageFlower?action=logout" class="btn btn-sm btn-link text-danger text-decoration-none me-3">Logout</a>
            <% } else { %>
                <a href="user_login.jsp" class="btn btn-sm btn-outline-light me-3">Login</a>
            <% } %>

            <a href="javascript:void(0)" onclick="toggleCart()" class="btn btn-outline-success position-relative p-1 px-2">
                <i class="fas fa-shopping-cart text-white"></i>
                <span id="cartBadge" class="badge bg-danger cart-count">
                    <%
                        int totalItems = 0;
                        Map<Integer, Integer> cartMap = (Map<Integer, Integer>) session.getAttribute("cart");
                        if (cartMap != null) {
                            for (Integer qty : cartMap.values()) {
                                totalItems += qty;
                            }
                        }
                        out.print(totalItems);
                    %>
                </span>
            </a>
        </div>
    </div>
</nav>

<main class="container my-5">
    <div class="row mb-5 g-3 align-items-center">
        <div class="col-lg-4"><h2 class="fw-bold m-0">Our Collection</h2></div>
        <div class="col-lg-4">
            <input type="text" id="searchInput" class="form-control search-box" placeholder="Search products..." onkeyup="filterItems()">
        </div>
        <div class="col-lg-4 text-lg-end">
            <div class="btn-group shadow-sm">
                <button class="btn btn-outline-dark active filter-btn" onclick="setCategory('all', this)">All</button>
                <button class="btn btn-outline-dark filter-btn" onclick="setCategory('Flowers', this)">Flowers</button>
                <button class="btn btn-outline-dark filter-btn" onclick="setCategory('Plants', this)">Plants</button>
                <button class="btn btn-outline-dark filter-btn" onclick="setCategory('Tools', this)">Tools</button>
                <button class="btn btn-outline-dark filter-btn" onclick="setCategory('Accessories', this)">Accessories</button>
            </div>
        </div>
    </div>

    <div class="row g-4" id="productContainer">
        <%
            List<Flower> flowerList = (List<Flower>) request.getAttribute("allFlowers");
            if (flowerList != null) {
                for (Flower f : flowerList) {
        %>
            <div class="col-lg-3 col-md-4 col-sm-6 product-item" data-category="<%= f.getCategory() %>" data-name="<%= f.getName().toLowerCase() %>">
                <div class="card h-100 flower-card position-relative shadow-sm">
                    <span class="category-badge text-uppercase"><%= f.getCategory() %></span>
                    <img src="img/<%= f.getImageUrl() %>" class="card-img-top" alt="<%= f.getName() %>">
                    <div class="card-body text-center p-3">
                        <h6 class="fw-bold text-uppercase"><%= f.getName() %></h6>
                        <p class="text-success fw-bold mb-3">$<%= String.format("%.2f", f.getPrice()) %></p>
                        <a href="productDetails?id=<%= f.getId() %>" class="btn btn-success btn-sm w-100 fw-bold mb-2">DETAILS</a>
                        <button onclick="addToCart(<%= f.getId() %>, '<%= f.getName() %>')" class="btn btn-outline-dark btn-sm w-100 fw-bold">
                            ADD TO CART
                        </button>
                    </div>
                </div>
            </div>
        <% } } %>
    </div>
</main>

<script>
    function toggleCart() {
        const sidebar = document.getElementById('cartSidebar');
        const overlay = document.getElementById('cartOverlay');
        sidebar.classList.toggle('active');
        overlay.style.display = sidebar.classList.contains('active') ? 'block' : 'none';

        if(sidebar.classList.contains('active')) {
            updateSidebarInfo();
        }
    }

    function updateSidebarInfo() {
        const count = document.getElementById('cartBadge').innerText;
        document.getElementById('sidebarContent').innerHTML = `
            <div class="card border-0 bg-light p-3">
                <p class="text-muted mb-1">Current Session Items:</p>
                <h3 class="fw-bold text-success">\${count}</h3>
                <hr>
                <p class="small text-muted">Please go to the full cart page to view details and proceed to checkout.</p>
            </div>
        `;
    }

    function addToCart(id, name) {
        // Retrieve session status from server variable
        const currentUser = "<%= (session.getAttribute("user") != null) ? session.getAttribute("user") : "" %>";

        if (currentUser === "") {
            alert("Authentication Required: Please login to your customer account to shop.");
            window.location.href = "user_login.jsp";
            return;
        }

        fetch('cart?action=add&id=' + id)
            .then(res => res.text())
            .then(newCount => {
                document.getElementById('cartBadge').innerText = newCount;
                console.log("Added to cart: " + name);
            })
            .catch(err => console.error("Error adding to cart:", err));
    }

    let currentCat = 'all';
    function setCategory(cat, btn) {
        currentCat = cat;
        document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        filterItems();
    }

    function filterItems() {
        const query = document.getElementById('searchInput').value.toLowerCase();
        document.querySelectorAll('.product-item').forEach(item => {
            const matchCat = (currentCat === 'all' || item.getAttribute('data-category') === currentCat);
            const matchSearch = item.getAttribute('data-name').includes(query);
            item.style.display = (matchCat && matchSearch) ? 'block' : 'none';
        });
    }
</script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.flowershop.Flower" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FlowerShop | Premium Collection</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* 1. Global Styles */
        body {
            background-color: #f8fbf9;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* 2. Hero Section */
        .hero-section {
            background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)),
                        url('https://images.unsplash.com/photo-1519306110291-4a38392b3a9c?auto=format&fit=crop&w=1350&q=80');
            background-size: cover;
            background-position: center;
            color: white;
            padding: 100px 0;
            margin-bottom: 40px;
        }

        /* 3. Card Refinement */
        .flower-card {
            border: none;
            border-radius: 15px;
            overflow: hidden;
            transition: all 0.3s ease;
            background: white;
        }
        .flower-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.1) !important;
        }
        .card-img-top {
            height: 200px;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        .flower-card:hover .card-img-top {
            transform: scale(1.1);
        }

        /* 4. Category Badge */
        .category-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: rgba(255, 255, 255, 0.95);
            padding: 4px 10px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 0.75rem;
            color: #198754;
            z-index: 2;
        }

        /* 5. Search Bar Style */
        .search-box {
            border-radius: 25px;
            padding-left: 20px;
            border: 2px solid #e9ecef;
        }
        .search-box:focus {
            border-color: #198754;
            box-shadow: none;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow">
    <div class="container">
        <a class="navbar-brand fw-bold" href="showFlowers">FLOWER<span class="text-success">SHOP</span></a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item"><a class="nav-link" href="showFlowers">Home</a></li>
                <li class="nav-item">
                    <a class="nav-link text-warning fw-bold border border-warning rounded px-3 ms-lg-3"
                       href="admin.jsp" onclick="return confirm('Enter Admin Panel?')">Admin Portal</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<header class="hero-section text-center">
    <div class="container">
        <h1 class="display-3 fw-bold">Nature's Best Beauty</h1>
        <p class="lead mb-4">Explore our 30+ fresh flowers, rare plants, and gardening essentials.</p>
        <button class="btn btn-success btn-lg px-5 shadow" onclick="scrollToShop()">Start Shopping</button>
    </div>
</header>

<main class="container my-5" id="shop-section">
    <div class="row mb-5 g-3 align-items-center">
        <div class="col-lg-4">
            <h2 class="fw-bold m-0">Our Collection</h2>
        </div>
        <div class="col-lg-4">
            <input type="text" id="searchInput" class="form-control search-box" placeholder="Search by name..." onkeyup="filterItems()">
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

    <div class="row g-4" id="flower-container">
        <%
            List<Flower> list = (List<Flower>) request.getAttribute("allFlowers");
            if (list != null && !list.isEmpty()) {
                for (Flower f : list) {
        %>
            <div class="col-lg-3 col-md-4 col-sm-6 flower-item"
                 data-category="<%= f.getCategory() %>"
                 data-name="<%= f.getName().toLowerCase() %>">
                <div class="card h-100 shadow-sm flower-card position-relative">
                    <span class="category-badge shadow-sm"><%= f.getCategory() %></span>

                    <img src="img/<%= f.getImageUrl() %>" class="card-img-top" alt="<%= f.getName() %>">

                    <div class="card-body p-3 text-center">
                        <h6 class="card-title fw-bold text-uppercase mb-1"><%= f.getName() %></h6>
                        <p class="text-muted small mb-3">Premium Choice</p>
                        <div class="d-flex justify-content-center align-items-center">
                            <span class="h5 text-success mb-0">$<%= f.getPrice() %></span>
                        </div>
                    </div>

                    <div class="card-footer bg-transparent border-0 p-3 pt-0">
                        <a href="productDetails?id=<%= f.getId() %>" class="btn btn-success w-100 py-2 fw-bold">
                            BUY NOW
                        </a>
                    </div>
                </div>
            </div>
        <%
                }
            } else {
        %>
            <div class="col-12 text-center py-5">
                <div class="alert shadow-sm border-0 bg-white p-5">
                    <h4 class="text-muted">No products found in database</h4>
                    <p>Please ensure you have run the SQL script and accessed via /showFlowers.</p>
                    <a href="showFlowers" class="btn btn-primary">Refresh Inventory</a>
                </div>
            </div>
        <%
            }
        %>
    </div>
</main>

<footer class="bg-dark text-white text-center py-5">
    <div class="container">
        <p class="mb-0 text-secondary">&copy; 2025 CAT201 Flower Shop Project. All Rights Reserved.</p>
    </div>
</footer>

<script>
    let activeCategory = 'all';

    // Update category filter
    function setCategory(category, btn) {
        activeCategory = category;
        document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        filterItems();
    }

    // Real-time Filtering Logic (Category + Search)
    function filterItems() {
        const searchText = document.getElementById('searchInput').value.toLowerCase();
        const items = document.querySelectorAll('.flower-item');

        items.forEach(item => {
            const itemCategory = item.getAttribute('data-category');
            const itemName = item.getAttribute('data-name');

            const matchCategory = (activeCategory === 'all' || itemCategory === activeCategory);
            const matchSearch = itemName.includes(searchText);

            if (matchCategory && matchSearch) {
                item.style.display = 'block';
            } else {
                item.style.display = 'none';
            }
        });
    }

    // Smooth Scroll
    function scrollToShop() {
        document.getElementById('shop-section').scrollIntoView({ behavior: 'smooth' });
    }
</script>

</body>
</html>
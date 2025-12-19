<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.flowershop.Flower" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shop - Premium Collection</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8fbf9; font-family: 'Segoe UI', Tahoma, sans-serif; }
        .flower-card { border: none; border-radius: 15px; overflow: hidden; transition: 0.3s; background: white; }
        .flower-card:hover { transform: translateY(-10px); box-shadow: 0 15px 30px rgba(0,0,0,0.1); }
        .card-img-top { height: 200px; object-fit: cover; }
        .category-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: rgba(255,255,255,0.9);
            padding: 4px 10px;
            border-radius: 20px;
            color: #198754;
            font-weight: bold;
            font-size: 0.75rem;
            z-index: 2;
        }
        .search-box { border-radius: 20px; padding-left: 20px; border: 2px solid #eee; }
        .search-box:focus { border-color: #198754; box-shadow: none; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow">
    <div class="container">
        <a class="navbar-brand fw-bold" href="showFlowers">FLOWER<span class="text-success">SHOP</span></a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link text-white" href="index.jsp">Home</a></li>
            </ul>
        </div>
    </div>
</nav>

<main class="container my-5">
    <div class="row mb-5 g-3 align-items-center">
        <div class="col-lg-4">
            <h2 class="fw-bold m-0">Our Collection</h2>
        </div>
        <div class="col-lg-4">
            <input type="text" id="searchInput" class="form-control search-box" placeholder="Search product name..." onkeyup="filterItems()">
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
            List<Flower> list = (List<Flower>) request.getAttribute("allFlowers");
            if (list != null && !list.isEmpty()) {
                for (Flower f : list) {
        %>
            <div class="col-lg-3 col-md-4 col-sm-6 product-item"
                 data-category="<%= f.getCategory() %>"
                 data-name="<%= f.getName().toLowerCase() %>">
                <div class="card h-100 flower-card position-relative shadow-sm">
                    <span class="category-badge"><%= f.getCategory() %></span>
                    <img src="img/<%= f.getImageUrl() %>" class="card-img-top" alt="<%= f.getName() %>">
                    <div class="card-body text-center p-3">
                        <h6 class="fw-bold text-uppercase mb-2"><%= f.getName() %></h6>
                        <p class="text-success h5 mb-3">$<%= f.getPrice() %></p>
                        <a href="productDetails?id=<%= f.getId() %>" class="btn btn-success fw-bold w-100 py-2">
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
                <div class="alert alert-light shadow-sm py-5">
                    <h4 class="text-muted">No products available in shop.</h4>
                    <p>Make sure to launch from the Start Shopping button.</p>
                    <a href="showFlowers" class="btn btn-primary px-4">Refresh Shop</a>
                </div>
            </div>
        <% } %>
    </div>
</main>

<footer class="bg-dark text-white text-center py-4 mt-5">
    <div class="container">
        <p class="mb-0 small text-secondary">&copy; 2025 CAT201 Flower Shop Project. All Rights Reserved.</p>
    </div>
</footer>

<script>
    let currentCategory = 'all';

    // Update Category Filter Logic
    function setCategory(cat, btn) {
        currentCategory = cat;
        document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        filterItems();
    }

    // Combined Search and Category Logic
    function filterItems() {
        const query = document.getElementById('searchInput').value.toLowerCase();
        document.querySelectorAll('.product-item').forEach(item => {
            const itemCat = item.getAttribute('data-category');
            const itemName = item.getAttribute('data-name');

            const matchCat = (currentCategory === 'all' || itemCat === currentCategory);
            const matchSearch = itemName.includes(query);

            if (matchCat && matchSearch) {
                item.style.display = 'block';
            } else {
                item.style.display = 'none';
            }
        });
    }
</script>
</body>
</html>
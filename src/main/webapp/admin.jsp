<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel | FlowerShop Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .admin-card { margin-top: 50px; border: none; border-radius: 15px; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="showFlowers">FlowerShop Admin</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link active" href="showFlowers">View Shop</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#" onclick="alert('Admin Logged Out')">Logout</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow admin-card">
                <div class="card-header bg-primary text-white text-center py-3">
                    <h4 class="mb-0">Add New Product to Inventory</h4>
                </div>
                <div class="card-body p-4">
                    <form action="adminAction" method="post">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Plant Name</label>
                            <input type="text" name="name" class="form-control" placeholder="e.g. Red Rose" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Price ($)</label>
                            <input type="number" step="0.01" name="price" class="form-control" placeholder="0.00" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Category</label>
                            <select name="category" class="form-select">
                                <option value="Flowers">Flowers</option>
                                <option value="Plants">Other Plants</option>
                            </select>
                        </div>
                        <div class="d-grid gap-2 mt-4">
                            <button type="submit" class="btn btn-success btn-lg">Save to Database</button>
                            <a href="showFlowers" class="btn btn-outline-secondary">Cancel and Return</a>
                        </div>
                    </form>
                </div>
            </div>

            <div class="text-center mt-4">
                <p class="text-muted small">Logged in as: Administrator</p>
                <button class="btn btn-sm btn-link" onclick="location.reload()">Refresh Page</button>
            </div>
        </div>
    </div>
</div>

<footer class="text-center py-4 mt-5 text-muted">
    <p>&copy; 2025 CAT201 Flower Shop Project. Admin System.</p>
</footer>

</body>
</html>
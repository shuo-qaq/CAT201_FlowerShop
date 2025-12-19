<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to FlowerShop - Premium Florist</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root { --primary-color: #198754; --admin-color: #212529; }
        body, html { height: 100%; margin: 0; font-family: 'Segoe UI', Tahoma, sans-serif; }

        /* Split Screen Hero */
        .hero-section { display: flex; height: 100vh; overflow: hidden; }

        .hero-panel {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            transition: all 0.5s ease;
            text-align: center;
            padding: 40px;
            position: relative;
        }

        /* Customer Side */
        .customer-panel {
            background: linear-gradient(rgba(0,0,0,0.3), rgba(0,0,0,0.3)), url('https://images.unsplash.com/photo-1526047932273-341f2a7631f9?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80');
            background-size: cover;
            background-position: center;
            color: white;
        }

        /* Admin Side */
        .admin-panel {
            background-color: #f8f9fa;
            color: var(--admin-color);
            border-left: 1px solid #ddd;
        }

        .hero-panel:hover { flex: 1.2; }

        .btn-round {
            border-radius: 30px;
            padding: 12px 35px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: 0.3s;
        }

        .icon-box {
            font-size: 3rem;
            margin-bottom: 20px;
        }

        .badge-new {
            position: absolute;
            top: 20px;
            right: 20px;
            background: #ffc107;
            color: #000;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="hero-section">
    <div class="hero-panel customer-panel">
        <div class="icon-box"><i class="fas fa-seedling"></i></div>
        <h1 class="display-4 fw-bold">Fresh Flowers</h1>
        <p class="lead">Discover our premium collection for your loved ones.</p>
        <div class="mt-4">
            <a href="showFlowers" class="btn btn-success btn-round btn-lg shadow">
                <i class="fas fa-shopping-bag me-2"></i>Enter Shop
            </a>
        </div>
    </div>

    <div class="hero-panel admin-panel">
        <span class="badge-new">Staff Only</span>
        <div class="icon-box text-muted"><i class="fas fa-user-shield"></i></div>
        <h2 class="fw-bold">Management</h2>
        <p class="text-muted">Access inventory and order management systems.</p>
        <div class="mt-4">
            <a href="admin_login.jsp" class="btn btn-outline-dark btn-round">
                <i class="fas fa-lock me-2"></i>Admin Portal
            </a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FlowerShop | Welcome</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body, html {
            height: 100%;
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .hero-section {
            background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)),
                        url('https://images.unsplash.com/photo-1519306110291-4a38392b3a9c?auto=format&fit=crop&w=1350&q=80');
            background-size: cover;
            background-position: center;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-align: center;
        }
        .hero-content { max-width: 800px; }
        .btn-start {
            padding: 15px 40px;
            font-size: 1.25rem;
            font-weight: bold;
            border-radius: 30px;
            transition: 0.3s;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-transparent position-absolute w-100" style="z-index: 10;">
    <div class="container">
        <a class="navbar-brand fw-bold" href="index.jsp">FLOWER<span class="text-success">SHOP</span></a>

        <div class="ms-auto">
            <a href="login.jsp" class="btn btn-outline-light btn-sm fw-bold px-3" style="border-radius: 20px;">
                Admin Portal
            </a>
        </div>
    </div>
</nav>

<header class="hero-section">
    <div class="hero-content px-4">
        <h1 class="display-2 fw-bold mb-3">Nature's Best Beauty</h1>
        <p class="lead mb-5">Discover our premium collection of 30+ fresh flowers, rare plants, and gardening essentials delivered to your doorstep.</p>

        <a href="showFlowers" class="btn btn-success btn-start shadow-lg">
            Start Shopping
        </a>
    </div>
</header>

</body>
</html>
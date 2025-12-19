<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.flowershop.Flower" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Flower Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container py-5">
        <a href="showFlowers" class="btn btn-outline-secondary mb-4">&larr; Back to Shop</a>
        <% Flower f = (Flower) request.getAttribute("flower");
           if (f != null) { %>
        <div class="row bg-white p-4 shadow-sm rounded">
            <div class="col-md-6">
                <img src="img/<%= f.getImageUrl() %>" class="img-fluid rounded shadow" alt="<%= f.getName() %>">
            </div>
            <div class="col-md-6">
                <h1 class="fw-bold"><%= f.getName() %></h1>
                <h2 class="text-success">$<%= f.getPrice() %></h2>
                <p class="text-muted mt-4">This premium <%= f.getName().toLowerCase() %> is perfect for gifts.</p>
                <button class="btn btn-primary btn-lg mt-3" onclick="alert('Order Successful!')">Buy Now</button>
            </div>
        </div>
        <% } %>
    </div>
</body>
</html>
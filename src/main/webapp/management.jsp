<%
    // SECURITY CHECK: Prevents unauthorized access via manual URL entry.
    // We check the "role" attribute set by ManageFlowerServlet.
    String userRole = (String) session.getAttribute("role");

    if (userRole == null || !"admin".equals(userRole)) {
        // FIX: Redirect to the correct admin login page instead of the non-existent login.jsp
        response.sendRedirect("admin_login.jsp");
        return;
    }
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.flowershop.Flower" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Management Console - Flower Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f7f6; }
        .card-header { font-size: 1.1rem; }
        .table img { border-radius: 5px; object-fit: cover; }
    </style>
</head>
<body>

<div class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-dark">Inventory Management</h2>
        <div>
            <a href="showFlowers" class="btn btn-outline-secondary me-2">Back to Shop</a>
            <a href="manageFlower?action=logout" class="btn btn-danger">Logout</a>
        </div>
    </div>

    <div class="card shadow-sm mb-5 border-0">
        <div class="card-header bg-success text-white fw-bold">Add New Product</div>
        <div class="card-body">
            <form action="manageFlower" method="post" class="row g-3">
                <input type="hidden" name="action" value="add">
                <div class="col-md-3">
                    <input type="text" name="name" class="form-control" placeholder="Flower Name" required>
                </div>
                <div class="col-md-2">
                    <input type="number" step="0.01" name="price" class="form-control" placeholder="Price" required>
                </div>
                <div class="col-md-3">
                    <select name="category" class="form-select">
                        <option value="Flowers">Flowers</option>
                        <option value="Plants">Plants</option>
                        <option value="Tools">Tools</option>
                        <option value="Accessories">Accessories</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <input type="text" name="imageUrl" class="form-control" placeholder="Image Name (e.g., rose.jpg)">
                </div>
                <div class="col-md-1">
                    <button type="submit" class="btn btn-success w-100">Add</button>
                </div>
            </form>
        </div>
    </div>

    <div class="table-responsive bg-white p-3 shadow-sm rounded">
        <table class="table table-hover align-middle">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Image</th>
                    <th>Name</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Flower> list = (List<Flower>) request.getAttribute("allFlowers");
                    if(list != null) {
                        for(Flower f : list) {
                %>
                <tr>
                    <td><%= f.getId() %></td>
                    <td><img src="img/<%= f.getImageUrl() %>" width="50" height="50" alt="product"></td>
                    <%-- Update Form for each row --%>
                    <form action="manageFlower" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="<%= f.getId() %>">
                        <td><input type="text" name="name" class="form-control form-control-sm" value="<%= f.getName() %>"></td>
                        <td>
                            <select name="category" class="form-select form-select-sm">
                                <option value="Flowers" <%= "Flowers".equals(f.getCategory())?"selected":"" %>>Flowers</option>
                                <option value="Plants" <%= "Plants".equals(f.getCategory())?"selected":"" %>>Plants</option>
                                <option value="Tools" <%= "Tools".equals(f.getCategory())?"selected":"" %>>Tools</option>
                                <option value="Accessories" <%= "Accessories".equals(f.getCategory())?"selected":"" %>>Accessories</option>
                            </select>
                        </td>
                        <td><input type="number" step="0.01" name="price" class="form-control form-control-sm" value="<%= f.getPrice() %>"></td>
                        <td>
                            <button type="submit" class="btn btn-primary btn-sm">Update</button>
                            <a href="manageFlower?action=delete&id=<%= f.getId() %>"
                               class="btn btn-danger btn-sm"
                               onclick="return confirm('Delete this item?')">Delete</a>
                        </td>
                    </form>
                </tr>
                <% } } %>
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
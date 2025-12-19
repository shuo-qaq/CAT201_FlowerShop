<%
    // Security Guard: Prevents unauthorized access even if the URL is typed manually
    if (session.getAttribute("isAdmin") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.flowershop.Flower" %>
<a href="manageFlower?action=logout" class="btn btn-danger btn-sm">Logout</a>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.flowershop.Flower" %>
<!DOCTYPE html>
<html>
<head>
    <title>Management Console</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Inventory Management</h2>
        <a href="showFlowers" class="btn btn-outline-secondary">Back to Shop</a>
    </div>

    <div class="card shadow-sm mb-5">
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
                    <input type="text" name="imageUrl" class="form-control" placeholder="Image Filename (e.g., rose.jpg)">
                </div>
                <div class="col-md-1">
                    <button type="submit" class="btn btn-success w-100">Add</button>
                </div>
            </form>
        </div>
    </div>

    <table class="table table-white table-hover shadow-sm rounded">
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
                <td><img src="img/<%= f.getImageUrl() %>" width="50"></td>
                <form action="manageFlower" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="<%= f.getId() %>">
                    <td><input type="text" name="name" class="form-control form-control-sm" value="<%= f.getName() %>"></td>
                    <td>
                        <select name="category" class="form-select form-select-sm">
                            <option value="Flowers" <%= f.getCategory().equals("Flowers")?"selected":"" %>>Flowers</option>
                            <option value="Plants" <%= f.getCategory().equals("Plants")?"selected":"" %>>Plants</option>
                            <option value="Tools" <%= f.getCategory().equals("Tools")?"selected":"" %>>Tools</option>
                            <option value="Accessories" <%= f.getCategory().equals("Accessories")?"selected":"" %>>Accessories</option>
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
</body>
</html>
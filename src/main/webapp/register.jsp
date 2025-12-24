<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register - Flower Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center vh-100">
    <div class="container text-center" style="max-width: 400px;">
        <div class="card p-4 border-0 shadow">
            <h4 class="text-success mb-4">Join Our Shop</h4>

            <%-- Display error message if registration fails (e.g., username exists) --%>
            <% if ("exists".equals(request.getParameter("error"))) { %>
                <div class="alert alert-danger small">Username already exists. Please try another one.</div>
            <% } %>

            <%-- The form submits to /manageFlower with POST method --%>
            <form action="manageFlower" method="post">
                <input type="hidden" name="action" value="register">

                <div class="mb-3">
                    <input type="text" name="username" class="form-control" placeholder="Username" required>
                </div>

                <div class="mb-3">
                    <input type="password" name="password" class="form-control" placeholder="Password" required>
                </div>

                <button type="submit" class="btn btn-success w-100">SIGN UP</button>
            </form>

            <div class="mt-3">
                <small class="text-muted">Already have an account? <a href="user_login.jsp" class="text-success text-decoration-none">Login here</a></small>
            </div>
        </div>
    </div>
</body>
</html>
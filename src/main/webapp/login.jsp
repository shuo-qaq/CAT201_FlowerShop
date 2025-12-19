<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-dark d-flex align-items-center vh-100">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-4">
                <div class="card shadow-lg">
                    <div class="card-body p-5 text-center">
                        <h3 class="mb-4">Admin Access</h3>
                        <form action="manageFlower" method="post">
                            <input type="hidden" name="action" value="login">
                            <div class="mb-3 text-start">
                                <label class="form-label">Username</label>
                                <input type="text" name="username" class="form-control" required>
                            </div>
                            <div class="mb-4 text-start">
                                <label class="form-label">Password</label>
                                <input type="password" name="password" class="form-control" required>
                            </div>
                            <button type="submit" class="btn btn-success w-100 fw-bold">Login</button>
                        </form>
                        <% if ("failed".equals(request.getParameter("status"))) { %>
                            <div class="text-danger mt-3">Invalid Credentials!</div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
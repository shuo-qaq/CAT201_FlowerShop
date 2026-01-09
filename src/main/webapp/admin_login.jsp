<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin System Access</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #212529; }
        .admin-card { border-radius: 15px; border: 2px solid #ffc107; }
    </style>
</head>
<body class="d-flex align-items-center vh-100">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-4">
                <div class="card admin-card bg-dark text-white">
                    <div class="card-body p-5 text-center">
                        <h3 class="mb-4 fw-bold">ADMIN LOGIN</h3>
                        <form action="manageFlower" method="post">
                            <input type="hidden" name="action" value="login">
                            <input type="hidden" name="loginType" value="admin"> <div class="mb-3 text-start">
                                <label class="form-label small">Admin ID</label>
                                <input type="text" name="username" class="form-control" required>
                            </div>
                            <div class="mb-4 text-start">
                                <label class="form-label small">Security Password</label>
                                <input type="password" name="password" class="form-control" required>
                            </div>
                            <button type="submit" class="btn btn-warning w-100 fw-bold">VERIFY IDENTITY</button>
                        </form>
                        <% if ("failed".equals(request.getParameter("status"))) { %>
                            <div class="text-danger mt-3 small">Invalid Admin Credentials!</div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
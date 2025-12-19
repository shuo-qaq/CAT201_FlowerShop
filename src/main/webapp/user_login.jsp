<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Login - Flower Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f8fbf9; }
        .user-card { border: none; border-radius: 20px; box-shadow: 0 10px 25px rgba(0,0,0,0.05); }
    </style>
</head>
<body class="d-flex align-items-center vh-100">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-4">
                <div class="card user-card">
                    <div class="card-body p-5 text-center">
                        <h3 class="mb-4 fw-bold text-success">Customer Login</h3>
                        <p class="text-muted small">Enjoy our premium flowers.</p>

                        <form action="manageFlower" method="post">
                            <input type="hidden" name="action" value="login">
                            <input type="hidden" name="loginType" value="customer"> <div class="mb-3 text-start">
                                <label class="form-label small fw-bold">Username</label>
                                <input type="text" name="username" class="form-control" placeholder="Any name works" required>
                            </div>
                            <div class="mb-4 text-start">
                                <label class="form-label small fw-bold">Password</label>
                                <input type="password" name="password" class="form-control" placeholder="Any password works" required>
                            </div>
                            <button type="submit" class="btn btn-success w-100 fw-bold">LOGIN</button>
                        </form>

                        <div class="mt-4 d-flex justify-content-between small">
                            <a href="register.jsp" class="text-success text-decoration-none">Create Account</a>
                            <a href="forgot_password.jsp" class="text-muted text-decoration-none">Forgot Password?</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
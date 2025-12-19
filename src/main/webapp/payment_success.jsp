<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Successful - Flower Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8fbf9; font-family: 'Segoe UI', Tahoma, sans-serif; }
        .success-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            background: white;
            margin-top: 100px;
        }
        .checkmark-wrapper {
            width: 100px;
            height: 100px;
            background-color: #d1e7dd;
            color: #198754;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            margin: -50px auto 20px;
            font-size: 50px;
            border: 5px solid white;
        }
        .order-id {
            background-color: #f1f3f5;
            padding: 10px 20px;
            border-radius: 10px;
            font-family: monospace;
            color: #495057;
        }
    </style>
</head>
<body class="d-flex align-items-center justify-content-center vh-100">

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card success-card p-4 text-center">
                <div class="checkmark-wrapper">
                    <i class="fas fa-check"></i>
                </div>

                <h2 class="fw-bold text-dark mt-3">Payment Successful!</h2>
                <p class="text-muted mb-4">Thank you for your purchase. Your flowers are being prepared for delivery!</p>

                <div class="mb-4">
                    <span class="small text-uppercase text-muted d-block mb-2">Order Tracking Number</span>
                    <span class="order-id fw-bold">#FS-<%=(int)(Math.random()*900000 + 100000)%></span>
                </div>

                <div class="alert alert-success small text-start" role="alert">
                    <i class="fas fa-truck me-2"></i> Standard delivery: <strong>1-2 business days</strong>.
                </div>

                <hr class="my-4">

                <div class="d-grid gap-2">
                    <a href="showFlowers" class="btn btn-success btn-lg fw-bold py-3 shadow-sm">
                        <i class="fas fa-shopping-bag me-2"></i>CONTINUE SHOPPING
                    </a>
                    <a href="index.jsp" class="btn btn-link text-muted text-decoration-none small">
                        Back to Homepage
                    </a>
                </div>
            </div>

            <p class="text-center mt-4 text-muted small">
                A confirmation email has been sent to your registered address.
            </p>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
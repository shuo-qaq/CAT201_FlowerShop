<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<body class="bg-light d-flex align-items-center vh-100">
    <div class="container text-center" style="max-width: 400px;">
        <div class="card p-4 border-0 shadow">
            <h4 class="mb-3">Reset Password</h4>
            <p class="text-muted small">We will send a reset link to your email.</p>
            <input type="email" class="form-control mb-4" placeholder="Your Email">
            <button class="btn btn-primary w-100" onclick="alert('Email sent!'); window.location.href='user_login.jsp'">SEND RESET LINK</button>
        </div>
    </div>
</body>
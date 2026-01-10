<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.flowershop.OrderHistoryServlet.OrderRecord" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Order History - Flower Shop</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <style>
    body { background-color: #f8fbf9; font-family: 'Segoe UI', Tahoma, sans-serif; }
    .history-card { border: none; border-radius: 16px; }
    .badge-status { font-size: 0.85rem; }
    .mono { font-family: monospace; }
  </style>
</head>
<body>

<nav class="navbar navbar-dark bg-dark shadow-sm">
  <div class="container">
    <a class="navbar-brand fw-bold" href="showFlowers">FLOWER<span class="text-success">SHOP</span></a>
    <div class="d-flex align-items-center gap-2">
      <a href="showFlowers" class="btn btn-sm btn-outline-light">Back to Shop</a>
      <a href="manageFlower?action=logout" class="btn btn-sm btn-outline-danger">Logout</a>
    </div>
  </div>
</nav>

<div class="container my-5">
  <%
    Boolean isAdmin = (Boolean) request.getAttribute("isAdmin");
    if (isAdmin == null) isAdmin = false;
    String currentUser = (String) session.getAttribute("user");
  %>

  <div class="d-flex justify-content-between align-items-center mb-4">
    <div>
      <h2 class="fw-bold text-dark m-0">
        <i class="fas fa-receipt me-2 text-success"></i>Order History
      </h2>
      <p class="text-muted mb-0 small">
        <% if (isAdmin) { %>
        Admin view: displaying all orders in the system.
        <% } else { %>
        Showing orders for <span class="fw-bold"><%= currentUser %></span>.
        <% } %>
      </p>
    </div>
  </div>

  <div class="card history-card shadow-sm">
    <div class="card-body p-0">
      <table class="table table-hover align-middle mb-0">
        <thead class="table-dark">
        <tr>
          <th class="ps-4">Order ID</th>
          <th>User</th>
          <th>Total</th>
          <th>Status</th>
          <th>Order Date</th>
          <th class="pe-4">Shipping</th>
        </tr>
        </thead>
        <tbody>
        <%
          List<OrderRecord> orders = (List<OrderRecord>) request.getAttribute("orders");
          if (orders != null && !orders.isEmpty()) {
            for (OrderRecord o : orders) {
              String status = o.getOrderStatus();
              String badgeClass = "bg-secondary";
              if ("Pending".equalsIgnoreCase(status)) badgeClass = "bg-warning text-dark";
              if ("Paid".equalsIgnoreCase(status)) badgeClass = "bg-success";
              if ("Cancelled".equalsIgnoreCase(status)) badgeClass = "bg-danger";
        %>
        <tr>
          <td class="ps-4 mono">#<%= o.getOrderId() %></td>
          <td><%= o.getUsername() %></td>
          <td class="fw-bold text-success">$<%= String.format("%.2f", o.getTotalPrice()) %></td>
          <td><span class="badge <%= badgeClass %> badge-status"><%= status %></span></td>
          <td class="text-muted small"><%= o.getOrderDate() %></td>
          <td class="pe-4 small">
            <div class="fw-bold"><%= o.getPhoneNumber() %></div>
            <div class="text-muted"><%= o.getShippingAddress() %></div>
          </td>
        </tr>
        <%
          }
        } else {
        %>
        <tr>
          <td colspan="6" class="text-center py-5">
            <i class="fas fa-box-open fa-3x text-muted mb-3 d-block"></i>
            <p class="text-muted mb-0">No orders found.</p>
            <a href="showFlowers" class="btn btn-success mt-3">Start Shopping</a>
          </td>
        </tr>
        <% } %>
        </tbody>
      </table>
    </div>
  </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

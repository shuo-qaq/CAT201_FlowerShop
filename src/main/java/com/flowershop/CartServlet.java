package com.flowershop;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        // Map stores <FlowerID, Quantity>
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute("cart", cart);
        }

        if ("add".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            cart.put(id, cart.getOrDefault(id, 0) + 1);

            // Return the total quantity of items in cart
            int totalCount = 0;
            for (Integer qty : cart.values()) {
                totalCount += qty;
            }
            response.getWriter().write(String.valueOf(totalCount));
        } else if ("clear".equals(action)) {
            session.removeAttribute("cart");
            response.sendRedirect("cart.jsp");
        }
    }
}
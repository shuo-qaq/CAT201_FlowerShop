package com.flowershop;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        // Retrieve the cart from session or create a new one
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
        }

        if (action != null) {
            try {
                String idParam = request.getParameter("id");
                Integer id = (idParam != null) ? Integer.parseInt(idParam) : null;

                switch (action) {
                    case "add":
                        if (id != null) cart.put(id, cart.getOrDefault(id, 0) + 1);
                        break;
                    case "decrease":
                        if (id != null && cart.containsKey(id)) {
                            int currentQty = cart.get(id);
                            if (currentQty > 1) {
                                cart.put(id, currentQty - 1);
                            } else {
                                cart.remove(id); // Remove item if quantity hits zero
                            }
                        }
                        break;
                    case "clear":
                        cart.clear();
                        break;
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        session.setAttribute("cart", cart);

        // Smart Redirection Logic
        String ajax = request.getHeader("X-Requested-With");
        String referer = request.getHeader("Referer");

        if ("XMLHttpRequest".equals(ajax)) {
            response.setStatus(HttpServletResponse.SC_OK);
        } else if (referer != null && !referer.isEmpty()) {
            // Stay on the current page (Shop or Details) after action
            response.sendRedirect(referer);
        } else {
            response.sendRedirect("cart.jsp");
        }
    }
}
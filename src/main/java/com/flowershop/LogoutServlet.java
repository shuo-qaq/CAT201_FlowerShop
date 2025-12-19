package com.flowershop;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Destroy the session
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        // Go back to the shop page
        response.sendRedirect("showFlowers");
    }
}
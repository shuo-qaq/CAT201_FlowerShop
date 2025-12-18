package com.flowershop;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/showFlowers")
public class FlowerServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 模拟从数据库抓取数据
        List<Flower> flowerList = new ArrayList<>();
        flowerList.add(new Flower("Red Rose", 19.99));
        flowerList.add(new Flower("Blue Tulip", 12.50));
        flowerList.add(new Flower("Sun Flower", 8.00));


        request.setAttribute("allFlowers", flowerList);


        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
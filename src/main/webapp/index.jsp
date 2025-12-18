<%@ page import="java.util.List" %>
<%@ page import="com.flowershop.Flower" %>
...
<h2>Flower Inventory:</h2>
<%
    List<Flower> list = (List<Flower>) request.getAttribute("allFlowers");
    if (list != null) {
        for (Flower f : list) {
%>
    <p>Name: <%= f.getName() %> | Price: $<%= f.getPrice() %></p>
<%
        }
    } else {
%>
    <p>Please visit <a href="showFlowers">this link</a> to see the flowers!</p>
<%
    }
%>
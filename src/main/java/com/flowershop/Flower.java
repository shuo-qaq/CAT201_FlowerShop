package com.flowershop;

public class Flower {
    private int id;
    private String name;
    private double price;
    private String category;
    private String imageUrl;

    // Default Constructor
    public Flower() {}

    // Full Constructor for database mapping
    public Flower(int id, String name, double price, String category, String imageUrl) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.category = category;
        this.imageUrl = imageUrl;
    }

    // Getters used by JSP and Servlets
    public int getId() { return id; }
    public String getName() { return name; }
    public double getPrice() { return price; }
    public String getCategory() { return category; }
    public String getImageUrl() { return imageUrl; }
}
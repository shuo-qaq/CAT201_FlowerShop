package com.flowershop;

/**
 * Flower Entity Class
 * Represents a product in the flower shop database.
 */
public class Flower {
    private int id;
    private String name;
    private double price;
    private String category;
    private String imageUrl;
    private String description; // Added for detailed product introduction

    // 1. Default Constructor (Required for some frameworks and manual mapping)
    public Flower() {}

    // 2. Full Constructor for database mapping (Updated with description)
    public Flower(int id, String name, double price, String category, String imageUrl, String description) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.category = category;
        this.imageUrl = imageUrl;
        this.description = description;
    }

    // 3. Getters and Setters
    // These are essential for the JSP EL (Expression Language) to access data

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
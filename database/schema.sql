-- ==========================================================
-- 1. DATABASE INITIALIZATION
-- ==========================================================
-- Create the database if it does not exist
CREATE DATABASE IF NOT EXISTS flowershop_db;
USE flowershop_db;

-- Disable foreign key checks to allow safe dropping of tables
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS flowers;
SET FOREIGN_KEY_CHECKS = 1;

-- ==========================================================
-- 2. USERS TABLE (Authentication & Authorization)
-- ==========================================================
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    -- Unique username to prevent duplicate accounts
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL,
    -- User role can be 'admin' or 'customer'
    role VARCHAR(20) DEFAULT 'customer'
);

-- ==========================================================
-- 3. FLOWERS TABLE (Product Inventory)
-- ==========================================================
CREATE TABLE flowers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    -- DECIMAL ensures high precision for financial data
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(50) DEFAULT 'Flowers',
    image_url VARCHAR(255) DEFAULT 'default.jpg',
    description TEXT
);

-- ==========================================================
-- 4. ORDERS TABLE (Sales Transactions)
-- ==========================================================
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    shipping_address TEXT NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    order_status VARCHAR(20) DEFAULT 'Pending',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Links orders to specific users via the username
    CONSTRAINT fk_user_order FOREIGN KEY (username) 
        REFERENCES users(username) ON DELETE CASCADE
);

-- ==========================================================
-- 5. INITIAL DATA SEEDING
-- ==========================================================

-- Insert Default Accounts (Admin: admin123, User: pass123)
INSERT INTO users (username, password, role) VALUES 
('admin', 'admin123', 'admin'),
('user01', 'pass123', 'customer');

-- Insert Initial Flower Products
INSERT INTO flowers (name, price, category, image_url, description) VALUES 
('Red Rose', 12.99, 'Flowers', 'rose.jpg', 'Symbol of love and passion.'),
('White Lily', 15.50, 'Flowers', 'lily.jpg', 'Pure and elegant white lilies.'),
('Sun Flower', 8.00, 'Flowers', 'sunflower.jpg', 'Bright yellow flowers representing loyalty.'),
('Pink Tulip', 10.00, 'Flowers', 'tulip.jpg', 'Gentle and sweet pink tulips.'),
('Purple Orchid', 25.00, 'Flowers', 'orchid.jpg', 'An exotic touch of luxury.'),
('Lavender', 12.00, 'Flowers', 'lavender.jpg', 'Famous for its calming scent.'),
('Snake Plant', 35.00, 'Plants', 'snake_plant.jpg', 'The ultimate indoor air purifier.'),
('Monstera', 45.00, 'Plants', 'monstera.jpg', 'The trendy Swiss Cheese plant.'),
('Pruning Shears', 25.00, 'Tools', 'shears.jpg', 'High-quality stainless steel blades.'),
('Crystal Vase', 30.00, 'Accessories', 'vase_crystal.jpg', 'Stunning centerpiece for your home.');
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
-- 5. INITIAL DATA SEEDING (Complete 30 Products)
-- ==========================================================

-- Insert Default Accounts (Admin: admin123, User: pass123)
INSERT INTO users (username, password, role) VALUES 
('admin', 'admin123', 'admin'),
('user01', 'pass123', 'customer');

-- Insert 30 Flower Products (Full Original List)
INSERT INTO flowers (name, price, category, image_url, description) VALUES 
-- Flowers Section
('Red Rose', 12.99, 'Flowers', 'rose.jpg', 'Symbol of love and passion.'),
('White Lily', 15.50, 'Flowers', 'lily.jpg', 'Pure and elegant white lilies.'),
('Sun Flower', 8.00, 'Flowers', 'sunflower.jpg', 'Bright yellow flowers representing loyalty.'),
('Pink Tulip', 10.00, 'Flowers', 'tulip.jpg', 'Gentle and sweet pink tulips.'),
('Purple Orchid', 25.00, 'Flowers', 'orchid.jpg', 'An exotic touch of luxury.'),
('Lavender', 12.00, 'Flowers', 'lavender.jpg', 'Famous for its calming scent.'),
('Blue Hydrangea', 18.00, 'Flowers', 'hydrangea.jpg', 'Graceful and voluminous clusters.'),
('Yellow Daisy', 7.50, 'Flowers', 'daisy.jpg', 'Cheerful and innocent classic.'),
('Peony', 22.00, 'Flowers', 'peony.jpg', 'Lush and romantic ruffled petals.'),
('Carnation', 9.00, 'Flowers', 'carnation.jpg', 'A timeless classic for affection.'),
('Iris', 13.00, 'Flowers', 'iris.jpg', 'Wisdom and hope with unique petals.'),
('Chrysanthemum', 11.00, 'Flowers', 'chrysanthemum.jpg', 'Symbols of joy and optimism.'),

-- Plants Section
('Snake Plant', 35.00, 'Plants', 'snake_plant.jpg', 'The ultimate indoor air purifier.'),
('Monstera Adansonii', 45.00, 'Plants', 'monstera.jpg', 'The trendy Swiss Cheese plant.'),
('Cactus Set', 20.00, 'Plants', 'cactus.jpg', 'Low-maintenance desert trio.'),
('Aloe Vera', 15.00, 'Plants', 'aloe.jpg', 'Healing plant with soothing gel.'),
('Lucky Bamboo', 18.50, 'Plants', 'bamboo.jpg', 'Strength and positive energy.'),
('Peace Lily', 22.00, 'Plants', 'peace_lily.jpg', 'Elegant air cleaner.'),
('Spider Plant', 14.50, 'Plants', 'spider_plant.jpg', 'Best for removing indoor toxins.'),
('Money Tree', 38.00, 'Plants', 'money_tree.jpg', 'Financial luck and prosperity.'),

-- Tools Section
('Pruning Shears', 25.00, 'Tools', 'shears.jpg', 'Stainless steel blades.'),
('Watering Can', 19.99, 'Tools', 'watering_can.jpg', 'Precise watering design.'),
('Garden Shovel', 12.50, 'Tools', 'shovel.jpg', 'Reinforced steel head.'),
('Garden Gloves', 8.00, 'Tools', 'gloves.jpg', 'Thorn-proof protection.'),
('Mist Sprayer', 14.00, 'Tools', 'sprayer.jpg', 'Ideal for tropical plants.'),

-- Accessories Section
('Crystal Vase', 30.00, 'Accessories', 'vase_crystal.jpg', 'Stunning crystal centerpiece.'),
('Ceramic Pot', 22.00, 'Accessories', 'pot_ceramic.jpg', 'Hand-glazed matte finish.'),
('Flower Fertilizer', 10.00, 'Accessories', 'fertilizer.jpg', 'Organic liquid nutrients.'),
('Gift Card Set', 5.00, 'Accessories', 'gift_card.jpg', '5 floral-themed cards.'),
('Hanging Basket', 16.00, 'Accessories', 'basket.jpg', 'Natural fiber with metal chain.');
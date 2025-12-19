-- 1. Setup Database
CREATE DATABASE IF NOT EXISTS flowershop_db;
USE flowershop_db;

-- 2. Create Flowers Table
-- Added 'AUTO_INCREMENT' for ID and 'description' column
DROP TABLE IF EXISTS flowers;
CREATE TABLE flowers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(50) DEFAULT 'Flowers',
    image_url VARCHAR(255) DEFAULT 'default.jpg',
    description TEXT -- New column for detailed product info
);

-- 3. Insert All 30 Items with English Descriptions
INSERT INTO flowers (name, price, category, image_url, description) VALUES 
-- Flowers Section
('Red Rose', 12.99, 'Flowers', 'rose.jpg', 'The ultimate symbol of love and passion. These deep red roses are hand-picked for their velvet petals and long-lasting fragrance.'),
('White Lily', 15.50, 'Flowers', 'lily.jpg', 'Pure and elegant. White lilies are perfect for expressing sympathy or celebrating a fresh start with their majestic blooms.'),
('Sun Flower', 8.00, 'Flowers', 'sunflower.jpg', 'Bring sunshine into any room. These bright yellow sunflowers represent loyalty and longevity, standing tall and vibrant.'),
('Pink Tulip', 10.00, 'Flowers', 'tulip.jpg', 'Gentle and sweet. Pink tulips symbolize affection and care, making them an ideal gift for friends and family.'),
('Purple Orchid', 25.00, 'Flowers', 'orchid.jpg', 'An exotic touch of luxury. Purple orchids represent royalty and admiration, featuring delicate, long-lasting flowers.'),
('Lavender', 12.00, 'Flowers', 'lavender.jpg', 'Famous for its calming scent. Lavender is great for relaxation and adds a rustic, aromatic charm to your home decor.'),
('Blue Hydrangea', 18.00, 'Flowers', 'hydrangea.jpg', 'Graceful and voluminous. These blue hydrangeas symbolize heartfelt emotions and gratitude with their large, cloud-like clusters.'),
('Yellow Daisy', 7.50, 'Flowers', 'daisy.jpg', 'Cheerful and innocent. Daisies are the classic "happy" flower, perfect for brightening someone''s day or decorating a kitchen.'),
('Peony', 22.00, 'Flowers', 'peony.jpg', 'Lush and romantic. Peonies are known for their large, ruffled petals and symbolize prosperity and a happy marriage.'),
('Carnation', 9.00, 'Flowers', 'carnation.jpg', 'A timeless classic. Pink carnations represent a mother''s eternal love, offering great durability and a sweet, spicy scent.'),
('Iris', 13.00, 'Flowers', 'iris.jpg', 'Striking and unique. The purple iris represents wisdom and hope, standing out with its intricate petal architecture.'),
('Chrysanthemum', 11.00, 'Flowers', 'chrysanthemum.jpg', 'Symbols of joy and optimism. These vibrant mums are incredibly hardy and add a splash of color to any autumn arrangement.'),

-- Plants Section
('Snake Plant', 35.00, 'Plants', 'snake_plant.jpg', 'The ultimate air purifier. Snake plants are nearly indestructible and perfect for beginners, thriving in low light conditions.'),
('Monstera Adansonii', 45.00, 'Plants', 'monstera.jpg', 'The "Swiss Cheese" plant. A trendy tropical climber known for its unique leaf holes, perfect for a modern indoor aesthetic.'),
('Cactus Set', 20.00, 'Plants', 'cactus.jpg', 'A low-maintenance trio. These small desert plants require minimal water and add a cute, rugged touch to your windowsill.'),
('Aloe Vera', 15.00, 'Plants', 'aloe.jpg', 'The healing plant. Not only does it look great, but the gel inside its leaves can be used to soothe minor burns and skin irritations.'),
('Lucky Bamboo', 18.50, 'Plants', 'bamboo.jpg', 'Bring good fortune to your home. Easy to grow in water, this bamboo symbolizes strength and positive energy.'),
('Peace Lily', 22.00, 'Plants', 'peace_lily.jpg', 'Elegant air cleaner. Peace lilies feature dark green leaves and white "hooded" flowers, thriving in shaded indoor spots.'),
('Spider Plant', 14.50, 'Plants', 'spider_plant.jpg', 'Playful and prolific. Known for its arching leaves and "babies" that hang down, it is one of the best plants for removing indoor toxins.'),
('Money Tree', 38.00, 'Plants', 'money_tree.jpg', 'A symbol of prosperity. With its braided trunk and palm-like leaves, it is believed to bring financial luck and positive vibes.'),

-- Tools Section
('Pruning Shears', 25.00, 'Tools', 'shears.jpg', 'Heavy-duty stainless steel blades. Designed for clean cuts on stems and light branches to keep your plants healthy.'),
('Watering Can', 19.99, 'Tools', 'watering_can.jpg', 'Ergonomic design with a long spout. Ensures precise watering for indoor plants without splashing or spilling.'),
('Garden Shovel', 12.50, 'Tools', 'shovel.jpg', 'Reinforced steel head with a comfortable grip. Perfect for repotting plants or light digging in garden beds.'),
('Garden Gloves', 8.00, 'Tools', 'gloves.jpg', 'Thorn-proof and breathable material. Protects your hands while providing the dexterity needed for delicate planting.'),
('Mist Sprayer', 14.00, 'Tools', 'sprayer.jpg', 'Fine mist technology. Ideal for tropical plants like ferns and orchids that crave high humidity in indoor environments.'),

-- Accessories Section
('Crystal Vase', 30.00, 'Accessories', 'vase_crystal.jpg', 'High-clarity heavy crystal. A stunning centerpiece that enhances the beauty of any fresh-cut bouquet.'),
('Ceramic Pot', 22.00, 'Accessories', 'pot_ceramic.jpg', 'Hand-glazed matte finish. Features a drainage hole to prevent overwatering, suitable for medium-sized indoor plants.'),
('Flower Fertilizer', 10.00, 'Accessories', 'fertilizer.jpg', 'Organic liquid nutrients. Specially formulated to promote vibrant blooms and healthy root growth in flowering plants.'),
('Gift Card Set', 5.00, 'Accessories', 'gift_card.jpg', 'A set of 5 premium floral-themed cards. Perfect for adding a personalized handwritten message to your flower gift.'),
('Hanging Basket', 16.00, 'Accessories', 'basket.jpg', 'Natural coconut fiber liner with a sturdy metal chain. Adds a vertical dimension to your porch or balcony garden.');

-- 4. Setup Users Table
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL,
    role VARCHAR(20) DEFAULT 'customer' -- 'admin' or 'customer'
);

-- 5. Insert Initial Accounts
-- These match your Servlet logic
INSERT INTO users (username, password, role) VALUES 
('admin', 'admin123', 'admin'),
('user01', 'pass123', 'customer');
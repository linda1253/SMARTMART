-- Demo Data for DepartmentStore

USE DepartmentStore;

-- Categories
INSERT INTO Category (CategoryName, Description) VALUES
('Groceries', 'Fresh produce, dairy, bakery and pantry staples'),
('Clothing', 'Men, women and children apparel and accessories'),
('Household', 'Home essentials, cleaning supplies and kitchenware'),
('Personal Care', 'Health, beauty and personal hygiene products'),
('Electronics', 'Gadgets, appliances and electronic accessories');

-- Products
INSERT INTO Product (ProductName, Price, Stock, CategoryId) VALUES
('Organic Tomatoes (1kg)', 120.00, 150, 1),
('Whole Milk (1L)', 85.00, 200, 1),
('Brown Bread', 65.00, 80, 1),
('Eggs (12 pcs)', 180.00, 120, 1),
('Basmati Rice (5kg)', 650.00, 60, 1),
('Mens Cotton T-Shirt', 450.00, 90, 2),
('Womens Kurti', 850.00, 70, 2),
('Denim Jeans', 1200.00, 45, 2),
('Kids School Bag', 750.00, 35, 2),
('Stainless Steel Cookware', 2500.00, 20, 3),
('Floor Mop Set', 650.00, 40, 3),
('Dish Soap (500ml)', 95.00, 180, 3),
('Shampoo (400ml)', 320.00, 100, 4),
('Face Wash (100ml)', 180.00, 130, 4),
('Hand Sanitizer (200ml)', 120.00, 250, 4),
('Wireless Earbuds', 1800.00, 8, 5),
('USB-C Charger (65W)', 850.00, 15, 5),
('Power Bank (10000mAh)', 1200.00, 6, 5);
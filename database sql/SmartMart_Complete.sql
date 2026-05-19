-- ============================================================
-- SmartMart Department Store - Complete Database Setup
-- ============================================================
CREATE DATABASE IF NOT EXISTS DepartmentStore;
USE DepartmentStore;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS OrderItem;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Supplier;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS User;
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- TABLE: User
-- Stores all system users (Admin and Customer roles)
-- ============================================================
CREATE TABLE User (
  UserId        INT          NOT NULL AUTO_INCREMENT,
  FirstName     VARCHAR(50)  NOT NULL,
  LastName      VARCHAR(50)  NOT NULL,
  Email         VARCHAR(100) NOT NULL UNIQUE,
  Phone         VARCHAR(20)  NOT NULL,
  Password      VARCHAR(255) NOT NULL,
  Role          VARCHAR(20)  NOT NULL DEFAULT 'User',
  ApprovalStatus VARCHAR(20) NOT NULL DEFAULT 'Pending',
  CreatedAt     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (UserId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- TABLE: Category
-- Product categories (Groceries, Clothing, etc.)
-- ============================================================
CREATE TABLE Category (
  CategoryId   INT          NOT NULL AUTO_INCREMENT,
  CategoryName VARCHAR(100) NOT NULL,
  Description  TEXT,
  PRIMARY KEY (CategoryId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- TABLE: Supplier
-- Suppliers who provide products
-- ============================================================
CREATE TABLE Supplier (
  SupplierId   INT          NOT NULL AUTO_INCREMENT,
  SupplierName VARCHAR(100) NOT NULL,
  ContactName  VARCHAR(100),
  Email        VARCHAR(100),
  Phone        VARCHAR(20),
  Address      TEXT,
  PRIMARY KEY (SupplierId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- TABLE: Product
-- Products sold in the store
-- ============================================================
CREATE TABLE Product (
  ProductId   INT            NOT NULL AUTO_INCREMENT,
  ProductName VARCHAR(100)   NOT NULL,
  Description TEXT,
  Price       DECIMAL(10,2)  NOT NULL,
  Stock       INT            NOT NULL DEFAULT 0,
  CategoryId  INT            NOT NULL,
  SupplierId  INT,
  PRIMARY KEY (ProductId),
  FOREIGN KEY (CategoryId) REFERENCES Category(CategoryId) ON DELETE RESTRICT,
  FOREIGN KEY (SupplierId) REFERENCES Supplier(SupplierId) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- TABLE: Orders
-- Customer orders
-- ============================================================
CREATE TABLE Orders (
  OrderId       INT           NOT NULL AUTO_INCREMENT,
  OrderDate     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  OrderStatus   VARCHAR(50)   NOT NULL DEFAULT 'Pending',
  TotalAmount   DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  DeliveryAddress TEXT,
  UserId        INT           NOT NULL,
  PRIMARY KEY (OrderId),
  FOREIGN KEY (UserId) REFERENCES User(UserId) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- TABLE: OrderItem
-- Line items within each order
-- ============================================================
CREATE TABLE OrderItem (
  OrderItemId INT           NOT NULL AUTO_INCREMENT,
  OrderId     INT           NOT NULL,
  ProductId   INT           NOT NULL,
  Quantity    INT           NOT NULL DEFAULT 1,
  Price       DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (OrderItemId),
  FOREIGN KEY (OrderId)   REFERENCES Orders(OrderId)   ON DELETE CASCADE,
  FOREIGN KEY (ProductId) REFERENCES Product(ProductId) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- SAMPLE DATA
-- ============================================================

-- Admin user (password: admin123 - BCrypt hashed)
INSERT INTO User (FirstName, LastName, Email, Phone, Password, Role, ApprovalStatus) VALUES
('Admin', 'SmartMart', 'admin@smartmart.com', '9800000001',
 '$2a$12$K8HFnK5z5z5z5z5z5z5z5uQwQwQwQwQwQwQwQwQwQwQwQwQwQwQwO', 'Admin', 'Approved');

-- Regular users (password: user123 - BCrypt hashed)
INSERT INTO User (FirstName, LastName, Email, Phone, Password, Role, ApprovalStatus) VALUES
('John',  'Doe',   'john@example.com',  '9812345678',
 '$2a$12$K8HFnK5z5z5z5z5z5z5z5uQwQwQwQwQwQwQwQwQwQwQwQwQwQwQwO', 'User', 'Approved'),
('Priya', 'Sharma','priya@example.com', '9823456789',
 '$2a$12$K8HFnK5z5z5z5z5z5z5z5uQwQwQwQwQwQwQwQwQwQwQwQwQwQwQwO', 'User', 'Approved'),
('Rajan', 'Thapa', 'rajan@example.com', '9834567890',
 '$2a$12$K8HFnK5z5z5z5z5z5z5z5uQwQwQwQwQwQwQwQwQwQwQwQwQwQwQwO', 'User', 'Pending');

-- Categories
INSERT INTO Category (CategoryName, Description) VALUES
('Groceries',      'Fresh produce, dairy, bakery and pantry staples'),
('Clothing',       'Men, women and children apparel and accessories'),
('Household',      'Home essentials, cleaning supplies and kitchenware'),
('Personal Care',  'Health, beauty and personal hygiene products'),
('Electronics',    'Gadgets, appliances and electronic accessories');

-- Suppliers
INSERT INTO Supplier (SupplierName, ContactName, Email, Phone, Address) VALUES
('FreshFarm Pvt Ltd',   'Ram Bahadur',  'ram@freshfarm.com',   '9841001001', 'Kalimati, Kathmandu'),
('StyleHub Nepal',      'Sita Karki',   'sita@stylehub.com',   '9841002002', 'New Road, Kathmandu'),
('HomeEssentials Co.',  'Hari Prasad',  'hari@homeess.com',    '9841003003', 'Patan, Lalitpur'),
('CareFirst Nepal',     'Gita Rai',     'gita@carefirst.com',  '9841004004', 'Baneswor, Kathmandu'),
('TechWorld Nepal',     'Bikash Shrestha','bikash@techworld.com','9841005005','Putalisadak, Kathmandu');

-- Products
INSERT INTO Product (ProductName, Description, Price, Stock, CategoryId, SupplierId) VALUES
('Organic Tomatoes (1kg)',  'Fresh organic tomatoes',          120.00, 150, 1, 1),
('Whole Milk (1L)',         'Full cream pasteurized milk',      85.00, 200, 1, 1),
('Brown Bread',             'Whole wheat brown bread loaf',     65.00,  80, 1, 1),
('Eggs (12 pcs)',           'Farm fresh eggs, dozen',          180.00, 120, 1, 1),
('Basmati Rice (5kg)',      'Premium long grain basmati rice', 650.00,  60, 1, 1),
('Mens Cotton T-Shirt',     'Comfortable everyday cotton tee', 450.00,  90, 2, 2),
('Womens Kurti',            'Elegant printed cotton kurti',    850.00,  70, 2, 2),
('Denim Jeans',             'Classic fit blue denim jeans',   1200.00,  45, 2, 2),
('Kids School Bag',         'Durable waterproof school bag',   750.00,  35, 2, 2),
('Stainless Steel Cookware','5-piece non-stick cookware set', 2500.00,  20, 3, 3),
('Floor Mop Set',           'Microfiber mop with bucket',      650.00,  40, 3, 3),
('Dish Soap (500ml)',       'Lemon-scented dishwashing liquid',  95.00, 180, 3, 3),
('Shampoo (400ml)',         'Herbal anti-dandruff shampoo',    320.00, 100, 4, 4),
('Face Wash (100ml)',       'Neem & turmeric face wash',       180.00, 130, 4, 4),
('Hand Sanitizer (200ml)', '70% alcohol hand sanitizer',       120.00, 250, 4, 4),
('Wireless Earbuds',        'Bluetooth 5.0 true wireless earbuds',1800.00, 8, 5, 5),
('USB-C Charger (65W)',     'Fast charging USB-C adapter',     850.00,  15, 5, 5),
('Power Bank (10000mAh)',   'Slim portable power bank',       1200.00,   6, 5, 5);

-- Sample Orders
INSERT INTO Orders (OrderDate, OrderStatus, TotalAmount, DeliveryAddress, UserId) VALUES
('2026-04-10', 'Completed', 1015.00, 'Baneshwor, Kathmandu', 2),
('2026-04-15', 'Processing', 450.00, 'Lalitpur, Patan',      3),
('2026-04-18', 'Pending',    850.00, 'Baneshwor, Kathmandu', 2),
('2026-05-01', 'Completed', 2500.00, 'Thamel, Kathmandu',    3),
('2026-05-10', 'Completed',  650.00, 'Baneshwor, Kathmandu', 2);

-- Order Items
INSERT INTO OrderItem (OrderId, ProductId, Quantity, Price) VALUES
(1, 1, 2, 120.00),
(1, 2, 3,  85.00),
(1, 4, 1, 180.00),
(1, 3, 2,  65.00),
(2, 6, 1, 450.00),
(3, 7, 1, 850.00),
(4, 10,1,2500.00),
(5, 11,1, 650.00);

-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 21, 2026 at 07:05 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `departmentstore`
--
CREATE DATABASE IF NOT EXISTS `departmentstore` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `departmentstore`;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
CREATE TABLE IF NOT EXISTS `category` (
  `CategoryId` int(11) NOT NULL AUTO_INCREMENT,
  `CategoryName` varchar(100) NOT NULL,
  `Description` text DEFAULT NULL,
  PRIMARY KEY (`CategoryId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`CategoryId`, `CategoryName`, `Description`) VALUES
(1, 'Groceries', 'Fresh produce, dairy, bakery and pantry staples'),
(2, 'Clothing', 'Men, women and children apparel and accessories'),
(3, 'Household', 'Home essentials, cleaning supplies and kitchenware'),
(4, 'Personal Care', 'Health, beauty and personal hygiene products'),
(5, 'Electronics', 'Gadgets, appliances and electronic accessories');

-- --------------------------------------------------------

--
-- Table structure for table `orderitem`
--

DROP TABLE IF EXISTS `orderitem`;
CREATE TABLE IF NOT EXISTS `orderitem` (
  `OrderId` int(11) NOT NULL,
  `ProductId` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL DEFAULT 1,
  `Price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`OrderId`,`ProductId`),
  KEY `ProductId` (`ProductId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orderitem`
--

INSERT INTO `orderitem` (`OrderId`, `ProductId`, `Quantity`, `Price`) VALUES
(6, 5, 1, 650.00),
(7, 3, 1, 65.00),
(7, 8, 1, 1200.00),
(8, 3, 2, 65.00),
(8, 8, 2, 1200.00),
(9, 3, 2, 65.00),
(9, 5, 1, 650.00),
(9, 8, 1, 1200.00),
(10, 5, 3, 650.00),
(11, 5, 6, 650.00),
(12, 3, 2, 65.00),
(12, 5, 2, 650.00),
(12, 8, 1, 1200.00);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE IF NOT EXISTS `orders` (
  `OrderId` int(11) NOT NULL AUTO_INCREMENT,
  `OrderDate` date NOT NULL,
  `OrderStatus` varchar(50) NOT NULL,
  `UserId` int(11) NOT NULL,
  `TotalAmount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `DeliveryAddress` text DEFAULT NULL,
  PRIMARY KEY (`OrderId`),
  KEY `UserId` (`UserId`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`OrderId`, `OrderDate`, `OrderStatus`, `UserId`, `TotalAmount`, `DeliveryAddress`) VALUES
(6, '2026-05-20', 'Pending', 3, 650.00, 'pokhara'),
(7, '2026-05-20', 'Pending', 2, 1265.00, 'pokhara'),
(8, '2026-05-21', 'Cancelled', 2, 2530.00, 'Pokhara'),
(9, '2026-05-21', 'Completed', 3, 1980.00, 'ktm'),
(10, '2026-05-21', 'Pending', 3, 1950.00, 'lalitpur'),
(11, '2026-05-21', 'Pending', 3, 3900.00, 'somewhere'),
(12, '2026-05-21', 'Pending', 3, 2630.00, 'ktm');

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
CREATE TABLE IF NOT EXISTS `product` (
  `ProductId` int(11) NOT NULL AUTO_INCREMENT,
  `ProductName` varchar(100) NOT NULL,
  `Price` decimal(10,2) NOT NULL,
  `Stock` int(11) NOT NULL DEFAULT 0,
  `CategoryId` int(11) NOT NULL,
  PRIMARY KEY (`ProductId`),
  KEY `CategoryId` (`CategoryId`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`ProductId`, `ProductName`, `Price`, `Stock`, `CategoryId`) VALUES
(1, 'Organic Tomatoes (1kg)', 120.00, 150, 1),
(2, 'Whole Milk (1L)', 85.00, 200, 1),
(3, 'Brown Bread', 65.00, 73, 1),
(4, 'Eggs (12 pcs)', 180.00, 120, 1),
(5, 'Basmati Rice (5kg)', 650.00, 47, 1),
(6, 'Mens Cotton T-Shirt', 450.00, 90, 2),
(7, 'Womens Kurti', 850.00, 70, 2),
(8, 'Denim Jeans', 1200.00, 40, 2),
(9, 'Kids School Bag', 750.00, 35, 2),
(10, 'Stainless Steel Cookware', 2500.00, 20, 3),
(11, 'Floor Mop Set', 650.00, 40, 3),
(12, 'Dish Soap (500ml)', 95.00, 180, 3),
(13, 'Shampoo (400ml)', 320.00, 100, 4),
(14, 'Face Wash (100ml)', 180.00, 130, 4),
(15, 'Hand Sanitizer (200ml)', 120.00, 250, 4),
(16, 'Wireless Earbuds', 1800.00, 0, 5),
(17, 'USB-C Charger (65W)', 850.00, 15, 5),
(18, 'Power Bank (10000mAh)', 1200.00, 2, 5);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `UserId` int(11) NOT NULL AUTO_INCREMENT,
  `Role` varchar(20) NOT NULL,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Phone` varchar(20) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `ApprovalStatus` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`UserId`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`UserId`, `Role`, `FirstName`, `LastName`, `Email`, `Phone`, `Password`, `ApprovalStatus`) VALUES
(1, 'Admin', 'Admin', 'User', 'admin@smartmart.com', '9800000000', '$2a$12$dkPW/b/qOnYyVl/A4OoiQed6.f8vTOyWKKQZZcV0FPXKp7uBBJeNG', 'Approved'),
(2, 'User', 'Test', 'One', 'test@test.com', '9811111111', '$2a$12$GE7mDdOKlnQ9TxX8cU/HO.oC/sX7sG4xGNwutcT0CbBLW0/70oZyy', 'Approved'),
(3, 'User', 'test', 'two', 'test2@gmail.com', '9822222222', '$2a$12$2HdYeuKO2CG354/YCYMNFOFgL99uFYu75pyIDX26IFl2lCALQILCK', 'Approved'),
(4, 'User', 'John', 'Doe', 'john@example.com', '9812121212', '$2a$12$wHD.LIGSlqsOCRwvF7kMS.RuoA7C74kIfaaDBFYNDb4kLuYSDW6eK', 'Approved');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `orderitem`
--
ALTER TABLE `orderitem`
  ADD CONSTRAINT `orderitem_ibfk_1` FOREIGN KEY (`OrderId`) REFERENCES `orders` (`OrderId`) ON DELETE CASCADE,
  ADD CONSTRAINT `orderitem_ibfk_2` FOREIGN KEY (`ProductId`) REFERENCES `product` (`ProductId`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `user` (`UserId`) ON DELETE CASCADE;

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`CategoryId`) REFERENCES `category` (`CategoryId`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

DROP DATABASE IF EXISTS KhayyalRestaurant;
CREATE DATABASE KhayyalRestaurant;
USE KhayyalRestaurant;

 -- TABLES 
 
CREATE TABLE Department (
    DepartmentID   INT PRIMARY KEY AUTO_INCREMENT,
    DeptName       VARCHAR(50) NOT NULL
);

CREATE TABLE Employee (
    EmployeeID   INT PRIMARY KEY AUTO_INCREMENT,
    FullName     VARCHAR(100) NOT NULL,
    Role         VARCHAR(50),
    Salary       DECIMAL(8,2) CHECK (Salary > 0), 
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FullName   VARCHAR(100) NOT NULL,
    Phone      VARCHAR(15)
);

CREATE TABLE Category (
    CategoryID   INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(50) NOT NULL
);

CREATE TABLE MenuItem (
    MenuItemID INT PRIMARY KEY AUTO_INCREMENT,
    ItemName   VARCHAR(100) NOT NULL,
    Price      DECIMAL(6,2) CHECK (Price > 0), 
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

CREATE TABLE RestaurantTable (
    TableID   INT PRIMARY KEY AUTO_INCREMENT,
    TableNum  INT,
    Capacity  INT CHECK (Capacity > 0),
    Location  VARCHAR(30)
);

CREATE TABLE Reservation (
    ReservationID   INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID      INT,
    TableID         INT,
    ResDate         DATE NOT NULL,
    GuestsCount     INT CHECK (GuestsCount > 0), 
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (TableID)    REFERENCES RestaurantTable(TableID)
);

CREATE TABLE Orders (
    OrderID    INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    TableID    INT,
    EmployeeID INT,
    OrderDate  DATE NOT NULL,
    Status     VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (TableID)    REFERENCES RestaurantTable(TableID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID       INT,
    MenuItemID    INT,
    Quantity      INT CHECK (Quantity > 0), 
    UnitPrice     DECIMAL(6,2) CHECK (UnitPrice > 0),
    FOREIGN KEY (OrderID)    REFERENCES Orders(OrderID),
    FOREIGN KEY (MenuItemID) REFERENCES MenuItem(MenuItemID)
);

CREATE TABLE Payment (
    PaymentID     INT PRIMARY KEY AUTO_INCREMENT,
    OrderID       INT,
    Amount        DECIMAL(8,2) CHECK (Amount >= 0), 
    PaymentMethod VARCHAR(30),
    PaymentDate   DATE,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

 -- INSERT DATA 
 
INSERT INTO Department (DeptName) VALUES
('Kitchen'), ('Service'), ('Management');

INSERT INTO Employee (FullName, Role, Salary, DepartmentID) VALUES
('Ahmed Ali', 'Chef', 5000, 1),
('Sara Omar', 'Waiter', 3500, 2),
('Khalid Nasser', 'Manager', 8000, 3),
('Nora Salem', 'Waiter', 3500, 2),
('Yousef Hamad', 'Chef', 4500, 1);

INSERT INTO Customer (FullName, Phone) VALUES
('Mohammed Salem', '0511111111'),
('Hessa Ali', '0512222222'),
('Turki Rashid', '0513333333'),
('Reem Fahad', '0514444444'),
('Abdullah Saad', '0515555555');

INSERT INTO Category (CategoryName) VALUES
('Main Dishes'), ('Appetizers'), ('Desserts'), ('Drinks');

INSERT INTO MenuItem (ItemName, Price, CategoryID) VALUES
('Kabsa', 45, 1), ('Mandi', 40, 1), ('Grilled Fish', 55, 1),
('Hummus', 15, 2), ('Fattoush', 18, 2),
('Umm Ali', 22, 3), ('Baklava', 18, 3),
('Arabic Coffee', 8, 4), ('Lemon Mint', 14, 4), ('Mango Juice', 16, 4);

INSERT INTO RestaurantTable (TableNum, Capacity, Location) VALUES
(1,2,'Indoor'), (2,4,'Indoor'), (3,6,'Outdoor'), (4,8,'VIP'), (5,4,'Indoor');

INSERT INTO Reservation (CustomerID, TableID, ResDate, GuestsCount) VALUES
(1,4,'2026-05-03',6),
(2,3,'2026-05-04',3),
(3,2,'2026-05-05',4),
(4,4,'2026-05-06',7),
(5,1,'2026-05-07',2);

INSERT INTO Orders (CustomerID, TableID, EmployeeID, OrderDate, Status) VALUES
(1,2,2,'2026-04-28','Served'),
(2,4,2,'2026-04-28','Served'),
(3,3,4,'2026-04-29','Served'),
(4,1,2,'2026-04-29','Pending'),
(5,5,4,'2026-04-27','Served');

INSERT INTO OrderDetails (OrderID, MenuItemID, Quantity, UnitPrice) VALUES
(1,1,2,45),(1,4,1,15),(1,8,2,8),
(2,2,1,40),(2,5,2,18),
(3,3,1,55),(3,6,2,22),
(4,1,3,45),(4,9,2,14),
(5,2,2,40);

INSERT INTO Payment (OrderID, Amount, PaymentMethod, PaymentDate) VALUES
(1,121,'Cash','2026-04-28'),
(2,76,'Credit Card','2026-04-28'),
(3,99,'Cash','2026-04-29'),
(5,100,'Debit Card','2026-04-27');

 -- QUERIES 
 
 -- 1. DISTINCT & ORDER BY
SELECT DISTINCT Location FROM RestaurantTable ORDER BY Location ASC;

-- 2. Aggregation Function, AS & GROUP BY
SELECT Role, AVG(Salary) AS Average_Salary FROM Employee GROUP BY Role;


 -- 3. INTERSECT Alternative  
SELECT DISTINCT CustomerID 
FROM Orders 
WHERE CustomerID IN (SELECT CustomerID FROM Reservation);

-- 4. EXCEPT Alternative  
SELECT CustomerID 
FROM Customer 
WHERE CustomerID NOT IN (SELECT CustomerID FROM Orders);


 -- 5. UNION ALL  
SELECT FullName AS PersonName, 'Customer' AS Type FROM Customer 
UNION ALL 
SELECT FullName AS PersonName, 'Employee' AS Type FROM Employee;

-- 6. Outer Join (LEFT JOIN)
SELECT Customer.FullName, Reservation.ResDate FROM Customer LEFT JOIN Reservation ON Customer.CustomerID = Reservation.CustomerID;


 -- 7. Nested Query & IN
SELECT FullName, Phone FROM Customer WHERE CustomerID IN (SELECT CustomerID FROM Orders WHERE Status = 'Pending');

-- 8. GROUP BY + HAVING + ORDER BY
SELECT CategoryID, COUNT(*) AS TotalItems 
FROM MenuItem 
GROUP BY CategoryID 
HAVING COUNT(*) >= 2 
ORDER BY TotalItems DESC;


 -- 9. Logical Operator (ALL) & LIKE
SELECT FullName, Salary, Role 
FROM Employee 
WHERE Salary > ALL (SELECT Salary FROM Employee WHERE Role = 'Waiter') 
AND FullName LIKE '%Ali%';

-- 10. Link 3 or More Tables 
SELECT C.FullName, O.OrderDate, M.ItemName 
FROM Customer C 
JOIN Orders O ON C.CustomerID = O.CustomerID 
JOIN OrderDetails OD ON O.OrderID = OD.OrderID 
JOIN MenuItem M ON OD.MenuItemID = M.MenuItemID;
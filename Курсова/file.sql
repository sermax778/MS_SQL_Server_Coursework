USE [MyDB]
GO

CREATE TABLE Fabric (
ID_Fabric int IDENTITY(1,1) PRIMARY KEY,
Fabric_Name varchar(255) NOT NULL,
Fabric_Price float NOT NULL,
Fabric_Stock float NOT NULL,
CONSTRAINT Fabric_Price_Check CHECK(Fabric_Price>0),
CONSTRAINT Fabric_Stock_Check CHECK(Fabric_Stock>=0)
)

CREATE TABLE Furniture (
ID_Furniture int IDENTITY(1,1) PRIMARY KEY,
Furniture_Name varchar(255) NOT NULL,
Furniture_Price float NOT NULL,
Furniture_Stock float NOT NULL,
CONSTRAINT Furniture_Price_Check CHECK(Furniture_Price>0),
CONSTRAINT Furniture_Stock_Check CHECK(Furniture_Stock>=0)
)

CREATE TABLE Performers (
ID_Performer int IDENTITY(1,1) PRIMARY KEY,
Performer_Name varchar(255) NOT NULL,
Performer_Surname varchar(255) NOT NULL
)

CREATE TABLE Customers (
ID_Customer int IDENTITY(1,1) PRIMARY KEY,
Customer_Name varchar(255) NOT NULL,
Customer_Surname varchar(255) NOT NULL
)

CREATE TABLE Supplies (
ID_Supply int IDENTITY(1,1) PRIMARY KEY,
ID_Fabric_Supply int FOREIGN KEY REFERENCES Fabric(ID_Fabric),
Amount float NOT NULL,
Total float,
IsPaid bit NOT NULL,
IsDone bit NOT Null,
CONSTRAINT Supplies_Amount_Check CHECK(Amount>0),
CONSTRAINT Supplies_Total_Check CHECK(Total>0)
)

CREATE TABLE Models (
ID_Model int IDENTITY(1,1) PRIMARY KEY,
Model_Name varchar(255) NOT NULL,
ID_Fabric_Model int FOREIGN KEY REFERENCES Fabric(ID_Fabric),
Model_Fabric_Amount float NOT NULL,
ID_Furniture_Model int FOREIGN KEY REFERENCES Furniture(ID_Furniture),
Model_Price float,
CONSTRAINT Model_Fabric_Amount_Check CHECK(Model_Fabric_Amount>0),
CONSTRAINT Model_Price_Check CHECK(Model_Price>0)
)

CREATE TABLE Orders (
ID_Order int IDENTITY(1,1) PRIMARY KEY,
ID_Model_Order int FOREIGN KEY REFERENCES Models(ID_Model),
ID_Customer_Order int FOREIGN KEY REFERENCES Customers(ID_Customer),
ID_Performer_Order int FOREIGN KEY REFERENCES Performers(ID_Performer),
Order_Reception_Date date,
Order_Fitting_Date date,
Order_Done_Date date,
IsPaid bit NOT NULL
)

--triggers

--trigger for adding record to supplies
CREATE TRIGGER SuppliesCorrection
ON Supplies
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE Supplies
    SET Total = Fabric.Fabric_Price * Amount
    FROM Supplies
    JOIN Fabric ON Supplies.ID_Fabric_Supply = Fabric.ID_Fabric
END

--trigger for adding record to models
CREATE TRIGGER ModelsCorrection
ON Models
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE Models
    SET Model_Price = Fabric.Fabric_Price * Model_Fabric_Amount + Furniture.Furniture_Price
    FROM Models
    JOIN Fabric ON Models.ID_Fabric_Model = Fabric.ID_Fabric
    JOIN Furniture ON Models.ID_Furniture_Model = Furniture.ID_Furniture
END


CREATE TRIGGER UpdateFabricStock
ON Orders
AFTER INSERT
AS
BEGIN
    DECLARE @amount float

    SELECT @amount = Model_Fabric_Amount
    FROM Models
    JOIN Orders ON Models.ID_Model = Orders.ID_Model_Order

    UPDATE Fabric
    SET Fabric_Stock = Fabric_Stock - @amount
    FROM Fabric
    JOIN Models ON Fabric.ID_Fabric = Models.ID_Fabric_Model
    JOIN Orders ON Models.ID_Model = Orders.ID_Model_Order
END


CREATE TRIGGER UpdateFurnitureStock
ON Orders
AFTER INSERT
AS
BEGIN
    UPDATE Furniture
    SET Furniture_Stock = Furniture_Stock - 1
    FROM Furniture
    JOIN Models ON Furniture.ID_Furniture = Models.ID_Furniture_Model
    JOIN Orders ON Models.ID_Model = Orders.ID_Model_Order
END



--examples of filled tables

INSERT INTO Fabric (Fabric_Name, Fabric_Price, Fabric_Stock)
VALUES ('Cotton', 10.50, 50),
       ('Silk', 20.00, 25),
       ('Linen', 15.75, 35),
       ('Wool', 25.00, 15),
       ('Polyester', 5.00, 75),
       ('Nylon', 7.50, 60),
       ('Acrylic', 8.25, 40),
       ('Rayon', 12.50, 30),
       ('Satin', 18.75, 20),
       ('Taffeta', 22.50, 10),
       ('Tweed', 27.50, 5),
       ('Velvet', 32.50, 2),
       ('Corduroy', 37.50, 1),
       ('Denim', 42.50, 3),
       ('Flannel', 47.50, 4),
       ('Suede', 52.50, 6),
       ('Organza', 57.50, 7),
       ('Chiffon', 62.50, 8),
       ('Tulle', 67.50, 9)

INSERT INTO Furniture (Furniture_Name, Furniture_Price, Furniture_Stock)
VALUES ('Table', 100.00, 10),
       ('Chair', 50.00, 20),
       ('Sofa', 250.00, 5),
       ('Bed', 500.00, 2),
       ('Dresser', 150.00, 15),
       ('Couch', 300.00, 8),
       ('Bookshelf', 75.00, 25),
       ('Desk', 125.00, 18),
       ('Bedside table', 35.00, 30),
       ('Armchair', 80.00, 22),
       ('Coffee table', 60.00, 12),
       ('Ottoman', 40.00, 14),
       ('Dining table', 200.00, 6),
       ('Wardrobe', 400.00, 3),
       ('Rug', 20.00, 35),
       ('Lamp', 30.00, 28),
       ('Mirror', 75.00, 10),
       ('Pouf', 45.00, 20)

INSERT INTO Performers (Performer_Name, Performer_Surname)
VALUES ('John', 'Smith'),
       ('Jane', 'Doe'),
       ('Michael', 'Williams'),
       ('Emily', 'Jones'),
       ('Matthew', 'Brown'),
       ('Madison', 'Garcia'),
       ('Joshua', 'Miller'),
       ('Ashley', 'Davis'),
       ('Jacob', 'Rodriguez'),
       ('Samantha', 'Martinez')

INSERT INTO Customers (Customer_Name, Customer_Surname)
VALUES ('Amy', 'Taylor'),
       ('Brian', 'Moore'),
       ('Charlie', 'Jackson'),
       ('Diana', 'Martin'),
       ('Edward', 'Lee'),
       ('Felicity', 'Perez'),
       ('Gary', 'Thompson'),
       ('Hannah', 'White'),
       ('Isaac', 'Harris'),
       ('Julia', 'Young')

INSERT INTO Supplies (ID_Fabric_Supply, Amount, IsPaid, IsDone)
VALUES  (1, 4.3, 1, 1),
		(2, 2.1, 1, 1),
		(3, 3.5, 1, 1),
		(4, 1.2, 1, 1),
		(5, 4.7, 1, 1),
		(6, 3.2, 1, 1),
		(7, 2.9, 1, 1),
		(8, 1.5, 1, 1),
		(9, 4.4, 1, 1),
		(10, 2.8, 1, 1),
		(11, 3.1, 1, 1),
		(12, 1.3, 1, 1),
		(13, 4.6, 1, 1),
		(14, 3.4, 1, 1),
		(15, 2.7, 1, 1),
		(16, 1.1, 1, 1),
		(17, 4.5, 0, 0),
		(18, 3.3, 0, 1),
		(19, 2.6, 1, 0)

INSERT INTO Models (Model_Name, ID_Fabric_Model, Model_Fabric_Amount, ID_Furniture_Model)
VALUES  ('Model1', 1, 2.5, 5),
		('Model2', 3, 1.7, 12),
		('Model3', 8, 2.1, 15),
		('Model4', 12, 2.3, 4),
		('Model5', 18, 1.9, 8),
		('Model6', 14, 2.7, 11),
		('Model7', 2, 1.2, 7),
		('Model8', 9, 3.0, 3),
		('Model9', 6, 2.8, 18),
		('Model10', 5, 1.5, 16),
		('Model11', 15, 2.6, 6),
		('Model12', 11, 1.1, 10),
		('Model13', 7, 2.9, 13),
		('Model14', 17, 3.4, 17),
		('Model15', 4, 2.7, 14),
		('Model16', 1, 1.3, 2),
		('Model17', 16, 2.5, 9),
		('Model18', 13, 1.7, 7),
		('Model19', 10, 2.1, 1),
		('Model20', 19, 2.3, 5)

INSERT INTO Orders (ID_Model_Order, ID_Customer_Order, ID_Performer_Order, Order_Reception_Date, Order_Fitting_Date, Order_Done_Date, IsPaid)
VALUES  (5, 4, 7, '2022-01-01', '2022-02-02', '2022-03-03', 1),
		(13, 5, 4, '2022-01-02', '2022-02-01', '2022-03-01', 1),
		(11, 8, 6, '2022-01-03', '2022-02-04', '2022-03-05', 1),
		(4, 9, 1, '2022-01-04', '2022-02-03', '2022-03-02', 1),
		(20, 2, 8, '2022-01-05', '2022-02-06', '2022-03-07', 1),
		(18, 1, 4, '2022-01-06', '2022-02-05', '2022-03-04', 1),
		(2, 5, 5, '2022-01-07', '2022-02-08', '2022-03-09', 1),
		(9, 8, 6, '2022-01-08', '2022-02-07', '2022-03-06', 1),
		(7, 3, 2, '2022-01-09', '2022-02-10', '2022-03-11', 1),
		(12, 9, 8, '2022-01-10', '2022-02-09', '2022-03-08', 1),
		(3, 2, 7, '2022-01-11', '2022-02-12', '2022-03-13', 1),
		(14, 4, 5, '2022-01-12', '2022-02-11', '2022-03-10', 1),
		(16, 5, 6, '2022-01-13', '2022-02-14', '2022-03-15', 1),
		(1, 8, 3, '2022-01-14', '2022-02-13', '2022-03-12', 1),
		(17, 7, 8, '2022-01-15', '2022-02-16', '2022-03-17', 1),
		(19, 10, 7, '2022-01-16', '2022-02-15', NULL, 0),
		(10, 2, 5, '2022-01-17', '2022-02-18', NULL, 0),
		(8, 3, 6, '2022-01-18', NULL, NULL, 1),
		(6, 9, 3, '2022-01-19', NULL, NULL, 1),
		(15, 4, 10, '2022-01-20', NULL, NULL, 0)

SELECT * FROM Fabric;
SELECT * FROM Furniture;
SELECT * FROM Performers;
SELECT * FROM Customers;
SELECT * FROM Supplies;
SELECT * FROM Models;
SELECT * FROM Orders;


--Procedures

--1
CREATE PROCEDURE ShowStock
AS
BEGIN
    SELECT 'Fabric' as ProductType, Fabric_Name, Fabric_Stock FROM Fabric
    UNION
    SELECT 'Furniture' as ProductType, Furniture_Name, Furniture_Stock FROM Furniture
END

EXEC ShowStock;

--2
CREATE PROCEDURE GetProduct
    @ProductName varchar(255)
AS
BEGIN
    IF EXISTS (SELECT Fabric_Name FROM Fabric WHERE Fabric_Name = @ProductName)
    BEGIN
        SELECT 'Fabric' as ProductType, ID_Fabric, Fabric_Name, Fabric_Price, Fabric_Stock FROM Fabric
        WHERE Fabric_Name = @ProductName
    END
    ELSE IF EXISTS (SELECT Furniture_Name FROM Furniture WHERE Furniture_Name = @ProductName)
    BEGIN
        SELECT 'Furniture' as ProductType, ID_Furniture, Furniture_Name, Furniture_Price, Furniture_Stock FROM Furniture
        WHERE Furniture_Name = @ProductName
    END
    ELSE IF EXISTS (SELECT Model_Name FROM Models WHERE Model_Name = @ProductName)
    BEGIN
        SELECT 'Model' as ProductType, ID_Model, Model_Name, Model_Price, Model_Fabric_Amount FROM Models
        WHERE Model_Name = @ProductName
    END
    ELSE
    BEGIN
        PRINT 'Product not found'
    END
END


EXEC GetProduct @ProductName = 'Cotton'

--3
CREATE PROCEDURE ShowIncompOrders
AS
BEGIN
    SELECT ID_Order, ID_Model_Order, ID_Customer_Order, ID_Performer_Order, Order_Reception_Date, Order_Fitting_Date, Order_Done_Date, IsPaid
    FROM Orders
    WHERE Order_Done_Date IS NOT NULL
END


EXEC ShowIncompOrders

--4
CREATE PROCEDURE ShowPerformersWithOrderCount
AS
BEGIN
    SELECT ID_Performer, Performer_Name, Performer_Surname, COUNT(ID_Performer_Order) as Order_Count
    FROM Performers
    LEFT JOIN Orders ON Performers.ID_Performer = Orders.ID_Performer_Order
    GROUP BY ID_Performer, Performer_Name, Performer_Surname
END


EXEC ShowPerformersWithOrderCount

--5
CREATE PROCEDURE ShowOrdersWithPrice
AS
BEGIN
    SELECT ID_Order, Models.Model_Price as Order_Price
    FROM Orders
    JOIN Models ON Orders.ID_Model_Order = Models.ID_Model
END


EXEC ShowOrdersWithPrice

--6
CREATE PROCEDURE ShowOrdersDetails
AS
BEGIN
    SELECT 
        ID_Order, 
        Models.Model_Name as Model_Name,
        Models.Model_Price as Model_Price,
        Customers.Customer_Name as Customer_Name,
        Customers.Customer_Surname as Customer_Surname,
        Performers.Performer_Name as Performer_Name,
        Performers.Performer_Surname as Performer_Surname,
        Order_Reception_Date as Reception_Date
    FROM Orders
    JOIN Models ON Orders.ID_Model_Order = Models.ID_Model
    JOIN Customers ON Orders.ID_Customer_Order = Customers.ID_Customer
    JOIN Performers ON Orders.ID_Performer_Order = Performers.ID_Performer
END


EXEC ShowOrdersDetails

--7
CREATE PROCEDURE ShowCustomerDebt
AS
BEGIN
    SELECT 
        ID_Customer, 
        SUM(Models.Model_Price) as Customer_Debt
    FROM Orders
    JOIN Models ON Orders.ID_Model_Order = Models.ID_Model
    JOIN Customers ON Orders.ID_Customer_Order = Customers.ID_Customer
    WHERE IsPaid = 0
    GROUP BY ID_Customer
END


EXEC ShowCustomerDebt


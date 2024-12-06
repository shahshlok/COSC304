CREATE DATABASE orders;
go

USE orders;
go

DROP TABLE review;
DROP TABLE shipment;
DROP TABLE productinventory;
DROP TABLE warehouse;
DROP TABLE orderproduct;
DROP TABLE incart;
DROP TABLE product;
DROP TABLE category;
DROP TABLE ordersummary;
DROP TABLE paymentmethod;
DROP TABLE customer;


CREATE TABLE customer (
    customerId          INT IDENTITY,
    firstName           VARCHAR(40),
    lastName            VARCHAR(40),
    email               VARCHAR(50),
    phonenum            VARCHAR(20),
    address             VARCHAR(50),
    city                VARCHAR(40),
    state               VARCHAR(20),
    postalCode          VARCHAR(20),
    country             VARCHAR(40),
    userid              VARCHAR(20),
    password            VARCHAR(30),
    PRIMARY KEY (customerId)
);

CREATE TABLE paymentmethod (
    paymentMethodId     INT IDENTITY,
    paymentType         VARCHAR(20),
    paymentNumber       VARCHAR(30),
    paymentExpiryDate   DATE,
    customerId          INT,
    PRIMARY KEY (paymentMethodId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE ordersummary (
    orderId             INT IDENTITY,
    orderDate           DATETIME,
    totalAmount         DECIMAL(10,2),
    shiptoAddress       VARCHAR(50),
    shiptoCity          VARCHAR(40),
    shiptoState         VARCHAR(20),
    shiptoPostalCode    VARCHAR(20),
    shiptoCountry       VARCHAR(40),
    customerId          INT,
    PRIMARY KEY (orderId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE category (
    categoryId          INT IDENTITY,
    categoryName        VARCHAR(50),    
    PRIMARY KEY (categoryId)
);

CREATE TABLE product (
    productId           INT IDENTITY,
    productName         VARCHAR(40),
    productPrice        DECIMAL(10,2),
    productImageURL     VARCHAR(100),
    productImage        VARBINARY(MAX),
    productDesc         VARCHAR(1000),
    categoryId          INT,
    PRIMARY KEY (productId),
    FOREIGN KEY (categoryId) REFERENCES category(categoryId)
);

CREATE TABLE orderproduct (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE incart (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE warehouse (
    warehouseId         INT IDENTITY,
    warehouseName       VARCHAR(30),    
    PRIMARY KEY (warehouseId)
);

CREATE TABLE shipment (
    shipmentId          INT IDENTITY,
    shipmentDate        DATETIME,   
    shipmentDesc        VARCHAR(100),   
    warehouseId         INT, 
    PRIMARY KEY (shipmentId),
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE productinventory ( 
    productId           INT,
    warehouseId         INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (productId, warehouseId),   
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE review (
    reviewId            INT IDENTITY,
    reviewRating        INT,
    reviewDate          DATETIME,   
    customerId          INT,
    productId           INT,
    reviewComment       VARCHAR(1000),          
    PRIMARY KEY (reviewId),
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE CASCADE
);


INSERT INTO category(categoryName) VALUES ('Nike Shoes');
INSERT INTO category(categoryName) VALUES ('Adidas Shoes');
INSERT INTO category(categoryName) VALUES ('Nike Apparel');
INSERT INTO category(categoryName) VALUES ('Adidas Apparel');
INSERT INTO category(categoryName) VALUES ('Basketball Equipment');

-- Add new products
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Nike Air Force 1', 1, 'Classic white sneakers', 100.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Nike Air Jordan 1', 1, 'High-top basketball shoes', 180.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Nike Air Max 270', 1, 'Running and lifestyle shoes', 150.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Nike Dunk Low', 1, 'Low-top casual sneakers', 110.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Nike Air Zoom GT Jump', 1, 'Performance basketball shoes', 180.00);

INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Adidas Ultraboost Light', 2, 'Premium running shoes', 190.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Adidas Forum Low', 2, 'Classic lifestyle sneakers', 100.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Adidas NMD_R1', 2, 'Casual lifestyle shoes', 150.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Adidas Trae Young 2.0', 2, 'Signature basketball shoes', 140.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Adidas Superstar', 2, 'Classic shell-toe sneakers', 90.00);

INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Nike NBA Lakers Jersey', 3, 'Official NBA swingman jersey', 120.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Nike Therma Fit Hoodie', 3, 'Warm athletic hoodie', 65.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Nike Dri-FIT Shorts', 3, 'Athletic training shorts', 35.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Nike Tech Fleece Jacket', 3, 'Premium lifestyle jacket', 130.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Nike Pro Compression', 3, 'Athletic compression wear', 35.00);

INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Adidas Warriors Jersey', 4, 'Official NBA jersey', 110.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Adidas Tiro Track Jacket', 4, 'Soccer training jacket', 50.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Adidas 3-Stripes Shorts', 4, 'Classic training shorts', 30.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Adidas Z.N.E. Hoodie', 4, 'Premium lifestyle hoodie', 90.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Adidas Training Pants', 4, 'Athletic pants', 45.00);

INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Spalding NBA Basketball', 5, 'Official NBA game ball', 160.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Basketball Net', 5, 'Professional replacement net', 15.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Arm Sleeve', 5, 'Compression arm sleeve', 20.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Basketball Backpack', 5, 'Ball carrying backpack', 45.00);
INSERT product(productName, categoryId, productDesc, productPrice) VALUES ('Ball Pump', 5, 'Dual-action ball pump', 25.00);

INSERT INTO warehouse(warehouseName) VALUES ('Main warehouse');
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (1, 1, 50, 100.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (2, 1, 30, 180.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (3, 1, 40, 150.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (4, 1, 45, 110.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (5, 1, 25, 180.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (6, 1, 35, 190.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (7, 1, 40, 100.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (8, 1, 30, 150.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (9, 1, 25, 140.00);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (10, 1, 50, 90.00);

INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Arnold', 'Anderson', 'a.anderson@gmail.com', '204-111-2222', '103 AnyWhere Street', 'Winnipeg', 'MB', 'R3X 45T', 'Canada', 'arnold' , '304Arnold!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Bobby', 'Brown', 'bobby.brown@hotmail.ca', '572-342-8911', '222 Bush Avenue', 'Boston', 'MA', '22222', 'United States', 'bobby' , '304Bobby!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Candace', 'Cole', 'cole@charity.org', '333-444-5555', '333 Central Crescent', 'Chicago', 'IL', '33333', 'United States', 'candace' , '304Candace!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Darren', 'Doe', 'oe@doe.com', '250-807-2222', '444 Dover Lane', 'Kelowna', 'BC', 'V1V 2X9', 'Canada', 'darren' , '304Darren!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Elizabeth', 'Elliott', 'engel@uiowa.edu', '555-666-7777', '555 Everwood Street', 'Iowa City', 'IA', '52241', 'United States', 'beth' , '304Beth!');

-- Order 1 can be shipped as have enough inventory
DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (1, '2019-10-15 10:25:55', 91.70)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 1, 1, 18)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 2, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 10, 1, 31);

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-16 18:00:00', 106.75)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 5, 21.35);

-- Order 3 cannot be shipped as do not have enough inventory for item 7
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (3, '2019-10-15 3:30:22', 140)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 6, 2, 25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 7, 3, 30);

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-17 05:45:11', 327.85)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 3, 4, 10)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 8, 3, 40)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 13, 3, 23.25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 28, 2, 21.05)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 29, 4, 14);

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (5, '2019-10-15 10:25:55', 277.40)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 4, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 19, 2, 81)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 20, 3, 10);

-- New SQL DDL for lab 8
UPDATE Product SET productImageURL = 'img/1.jpg' WHERE ProductId = 1;
UPDATE Product SET productImageURL = 'img/2.jpg' WHERE ProductId = 2;
UPDATE Product SET productImageURL = 'img/3.jpg' WHERE ProductId = 3;
UPDATE Product SET productImageURL = 'img/4.jpg' WHERE ProductId = 4;
UPDATE Product SET productImageURL = 'img/5.jpg' WHERE ProductId = 5;
UPDATE Product SET productImageURL = 'img/6.jpg' WHERE ProductId = 6;
UPDATE Product SET productImageURL = 'img/7.jpg' WHERE ProductId = 7;
UPDATE Product SET productImageURL = 'img/8.jpg' WHERE ProductId = 8;
UPDATE Product SET productImageURL = 'img/9.jpg' WHERE ProductId = 9;
UPDATE Product SET productImageURL = 'img/10.jpg' WHERE ProductId = 10;
UPDATE Product SET productImageURL = 'img/11.jpg' WHERE ProductId = 11;
UPDATE Product SET productImageURL = 'img/12.jpg' WHERE ProductId = 12;
UPDATE Product SET productImageURL = 'img/13.jpg' WHERE ProductId = 13;
UPDATE Product SET productImageURL = 'img/14.jpg' WHERE ProductId = 14;
UPDATE Product SET productImageURL = 'img/15.jpg' WHERE ProductId = 15;
UPDATE Product SET productImageURL = 'img/16.jpg' WHERE ProductId = 16;
UPDATE Product SET productImageURL = 'img/17.jpg' WHERE ProductId = 17;
UPDATE Product SET productImageURL = 'img/18.jpg' WHERE ProductId = 18;
UPDATE Product SET productImageURL = 'img/19.jpg' WHERE ProductId = 19;
UPDATE Product SET productImageURL = 'img/20.jpg' WHERE ProductId = 20;
UPDATE Product SET productImageURL = 'img/21.jpg' WHERE ProductId = 21;
UPDATE Product SET productImageURL = 'img/22.jpg' WHERE ProductId = 22;
UPDATE Product SET productImageURL = 'img/23.jpg' WHERE ProductId = 23;
UPDATE Product SET productImageURL = 'img/24.jpg' WHERE ProductId = 24;
UPDATE Product SET productImageURL = 'img/25.jpg' WHERE ProductId = 25;

--เริ่มจาก Master สร้างฐานข้อมูลชื่อ CSMinimart
Create Database CSMinimart

--ปรับให้ฐานข้อมูลสามารถเพิ่มข้อมูลที่เแ็นภาษาไทยได้
Alter Database CSMinimart Collate Thai_CI_AS;

--เปลี่ยนฐานไปใช้ CSMinimart เปลี่ยนบนเมนู
USE CSMinimart;

--สร้างตารางเก็บข้อมูลพนักงาน ชื่อ Employees
Create Table Employees(
    EmployeeID int identity (1,1) Primary key ,
    title varchar (20) null,
    Firstname varchar (50) not null ,
    lastname varchar (50) null ,
    Position varchar (50) null ,
    username varchar (50) Unique,
    passwordhash varchar (225) not null ,
    IsActive bit Not Null default 1 
);

--ทดสอบเพิ่มตาราง Employees
INSERT INTO Employees
  (Title, FirstName, LastName, Position, UserName, PasswordHash)
VALUES
  ('นางสาว', 'กาญจนา', 'พวงแก้ว', 'Sale Manager', 'user1', 'hashed1');

--เมื่อเพิ่มแล้ว ทดสอบเรียกข้อมูลออกมาดู
Select * from Employees

--ทดสอบเพิ่มข้อมูลรายการใหม่ ใส่ชื่อใหม่
INSERT INTO Employees
  (Title, FirstName, LastName, Position, UserName, PasswordHash)
VALUES
  ('นาย', 'ธีรภัทร', 'จันลา', 'Sale Manager', 'user2', 'hashed2');

--สร้างตารางหมวดหมู่สินค้า Categories
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL,
    Description VARCHAR(200)
);

--เพิ่มข้อมูลในตาราง หมวดหมูสินค้า Categories
insert into Categories (CategoryName,Description)
Values('เครื่องปรุง','น้ำปลา เกลือ น้ำตาล ชูรส')
insert into Categories (CategoryName,Description)
Values('เครื่องดื่มเย็น','โออิชิ เอ็มร้อย ลิโพ โกโก้')
insert into Categories (CategoryName,Description)
Values('อาหารสำเร็จรุป','มาม่า ปลากระป่อง ')
insert into Categories (CategoryName,Description)
Values('เครื่องสำอาง','แป้ง ลิปสติก บรัชออน เมคอัพ')
insert into Categories (CategoryName,Description)
Values('เวซภัณฑ์','พารา ยาแก้ไอ พาสเตอร์ ยาสามัญประจำบ้าน')

--ดูข้มูลในตาราง Categorires
Select * from Categories

--สร้างตารางสินค้า Products
CREATE TABLE Products (
    ProductID VARCHAR(13) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL DEFAULT 0,
    UnitsInStock INT NOT NULL DEFAULT 0,
    CategoryID INT NOT NULL,
    Discontinued BIT NOT NULL DEFAULT 0,

    CONSTRAINT CK_Products_UnitPrice
        CHECK (UnitPrice >= 0),

    CONSTRAINT CK_Products_UnitsInStock
        CHECK (UnitsInStock >= 0),

    CONSTRAINT FK_Products_Categories
        FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID)
);

--ทดสอบเพิ่มข้อมูลในตาราง Products
INSERT INTO Products 
  (ProductID, ProductName, UnitPrice, UnitsInStock, CategoryID, Discontinued)
VALUES ('8858757001948', 'โค้ก', 15.00, 290, 1, 0);

INSERT INTO Products 
  (ProductID, ProductName, UnitPrice, UnitsInStock, CategoryID, Discontinued)
VALUES  ('4901330502315', 'คาลบี้', 25.00, 250, 1, 0);

INSERT INTO Products 
  (ProductID, ProductName, UnitPrice, UnitsInStock, CategoryID, Discontinued)
VALUES  ('4901330755015', 'แจ็กซ์', 45.00, 310, 1, 0);

INSERT INTO Products 
  (ProductID, ProductName, UnitPrice, UnitsInStock, CategoryID, Discontinued)
VALUES  ('8852127960015', 'ปาปริก้า', 15.00, 110, 1, 0);

INSERT INTO Products 
  (ProductID, ProductName, UnitPrice, UnitsInStock, CategoryID, Discontinued)
VALUES  ('8852127977013', 'ทวิสโก้รสชีส', 55.00, 115, 1, 0);

INSERT INTO Products 
  (ProductID, ProductName, UnitPrice, UnitsInStock, CategoryID, Discontinued)
VALUES ('8852127988019', 'คาราด้า', 85.00, 185, 1, 0);

-- เรียกดูข้อมูลเพื่อตรวจสอบ
SELECT * FROM Products;

--สร้างตาราง Receipts
CREATE TABLE Receipts (
    ReceiptID INT IDENTITY(1,1) PRIMARY KEY,
    ReceiptDate DATETIME NOT NULL DEFAULT GETDATE(),
    EmployeeID INT NOT NULL,
    TotalCash DECIMAL(10,2) NOT NULL DEFAULT 0,

    CONSTRAINT CK_Receipts_TotalCash
        CHECK (TotalCash >= 0),

    CONSTRAINT FK_Receipts_Employees
        FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID)
);

--เพิ่มข้อมลูในตารางใบเสร็จ
INSERT INTO Receipts (EmployeeID,TotalCash)
VALUES (1,115.00);

--ดูข้อมูลตารางใบเสร็จ
Select * from Receipts  

--สร้างตาราง Details
CREATE TABLE Details (
    ReceiptID INT NOT NULL,
    ProductID VARCHAR(13) NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    Quantity INT NOT NULL,

    CONSTRAINT PK_Details
        PRIMARY KEY (ReceiptID, ProductID),

    CONSTRAINT CK_Details_UnitPrice
        CHECK (UnitPrice >= 0),

    CONSTRAINT CK_Details_Quantity
        CHECK (Quantity > 0),

    CONSTRAINT FK_Details_Receipts
        FOREIGN KEY (ReceiptID)
        REFERENCES Receipts(ReceiptID),

    CONSTRAINT FK_Details_Products
        FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID)
);

---เพิ่มข้อมูล ตาราง Details (แก้ไขให้ตรงตามโครงสร้างตาราง Details)
INSERT INTO Details (ReceiptID, ProductID, UnitPrice, Quantity)
VALUES (1, '8858757001948', 15.00, 1);
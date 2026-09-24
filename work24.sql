--สำรวจขื้อมูล Receipts, details, Employees, Products

SELECT * FROM Receipts
SELECT * FROM Details
SELECT * FROM Employees
SELECT * FROM Products
-- เป้าหมาย ต้องการสร้างรายการจำหน่ายสินค้า ผู้ขายคือ วุฒิศักดิ์ 
-- สินค้าที่ขาย ได้แก่ ดินสอ  5 แท่ง และ ยางลบ 4 ก้อน
-- เริ่มต้น Trancaction
Begin transaction

SET IDENTITY_INSERT Receipts ON;
GO

-- เพิ่มหัวใบเสร็จ (ระบุเลข 6 ตามโจทย์ของอาจารย์ได้เลย)
INSERT INTO Receipts (ReceiptID, EmployeeID, ReceiptDate, TotalCash)
VALUES (6, 4, GETDATE(), 0);

-- ปิดสิทธิ์ (ทำทุกครั้งหลัง Insert เสร็จเพื่อความปลอดภัยของฐานข้อมูล)
SET IDENTITY_INSERT Receipts OFF;
GO
-- 2. เพิ่มรายการสินค้า Details 2 รายการ
insert into Details (ReceiptID, ProductID, Quantity, UnitPrice)
Values(6,1,17,5) -- ดินสอ
insert into Details (ReceiptID, ProductID, Quantity, UnitPrice)
Values(6,2,4,20) -- ยางลบ
-- 3. ปรับปรุงยอด TotalCash
Update Receipts set TotalCash = 
    (select sum(Quantity * UnitPrice) from Details 
    where ReceiptID = 6)
where ReceiptID = 6
-- 4. ปรับปรุงจำนวนสินค้า ดินสอ -5 ยางลบ -4
Update Products set UnitsInStock = UnitsInStock - 5 where ProductID = 1 -- ดินสอ
Update Products set UnitsInStock = UnitsInStock - 4 where ProductID = 2 -- ยางลบ
-- จบการทำงาน 
commit

------------------------------------------------------------------------------------

-- ทดสอบ Roll back ------------------
-- เริ่มต้น Transaction
BEGIN TRANSACTION
-- 1. เพิ่มใบเสร็จใหม่ Receipts ยังไม่มียอก TotalCash
-- 1. เพิ่มหัวใบเสร็จลงในตาราง Receipts (ตารางหัวบิลเก็บข้อมูลใบเสร็จ)
INSERT INTO Receipts (ReceiptID, EmployeeID, ReceiptDate, TotalCash)
VALUES (8, 4, GETDATE(), 0);

-- 2. เพิ่มรายการสินค้าลงในตาราง Details (แก้คำว่า VALUE เป็น VALUES ให้เรียบร้อย)
INSERT INTO Details (ReceiptID, ProductID, UnitPrice, Quantity)
VALUES (8, 1, 17, 5); -- ดินสอ

INSERT INTO Details (ReceiptID, ProductID, UnitPrice, Quantity)
VALUES (8, 2, 17, 4); -- ยางลบ

    --   ตรวจสอบดูข้อมูลที่เกิดขึ้น
    SELECT * FROM Receipts WHERE ReceiptID = 8
    SELECT * FROM Details WHERE ReceiptID = 8
-- หากระบบผิดพลาด เราจะ Roback
    ROLLBACK
    -- ตรวจสอบดูข้อมูลว่ายังอยุ่หรือไม่
    SELECT * FROM Receipts WHERE ReceiptID = 8
    SELECT * FROM Details WHERE ReceiptID = 8




------Nortwind---------




BEGIN TRANSACTION

INSERT INTO Orders
(CustomerID, EmployeeID, OrderDate, RequiredDate, Freight)
VALUES
('ALFKI', 1, GETDATE(), DATEADD(DAY, 7, GETDATE()), 50.00);

-- ดู OrderID ที่เพิ่งสร้าง
SELECT SCOPE_IDENTITY() AS NewOrderID;

-- เพิ่มสินค้าใน Order
-- เพิ่มรายการสินค้า Product 1
INSERT INTO [Order Details]
(OrderID, ProductID, UnitPrice, Quantity, Discount)
SELECT
11078, ProductID, UnitPrice, 2, 0
FROM Products
WHERE ProductID = 1;

-- เพิ่มรายการสินค้า Product 2 (ใช้คำสั่งลักษณะเดียวกัน แต่เปลี่ยน ProductID = 2 และ Quantity = 3)
INSERT INTO [Order Details]
(OrderID, ProductID, UnitPrice, Quantity, Discount)
SELECT
11078, ProductID, UnitPrice, 3, 0
FROM Products
WHERE ProductID = 2;

-- ตรวจสอบข้อมูลก่อน COMMIT
SELECT * 
FROM Orders 
WHERE OrderID = 11078;

SELECT * 
FROM [Order Details] 
WHERE OrderID = 11078;

-- COMMIT และตรวจสอบผล
COMMIT;

SELECT * 
FROM Orders 
WHERE OrderID = 11078;







-- เริ่ม Transaction ใหม่
BEGIN TRANSACTION;

INSERT INTO Orders
(CustomerID, EmployeeID, OrderDate, RequiredDate, Freight)
VALUES
('ALFKI', 1, GETDATE(), DATEADD(DAY, 7, GETDATE()), 75.00);

-- จด OrderID ของ Transaction
SELECT SCOPE_IDENTITY() AS RollbackOrderID;

-- เพิ่มสินค้า Product 1
INSERT INTO [Order Details]
(OrderID, ProductID, UnitPrice, Quantity, Discount)
SELECT
11079, ProductID, UnitPrice, 1, 0
FROM Products
WHERE ProductID = 1;

-- เพิ่มสินค้า Product 2
INSERT INTO [Order Details]
(OrderID, ProductID, UnitPrice, Quantity, Discount)
SELECT
11079, ProductID, UnitPrice, 2, 0
FROM Products
WHERE ProductID = 2;

-- ตรวจสอบข้อมูลก่อน ROLLBACK
SELECT * 
FROM Orders 
WHERE OrderID = 11079;

SELECT * 
FROM [Order Details] 
WHERE OrderID = 11079;

-- ROLLBACK Transaction
ROLLBACK;

-- ตรวจสอบผลหลัง ROLLBACK
SELECT * 
FROM Orders 
WHERE OrderID = 11079;

SELECT * 
FROM [Order Details] 
WHERE OrderID = 11079;
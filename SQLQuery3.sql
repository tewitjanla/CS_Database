--Lab ในชั้นเรียนวันที่  6 สิงหาคม 2569
--ใช้ ฐานข้อมูล Northwind เพื่อ Query ข้อมูลต่อไปนี้
--1.ต้องการ คำนำหน้า ชื่อ นามสกุล พนักงาน ที่อยู่ในเมือง London 
SELECT TitleOfCourtesy, FirstName, LastName
FROM Employees
WHERE City = 'London';
--2.ข้อมูล รหัสสินค้า ชื่อสินค้า ราคา จำนวน ของสินค้าที่มีจำนวนน้อยกว่า 30
SELECT ProductID, ProductName, UnitPrice, UnitsInStock
FROM Products
WHERE UnitsInStock < 30;

--3.รหัสลูกค้า ชื่อบริษัท เบอร์โทรศัพท์ ของลูกค้าที่อยู่ในประเทศต่อไปนี้ 
--    Sweden, Germany, France, Spain, UK
SELECT CustomerID, CompanyName, Phone
FROM Customers
WHERE Country IN ('Sweden', 'Germany', 'France', 'Spain', 'UK');
--4.ข้อมูลลูกค้าที่ไม่มีหมายเลขโทรสาร (Fax) 
SELECT *
FROM Customers
WHERE Fax IS NULL;
--5.ข้อมูลสินค้าที่มีจำนวนสินค้าต่ำกว่าจุดสั่งซื้อ และ มีจำนวนที่สั่งซื้อแล้ว 
SELECT *
FROM Products
WHERE UnitsInStock < ReorderLevel AND UnitsOnOrder > 0;
--6.ชื่อ นามสกุล พนักงานที่เข้าทำงานในปี 1992 
SELECT FirstName, LastName
FROM Employees
WHERE YEAR(HireDate) = 1992;
--7.ต้องการข้อมูลสินค้าที่มีราคาตั้งแต่ 20-70
SELECT *
FROM Products
WHERE UnitPrice BETWEEN 20 AND 70;

--8.ข้อมูลลูกค้าที่มีชื่อบริษัทขึ้นต้นด้วย S และอยู่ประเทศ Mexico
SELECT *
FROM Customers
WHERE CompanyName LIKE 'S%' AND Country = 'Mexico';

-- 9. ข้อมูลที่มีตำแหน่งของผู้ที่ประสานงานเป็น Manager
select * from Customers
where ContactTitle like '%Manager%';

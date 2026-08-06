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
 
 --Aggregate Funtion (หรือเรียกว่า Group FUntion)
 --เป็น Funtion ที่คำนวณมาจากข้อมูลหลายแถว
select top (5) * from products

select Count(*) as จำนวนชนิด,Max(UnitPrice) as ราคาสูงสุด,
Min(UnitPrice) as ราคาต่ำสุด,Avg(UnitPrice) as ราคาเฉลี่ย,Sum(UnitsInStock) as ราคารวมทั้งหมด
from Products

--ต้องการทราบว่าสินค้าแต่ละหมวดหมู่(CategoryID) มีสินค้ากี่ชนิด แต่ละชนิดมีราคาเฉลี่ย มีราคาสูงสุด และต่ำสุด
select  CategoryID ,Count(*) จำนวนชนิด ,Avg(UnitPrice) ราคาเฉลี่ย, Max(UnitPrice) ราาคาสูงสุด , Min(UnitPrice)  ราคาต่ำสุด
from products
Group by CategoryID

--ต้องการทราบว่าข้อมูลในแต่ละประเทศ (Country) มีลูกค้าอยู่กี่ราย
select Country, City, Count(*) จำนวนลูกค้า
from Customers
group by Country ,City
order by Country asc ,count(*) desc
--	order by Count(*) desc
--	order by Count(*) desc

--ต้องการทราบว่าข้อมูลในแต่ละประเทศ (Country) แสดงเฉพาะที่มีลูกค้า 10 รายขึ้นไป
select Country, Count(*) จำนวนลูกค้า
from Customers
group by Country
having count(*) >= 10

--ต้องการทราบว่าสินค้าที่มีมูลค้าสูง (ราคาตั่งแต่ 75 ขึ้นไป) แต่ละหมวดหมู่มีจำนวนกี่ชนิด มีราคาเฉลี่ยเท่าใด
--ให้แสดงเฉพาะสินค้าที่มีราคาเฉลี่ย มากกว่า 200
select categoryID, count(*)  จำนวนชนิด ,avg(UnitPrice) ราาคเฉลี่ย
from Products
where UnitPrice >=75
group by  CategoryID
having avg(unitprice) > 200

--จากตาราง [Order Details] ให้รวบรวมว่าในแต่ละการสั่งซื้อ มียอดรวมเท่าใด
select orderID, UnitPrice, Quantity,Discount,
	   UnitPrice * Quantity as ราคาเต็ม,
	   UnitPrice * Quantity * Discount as ส่วนลด,
	   (UnitPrice * Quantity) - (UnitPrice * Quantity * Discount) ราคาหักส่วนลดแล้ว,
	   (UnitPrice * Quantity * (1 - Discount)) as หักส่วนลดสูตรย่อ
from [Order Details]

select orderID, count(*) จำนวนรายการ,
	   sum((UnitPrice * Quantity * (1 - Discount))) as total
from [Order Details]
group by orderID
having  sum((UnitPrice * Quantity * (1 - Discount))) > 2000
order by 3 desc
--order by sum((UnitPrice * Quantity * (1 - Discount))) desc

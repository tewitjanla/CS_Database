-- กำหนดข้อมูลที่จะนำมาแสดงผล
SELECT 
    c.CompanyName AS [ชื่อลูกค้า], -- ดึงชื่อบริษัทลูกค้ามาแสดง
    SUM(od.Quantity) AS [จำนวนชิ้นรวม], -- หาผลรวมจำนวนชิ้นของสินค้าที่ซื้อ
    SUM(od.Quantity * (od.UnitPrice * (1 - od.Discount))) AS [ยอดรวมสุทธิ] -- คำนวณยอดขายรวมหลังหักส่วนลด
    
-- กำหนดตารางหลักที่ใช้ดึงข้อมูล (ตั้งชื่อย่อให้ตารางเพื่อความสะดวก)
FROM Customers c -- ตารางข้อมูลลูกค้า (ย่อเป็น c)

-- เชื่อมตารางต่างๆ เข้าด้วยกันด้วยรหัสที่ตรงกัน (Primary Key = Foreign Key)
JOIN Orders o ON c.CustomerID = o.CustomerID -- เชื่อมตารางใบสั่งซื้อ เพื่อดึงข้อมูลประเทศที่จัดส่ง
JOIN [Order Details] od ON o.OrderID = od.OrderID -- เชื่อมตารางรายละเอียดคำสั่งซื้อ เพื่อดึงจำนวน ราคา และส่วนลด
JOIN Products p ON od.ProductID = p.ProductID -- เชื่อมตารางสินค้า เพื่อดึงรหัสหมวดหมู่สินค้า
JOIN Categories cat ON p.CategoryID = cat.CategoryID -- เชื่อมตารางหมวดหมู่สินค้า เพื่อดึงชื่อหมวดหมู่

-- กรองข้อมูลตามเงื่อนไขที่ต้องการ
WHERE cat.CategoryName = 'Seafood' -- เงื่อนไขที่ 1: เอาเฉพาะสินค้าในหมวด 'Seafood' (อาหารทะเล)
  AND o.ShipCountry = 'USA' -- เงื่อนไขที่ 2: เอาเฉพาะรายการที่ส่งไปยังประเทศ 'USA'

-- จัดกลุ่มข้อมูลเพื่อให้ฟังก์ชัน SUM() ทำงานได้ถูกต้อง
GROUP BY 
    c.CustomerID, -- จัดกลุ่มตามรหัสลูกค้า (ป้องกันกรณีชื่อลูกค้าซ้ำกัน)
    c.CompanyName -- จัดกลุ่มตามชื่อลูกค้า เพื่อนำไปแสดงผลในบรรทัด SELECT

-- จัดเรียงลำดับผลลัพธ์ที่แสดงออกมา
ORDER BY 
    [ยอดรวมสุทธิ] DESC; -- เรียงลำดับจากลูกค้าที่มียอดซื้อสูงที่สุดไปหาต่ำที่สุด (DESC = Descending)


-- 1. เลือกคอลัมน์และคำนวณข้อมูลที่ต้องการแสดงผล
SELECT 
    e.TitleOfCourtesy AS [คำนำหน้าชื่อ], -- คำนำหน้าชื่อพนักงานใน Northwind ใช้ TitleOfCourtesy
    e.EmployeeID AS [รหัสพนักงาน], -- รหัสพนักงาน
    e.FirstName + ' ' + e.LastName AS [ชื่อพนักงาน], -- รวมชื่อจริงและนามสกุลเข้าด้วยกัน
    e.Title AS [ตำแหน่ง], -- ตำแหน่งงานของพนักงาน
    p.ProductName AS [รายการสินค้าที่เกี่ยวข้อง], -- ชื่อสินค้าที่พนักงานขายได้
    
    -- คำนวณยอดขายรวม (จำนวนชิ้น x ราคา x ส่วนลด) แล้วคูณ 0.05 เพื่อหาค่าคอมมิชชั่น 5%
    SUM(od.Quantity * (od.UnitPrice * (1 - od.Discount))) * 0.05 AS [ค่าคอมมิชชั่น 5%]

-- 2. กำหนดตารางหลักเริ่มต้น
FROM Employees e -- ตารางพนักงาน (ตั้งชื่อย่อว่า e)

-- 3. เชื่อมโยงความสัมพันธ์ข้ามตาราง (JOIN)
JOIN Orders o ON e.EmployeeID = o.EmployeeID 
    -- เชื่อมพนักงานกับคำสั่งซื้อ (Orders) เพื่อดูว่าพนักงานคนนี้ขายออร์เดอร์ไหนบ้าง
JOIN [Order Details] od ON o.OrderID = od.OrderID 
    -- เชื่อมคำสั่งซื้อกับรายละเอียดสินค้าในบิล (ชื่อตารางมีเว้นวรรคต้องใส่ [ ] ครอบ)
JOIN Products p ON od.ProductID = p.ProductID 
    -- เชื่อมรายละเอียดสินค้ากับตารางสินค้า เพื่อดึงชื่อสินค้า (ProductName) มาแสดง

-- 4. จัดกลุ่มข้อมูลเพื่อใช้ฟังก์ชัน SUM()
GROUP BY 
    e.TitleOfCourtesy,
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.Title,
    p.ProductName -- จัดกลุ่มตามพนักงานและชื่อสินค้าแต่ละตัว

-- 5. เรียงลำดับผลลัพธ์
ORDER BY 
    [ค่าคอมมิชชั่น 5%] DESC; -- เรียงจากคนที่ได้ค่าคอมมิชชั่นสูงสุดลงมา
--ORDER BY 
--  [ค่าคอมมิชชั่น 5%] ASC; -- เปลี่ยนจาก DESC เป็น ASC เพื่อเรียงจากน้อยไปมาก (ต่ำสุดขึ้นก่อน)

SELECT 
    e.EmployeeID AS [รหัสพนักงาน],
    -- บังคับให้แสดงผลเป็นทศนิยม 2 ตำแหน่ง
    CAST(SUM(od.Quantity * (od.UnitPrice * (1 - od.Discount))) * 0.05 AS DECIMAL(10,2)) AS [ค่าคอมมิชชั่น 2 ตำแหน่ง]
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID;

SELECT 
    e.EmployeeID AS [รหัสพนักงาน],
    -- ปัดเศษตัวเลขให้เหลือ 2 ตำแหน่ง
    ROUND(SUM(od.Quantity * (od.UnitPrice * (1 - od.Discount))) * 0.05, 2) AS [ยอดรวมปัดเศษ]
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID;




----------tao
--จงแสดงข้อมูลทั้งหมดที่อยู่ในตาราง Customers
select * from Customers

--จงแสดงเฉพาะ CustomerID และ CompanyName จากตาราง Customers
select CustomerID, CompanyName
From Customers

--จงแสดง CustomerID และ CompanyName ของลูกค้าที่อยู่ประเทศ USA
select CustomerID, CompanyName
From Customers
where country = 'usa'


--จงแสดง CustomerID และ CompanyName ของลูกค้าทั้งหมด โดยเรียง ตามตัว A - Z
select CustomerID, CompanyName
From Customers
order by CustomerID desc --มากไปน้อย

select CustomerID, CompanyName
From Customers
order by CustomerID asc --น้อยไปมาก

select * from Customers

--จงแสดง ProductName และ Unitprice จากตาราง Products โดยเรียงสินค้าตาม ราคาแพงสุดไปถูกที่สุด
--order by คือ ตัวแปรที่เราสั่งให้เป็นไปตามที่ต้องการ
select ProductName, Unitprice
from Products
order by UnitPrice desc

--ให้แสดงข้อมูล CustomerID และ CompanyName ของลูกค้าทั้งหมดที่อยู๋ในประเทศ usa และเรียงข้อมูล Companyname A - Z
select CustomerID, CompanyName 
from Customers
where Country = 'usa' order by CompanyName asc

--ให้แสดงข้อมูล CustomerID CompanyName และ Country ของลูกค้าาประเทศ Germany โดยเรียง CustomerID จากน้อยไปมาก
select CustomerID, CompanyName, Country
from Customers
where Country = 'germany' order by CustomerID asc

--ให้แสดง CompanyName และ ContactName ของ ลูกค้าทั้งหมดที่อยู่ในประเทศ France เรียงตาม CompanyName จาก Z - A
select  CompanyName, ContactName
from Customers
where Country = 'france' order by CompanyName desc

--เอา CustomerID กับ CompanyName ที่ Country = UK เรียง CustomerID มากไปน้อย
select  CustomerID, CompanyName
from Customers
where Country = 'UK' order by CustomerID desc

-- แสดง CustomerID CompanyName และ Country ของลูกค้าที่อยู่ใน usa, germany
-- อยู่ในประเทศตาม Conntry จาก A - Z ถ้าประเทศเดียวกัน ให้เรียง CompanyName จาก A-Z
select CustomerID, CompanyName, Country
from Customers
where Country = 'usa' or Country = 'germany' --ถ้ามี 2 ประเภท ให้ใช้ or แล้วมันก็คนละตัวแปรกันด้วย
order by Country asc,  CompanyName asc

-- ให้แสดง CustomerID, CompanyName, Country โดยเลือกเฉพาะลูกค้า ที่อยู่ USA หรือ Germany และ 
-- CompanyName ขึ้นต้นด้วย A เรียง CompanyName จาก A - Z
select CustomerID, CompanyName, Country
from Customers
where Country = 'usa' or Country = 'germany'
or companyName like 'A%' --ถ้า % อยู่หลัง ตัวอักษรตัวนั้นต้องอยู่ด้านหน้า
order by CompanyName asc

--แสดง CustomerID, CompanyName, Country
-- เงื่อนไข Country ต้องเป็น usa หรือ germany
-- เรียงตาม Country A - Z
-- ถ้าประเทศเดียวกันให้เรียง CompanyName A - Z
select  CustomerID, CompanyName, Country
from Customers
where Country = 'usa' or Country = 'germany'
order by Country asc , companyName asc

-- แสดง CustomerID CompanyName Country อยู่ใน USA และ CompanyName ขึ้นต้นด้วย A ลงท้าย S เรียง CompanyName A-Z
select CustomerID, CompanyName, Country
from Customers
where Country = 'usa' 
or companyName like 'A%' and companyName like'%S'
order by CompanyName asc

--หาชื่อแค่ตัวเดียว
select CompanyName , country
from Customers
where  country = 'mexico' and companyName like 'A%' and companyName like'%S'
order by CompanyName asc

-- ให้แสดง CustomerID CompanyName Country
-- Country USA หรือ UK
-- CompanyName ขึ้นต้น A  หรือ B
-- CompanyName ต้องมีอักษร S
-- เรียง Country A-Z แล้วค่อย เรียง CompnayName Z-A
select CustomerID, CompanyName, Country
from Customers
where Country = 'usa' or Country = 'uk'
and CompanyName like 'A%' or CompanyName like 'B%'
and CompanyName like '%s%' --ถ้าจะให้มีตัว s	อยู่ในระหว่างชื่อนั้น ให้ใส่ % หน้า หลัง
order by Country asc, CompanyName desc

-- แสดง CustomerID CompanyName OrderID OrderDate ProductName CategoryName
-- ลูกค้าอยู่ใน USA หรือ UK
-- CompanyName ขึ้นต้นด้วย A หรือ B
--CompanyName ต้องมี s ในชื่อ
-- สินค้าที่สั่งต้องมี ราคา มากกว่า 20
-- เรียงข้อมูล Country A-Z CompanyName A-Z  order Date ใหม่ - เก่า

select c.customerID,c.CompanyName,o.OrderID,o.OrderDate,p.ProductName,ca.CategoryName
From Customers 
as c join orders as o on c.CustomerID = o.CustomerID
join [order details] as od on o.orderid = od.orderid
join products as p on od.productid = p.productid
join categories as ca on p.categoryID = ca.categoryID
where c.country = 'usa' and c.country = 'uk'
and c.companyname like 'A%' or c.companyname like 'B%' and c.CompanyName like '%s%' and od.UnitPrice > 20
order by c.Country asc , c.CompanyName asc , o.OrderDate desc

--ให้แสดง ProductID, ProductName และ UnitPrice
--เฉพาะสินค้าที่มีราคา ตั้งแต่ 20 ถึง 50
--แล้วเรียง UnitPrice จาก น้อย → มาก
select productID, ProductName, Unitprice
from Products
where UnitPrice between 20 and 50
order by UnitPrice asc


--ให้แสดง ProductID, ProductName และ UnitPrice
--เฉพาะสินค้าที่ ชื่อสินค้าเริ่มต้นด้วยตัวอักษร C
--แล้วเรียง ProductName จาก A → Z

select PRODUCTID, PRODUCTname, unitprice
from Products
where ProductName like 'C%'
order by ProductName asc 

--ให้หาว่าในตาราง Products มี สินค้าทั้งหมดกี่รายการ
select count (*) Productcount
from Products

--ห้หาว่า ราคาสินค้าเฉลี่ย (UnitPrice) ของสินค้าทั้งหมดคือเท่าไร
--และตั้งชื่อคอลัมน์ผลลัพธ์ว่า AveragePrice

select Avg(Unitprice) AveragePrice
from Products

--ให้หาว่า ราคาสินค้ารวมทั้งหมด (UnitPrice) เป็นเท่าไร
--และตั้งชื่อผลลัพธ์ว่า TotalPrice

select sum(unitprice) TotalPrice
from Products 

--ให้แสดง CategoryID และ จำนวนสินค้าในแต่ละ Category
--โดยตั้งชื่อจำนวนสินค้าว่า ProductCount

select * from Categories

SELECT CategoryID, COUNT(*) AS ProductCount
FROM Products
GROUP BY CategoryID;


--ให้แสดง CategoryID และ ราคาเฉลี่ยของสินค้าในแต่ละ Category
--โดยตั้งชื่อราคาเฉลี่ยว่า AveragePrice 
select categoryID ,avg(unitprice) AveragePrice
from Products
group by CategoryID

--ให้แสดง CategoryID และ จำนวนสินค้าในแต่ละ Category
--โดยเรียงจาก Category ที่มีสินค้ามากที่สุด → น้อยที่สุด

select CategoryID , count(*) ProductCount
from products
group by CategoryID
order by ProductCount desc


--ให้แสดง CategoryID และ ราคาเฉลี่ยของสินค้าในแต่ละ Category
--เฉพาะ Category ที่มี ราคาเฉลี่ยมากกว่า 30
--แล้วเรียงจากราคาเฉลี่ย มาก → น้อย

select CategoryID , AVG(Unitprice) Category
From Products
group by CategoryID
having avg(unitprice) > 30
Order by avg(unitprice) desc

--แสดง CategoryID และ ผลรวม UnitPrice ของแต่ละ Category
--เอาเฉพาะ Category ที่ผลรวม UnitPrice มากกว่า 500
--แล้วเรียงจากผลรวม มาก → น้อย

select CategoryID , Sum(Unitprice) ผลรวม , Count(*) จำนวน
From Products
group by CategoryID
having sum(UnitPrice) > 100
order by sum(unitprice) desc

--ให้แสดง EmployeeID และ จำนวน Order ของพนักงานแต่ละคน
--เอาเฉพาะพนักงานที่มีจำนวน Order มากกว่า 10 รายการ
--แล้วเรียงจากจำนวน Order มาก → น้อย

SELECT EmployeeID, COUNT(*) AS OrderCount
FROM Orders
GROUP BY EmployeeID
HAVING COUNT(*) > 10
ORDER BY OrderCount DESC;


ให้แสดงข้อมูลต่อไปนี้:
--CustomerID
--CompanyName
--OrderID
--OrderDate
--EmployeeID
--FirstName และ LastName ของพนักงานที่รับผิดชอบ Order
--เฉพาะ Order ที่ลูกค้าอยู่ประเทศ USA
--CompanyName A → Z
--OrderDate ใหม่ → เก่า
Select c.CustomerID , c.CompanyName, o.OrderID, o.OrderDate, o.EmployeeID ,e.FirstName, e.LastName
From Customers c inner join orders o on c.CustomerID = o.CustomerID
inner join Employees E on o.EmployeeID = e.EmployeeID
where c.country = 'usa'
order by c.CompanyName asc , o.OrderDate desc



SELECT C.CustomerID,
       C.CompanyName,
       O.OrderID,
       O.OrderDate,
       O.EmployeeID,
       E.FirstName,
       E.LastName
FROM Customers C
JOIN Orders O
    ON C.CustomerID = O.CustomerID
JOIN Employees E
    ON O.EmployeeID = E.EmployeeID
WHERE C.Country = 'USA'
ORDER BY C.CompanyName ASC,
         O.OrderDate DESC;
/*
ข้อ 29 — JOIN + WHERE + ORDER BY

ให้แสดงข้อมูลต่อไปนี้
- CompanyName
- OrderID
- OrderDate
- FirstName
- LastName

โดยใช้ตาราง Customers, Orders และ Employees

เงื่อนไข:
1. แสดงเฉพาะลูกค้าที่อยู่ประเทศ Germany
2. เรียง OrderDate จากใหม่ → เก่า
3. ถ้าวันที่เดียวกัน ให้เรียง CompanyName จาก A → Z
*/

select CompanyName, OrderID, Orderdate, FirstName, LastName , c.Country
from Customers c inner join orders o on c.CustomerID = o.CustomerID
inner join Employees e on o.EmployeeID = e.EmployeeID
where c.Country = 'Germany'
order by OrderDate desc , CompanyName asc

/*
ข้อ 30 — JOIN + WHERE + ORDER BY

ให้แสดงข้อมูลต่อไปนี้

- CustomerID
- CompanyName
- OrderID
- OrderDate
- FirstName
- LastName

โดยใช้ตาราง Customers, Orders และ Employees

เงื่อนไข:
1. แสดงเฉพาะลูกค้าที่อยู่ประเทศ USA
2. เรียง CompanyName จาก A → Z
3. ถ้า CompanyName เดียวกัน ให้เรียง OrderDate จากใหม่ → เก่า
*/

select C.CustomerID, c.CompanyName, o.OrderID, o.OrderDate, e.FirstName, e.LastName
from Customers c inner join orders o on c.CustomerID = o.CustomerID
inner join Employees e on o.EmployeeID = e.EmployeeID
where C.Country = 'usa'
order by c.CompanyName asc , o.OrderDate desc

 /*
ข้อ 31 — JOIN + WHERE + GROUP BY + HAVING + ORDER BY

ให้แสดงข้อมูลต่อไปนี้

- EmployeeID
- FirstName
- LastName
- จำนวน Order ที่พนักงานแต่ละคนรับผิดชอบ
- ค่าเฉลี่ยของ OrderID

โดยใช้ตาราง Employees และ Orders

เงื่อนไข:
1. แสดงเฉพาะพนักงานที่รับ Order มากกว่า 10 รายการ
2. แสดงเฉพาะ Order ที่มี CustomerID ไม่เป็น NULL
3. เรียงจำนวน Order จากมาก → น้อย
4. ถ้าจำนวน Order เท่ากัน ให้เรียง LastName จาก A → Z
*/

select e.EmployeeID , e.FirstName, e.LastName, Count(*) CountOrder , Avg(o.OrderID) AVGorderID
from Employees e inner join orders o on e.EmployeeID = o.EmployeeID
where o.CustomerID is not null
group by e.EmployeeID , e.FirstName , e.LastName
having count(*) > 10
order by count(*) desc , e.lastname asc

/*
ข้อ 32 — JOIN + WHERE + GROUP BY + HAVING + SUM + AVG + COUNT + ORDER BY

ให้แสดงข้อมูลต่อไปนี้

- CategoryID
- CategoryName
- จำนวนสินค้า
- ราคาสินค้ารวมทั้งหมด
- ราคาเฉลี่ยของสินค้า

โดยใช้ตาราง Products และ Categories

เงื่อนไข:
1. แสดงเฉพาะสินค้าที่มี UnitPrice มากกว่า 10
2. แสดงเฉพาะ Category ที่มีสินค้ามากกว่า 5 รายการ
3. เรียงราคาสินค้ารวมจากมาก → น้อย
4. ถ้าราคารวมเท่ากัน ให้เรียง CategoryName จาก A → Z
*/

select c.CategoryID, c.CategoryName, Count (*) CountUnitPrice , sum(p.unitprice) , avg(p.unitprice)
from categories c inner join products p on c.categoryID = p.categoryID
where p.unitprice > 10
group by c.CategoryID , c.CategoryName
having count(*) > 5
order by sum(p.UnitPrice) desc , c.CategoryName asc


/*
ข้อ 33 — JOIN ระดับโหด

ให้แสดงข้อมูลต่อไปนี้

- EmployeeID
- FirstName
- LastName
- จำนวน Order ที่พนักงานรับผิดชอบ
- จำนวนลูกค้าที่พนักงานดูแล
- ค่าเฉลี่ยของ Freight
- ค่า Freight รวมทั้งหมด

โดยใช้ตาราง Employees, Orders และ Customers

เงื่อนไข:
1. แสดงเฉพาะ Order ที่ Freight มากกว่า 50
2. แสดงเฉพาะพนักงานที่รับผิดชอบ Order มากกว่า 5 รายการ
3. เรียงค่า Freight รวมจากมาก → น้อย
4. ถ้าค่า Freight รวมเท่ากัน ให้เรียง LastName จาก A → Z
*/

SELECT E.EmployeeID,
       E.FirstName,
       E.LastName,
       COUNT(O.OrderID) AS OrderCount,
       COUNT(DISTINCT O.CustomerID) AS CustomerCount,
       AVG(O.Freight) AS AverageFreight,
       SUM(O.Freight) AS TotalFreight
FROM Employees E
INNER JOIN Orders O
    ON E.EmployeeID = O.EmployeeID
INNER JOIN Customers C
    ON O.CustomerID = C.CustomerID
WHERE O.Freight > 50
GROUP BY E.EmployeeID,
         E.FirstName,
         E.LastName
HAVING COUNT(O.OrderID) > 5
ORDER BY SUM(O.Freight) DESC,
         E.LastName ASC; 



select * from [Order Details]
select * from orders
select * from Products
select * from Categories
select * from Employees
select * from Customers
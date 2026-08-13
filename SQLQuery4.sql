--1. ต้องการข้อมูล รหัสใบสั่งซื้อ ยอดรวมที่หักส่วนลดแล้ว จากแต่ละใบสั่งซื้อ ทั้งหมด เรียงลำดับตามยอดเงิน จากมากไปน้อย
SELECT 
    OrderID AS รหัสใบสั่งซื้อ,
    SUM(UnitPrice * Quantity * (1 - Discount)) AS ยอดรวมหลังหักส่วนลดแล้ว
FROM [Order Details]
GROUP BY OrderID
ORDER BY ยอดรวมหลังหักส่วนลดแล้ว DESC;
--2. ต้องการ ชื่อประเทศ ของผู็แทนจำหน่าย (suppliers) แต่ลพผู้อทนจำหน่ายในแต่ละประเทศ
--	 แสดงมาเฉพาะรายการที่ผู้อทนจำหน่ายมีมากกว่า 1 ราย
SELECT 
    Country AS ชื่อประเทศ,
    COUNT(*) AS จำนวนผู้แทนจำหน่าย
FROM Suppliers
GROUP BY Country
HAVING COUNT(*) > 1;

--3. รหัสสิ้นค้า จำนวนรวมทั้งหมดที่ขายได้ ราคาสูงสุดที่ขายได้ ราคาต่ำสุดที่ขายได้
--	 แสดงเฉพาะสินค้าที่ขายได้รวมมากกว่า 1500 ชิ้น
SELECT 
    ProductID AS รหัสสินค้า,
    SUM(Quantity) AS จำนวนรวมที่ขายได้,
    MAX(UnitPrice) AS ราคาสูงสุด,
    MIN(UnitPrice) AS ราคาต่ำสุด
FROM [Order Details]
GROUP BY ProductID
HAVING SUM(Quantity) > 1500;

--เพิ่มเติมข้อ 3 ต้องการเฉพาะ จำนวนสิ้นค้าที่ไม่มีรายการส่วนลด

SELECT 
    ProductID AS รหัสสินค้า,
    SUM(Quantity) AS จำนวนรวมที่ขายได้,
    MAX(UnitPrice) AS ราคาสูงสุด,
    MIN(UnitPrice) AS ราคาต่ำสุด
FROM [Order Details]
WHERE Discount > 0
GROUP BY ProductID
HAVING SUM(Quantity) > 500;

-- การ Query ข้อมูล จากหลายตาราง ( Join Table)
select * from products Inner join Categories on products.categoryID = Categories.CategoryID

--ตัวอย่าง ต้องการชื่อหมวดหมุ่สินค้า รหัสสินค้า ชื่อสินค้า ราคา 
--      โดยเรียงลำกับตามหมวกหมู่สินค้า และราคาสูงไปต่ำ

select products.categoryID,CategoryName,ProductID,ProductName,UnitPrice
from products Inner join Categories 
     on products.categoryId = Categories.CategoryID
order by CategoryID asc ,Unitprice desc

select p.categoryID,CategoryName,ProductID,ProductName,UnitPrice
from products  p Inner join Categories  c
     on p.categoryId = c.CategoryID
order by CategoryID asc ,Unitprice desc

--ต้องการชื่อผู้รับผิดชอบการสั่งซื้อแต่ละรายการ
select * from orders
select * from Employees
--ต้องการ รหัสใบสั่งซื้อ วันที่สั่งซื้อ วันที่รับสินค้า ประเทศปลายทาง ชื่อ-นามสกุลพนักงานผู้รับผิดชอบ
select  o.OrderID, 
        format(o.OrderDate,'d','en-gb') as[order date],
        format(o.ShippedDate,'d','en-gb') as[shipped date],
        o.ShipCountry,
        e.FirstName + space(2) + e.LastName SaleMan
from orders o inner join Employees e on o.EmployeeID = e.EmployeeID
--ตัวอย่าง ต้องการรหัสหมวดหมู่ ชื่อหมวดหมู่สิ้นค้า รหัสสินค้า ราคา ประเทศที่มา
--โดยเรียงลำดับตามหมวดหมู่สินค้า และราคาสูงไปต่ำ และสินค้ามาจากต่างประเทศ USA,Mexico,Canada
select c.CategoryID, c.CategoryName,
        p.ProductID,p.productName,p.UnitPrice,
        s.Country
from Products p inner join Categories c on p.CategoryID = c.CategoryID
                        inner join Suppliers s on p.SupplierID = s.SupplierID
where s.Country in ('USA','Mexico','Canada')
order by country

--แบบฝึกหัดการ Join ตาราง
--1.ต้องการ รหัสบริษัทขนส่ง, ชื่อบริษัทขนส่ง, จำนวนใบสั่งซื้อที่เกี่ยวข้อง, ยอดรวมค่าขนส่ง
select s.ShipperID,
       s.CompanyName,
       count(o.OrderID) as [จำนวนใบสั่งซื้อ],
       sum(o.Freight) as [ยอดรวมค่าขนส่ง]
from Shippers s inner join Orders o on s.ShipperID = o.ShipVia
group by s.ShipperID,s.CompanyName;
--2. รหัสใบสั่งซื้อ, วันที่สั่งซื้อ, ชื่อบริษัทลูกค้า, แสดงเฉพาะลูกค้าที่อยู่ USA
select o.OrderID,
       format(o.OrderDate,'d','en-gb') as[order date],
       c.CompanyName
from Orders o inner join Customers c on o.CustomerID = c.CustomerID
where c.Country = 'USA';

--3. รหัสพนักงาน, ชื่อนามสกุล, จำนวนใบสั่งซื้อที่เกี่ยวข้อง
select e.EmployeeID,
       e.FirstName + space(2) + e.LastName as [ชื่อ-นามสกุล],
       count(o.OrderID) as [จำนวนใบสั่งซื้อ]
from Employees e inner join Orders o on e.EmployeeID = o.EmployeeID
group by e.EmployeeID,e.FirstName + space(2) + e.LastName

--4.รหัสใบสั่งซื้อ, วันที่สั่งซื้อ, ชื่อพนักงาน, ชื่อลูกค้า, ชื่อบริษัทขนส่ง, ยอดรวมในใบสั่งซื้อ
--  เฉพาะรายการที่ขายในปี 1997 และเรียงยอดเงิน มากไปน้อย
select o.OrderID,
       o.OrderDate,
       e.FirstName + space(2) + e.LastName as [ชื่อพนักงาน],
       c.CompanyName as [ชื่อลูกค้า],
       s.CompanyName as [ชื่อบริษัทขนส่ง],
       sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) as [ยอดรวมในใบสั่งซื้อ]
from Orders o inner join Employees e on o.EmployeeID = e.EmployeeID
              inner join Customers c on o.CustomerID = c.CustomerID
              inner join Shippers s on o.ShipVia = s.ShipperID
              inner join [Order Details] od on o.OrderID = od.OrderID
where year(o.OrderDate) = 1997
group by o.OrderID,o.OrderDate,e.FirstName,e.LastName,c.CompanyName,s.CompanyName
order by [ยอดรวมในใบสั่งซื้อ] desc;

--ต้องการ รหัสสินค้า ชื่อสินค้า จำนวนที่ขายได้ เฉพาะสนค้าที่ขายดีที่สุด 5 อันดับแรก ในปี 1997
select top 5 p.ProductID,
       p.ProductName,
       sum(od.Quantity) as [จำนวนที่ขายได้]
from Products p inner join [Order Details] od on p.ProductID = od.ProductID
                inner join Orders o on od.OrderID = o.OrderID
where year(o.OrderDate) = 1997
group by p.ProductID,p.ProductName
order by [จำนวนที่ขายได้] desc;

--ข้อมูลลูกค้า ชื่อบริษัทลูกค้า และประเทศลูกค้า ที่ซื้อสินค้าที่มาขากบริษัทชื่อ Exotic Liquids   ออกสอบ
select distinct c.CustomerID,
       c.CompanyName,
       c.Country
from Customers c inner join Orders o on c.CustomerID = o.CustomerID
                 inner join [Order Details] od on o.OrderID = od.OrderID
                 inner join Products p on od.ProductID = p.ProductID
                 inner join Suppliers s on p.SupplierID = s.SupplierID
where s.CompanyName = 'Exotic Liquids'
order by c.CompanyName;
--ชื่อบริษัทลูกค้าที่มีหมวดหมู่ Seafood       ออกสอบ
select distinct c.CompanyName
from Customers c inner join Orders o on c.CustomerID = o.CustomerID
                 inner join [Order Details] od on o.OrderID = od.OrderID
                 inner join Products p on od.ProductID = p.ProductID
                 inner join Categories ca on p.CategoryID = ca.CategoryID
where ca.CategoryName = 'Seafood'
order by c.CompanyName;
-- sub Query (Query ซ้อนกัน)
-- ชื่อหนักงานที่มีตำแหน่งเดียวกับ Nancy (nancy ตำแหน่งอะไร)
select FirstName + space(2) + LastName as [ชื่อพนักงาน],
       Title as [ตำแหน่ง]
from Employees
where Title = (select Title
               from Employees
               where FirstName = 'Nancy');
-- ชื่อพนักงานที่มีอายุน้อยกว่า Robert (Robert เกิดเมื่อใด)
select FirstName + space(2) + LastName as [ชื่อพนักงาน],
       BirthDate as [วันเกิด]
from Employees
where BirthDate > (select BirthDate
                   from Employees
                   where FirstName = 'Robert');
--วันเกิด Robert
select BirthDate as [วันเกิด]
from Employees
where FirstName = 'Robert';
-- รหัสสินค้า ชื่อสินค้า ที่มีราคาสูงกว่าค่าเฉลี่ยทั้งหมดของราคาสินค้า  (ค่าเฉลี่ยของราคาสินค้าคืออะไร)
select ProductID,
       ProductName,
       UnitPrice,
       (select avg(UnitPrice)
        from Products) as [ค่าเฉลี่ยราคาสินค้า]
from Products
where UnitPrice > (select avg(UnitPrice)
                   from Products);
-- ชื่อ นามสกุล พนักงานที่ อายุมากที่สุด
select FirstName + space(2) + LastName as [ชื่อ-นามสกุล],
       BirthDate as [วันเกิด]
from Employees
where BirthDate = (select min(BirthDate)
                   from Employees);
-- ชื่อ นามสกุล พนักงานที่ เข้าทำงานหลังสุด
select FirstName + space(2) + LastName as [ชื่อ-นามสกุล],
       HireDate as [วันที่เข้าทำงาน]
from Employees
where HireDate = (select max(HireDate)
                  from Employees);
--สำรวจรายชื่อตารางใน Database
SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';
--สำรวจโครงสร้างตารางใน 
EXEC sp_help 'Products'
EXEC sp_help 'Employees'
--คำสั่ง Select เริ่มต้น (Query Data)
--ต้องการข้อมูลสินค้า
select * from products
--ต้องการ รหัสสินค้า ชื่อสินค้า ราคา
SELECT
    ProductID,
    ProductName,
    UnitPrice
FROM Products
--ต้องการ ชื่อสินค้า ราคา
---- Alias Name = เรียกง่ายๆว่าชื่อเล่น
SELECT
    ProductID AS N'รหัส',
    ProductName AS N'ชื่อสินค้า',
    UnitPrice AS N'ราคา'
FROM Products

SELECT
    ProductID AS N'รหัส',
    ProductName AS N'ชื่อสินค้า',
    UnitPrice AS N'ราคา'
FROM Products

SELECT
    ProductID รหัส ,
    ProductName ชื่อสินค้า,
    UnitPrice ราคา
FROM Products
--ใช้ Distinct สำหรับกำจักข้อมูลที่ซ้ำกัน
select Position from Employees
--ใช้ Top(n) สำหรับอสดงข้อมูล n รายการ (โดยปกติจะใช้ร่วมกันการเรียงลำดับ)
select top(3)
    ProductID,
    ProductName,
    Unitprice 
from Products
--ปรับปรุงราคาสินค้า "ดินสอ" เป็นราคาใหม่ 17 บาทท
update dbo.products
set 
    UnitPrice = 17.00,
    UnitsInStock = 100
where ProductName = 'ดินสอ'
--หลังจากรันโค้ดแล้วดูข้อมูลว่าเปรี่ยนหรือไม่
select * from dbo.Products
-- ปรับปรุงจำนวนคงเหลือของน้ำส้ม เพิ่มจากเดิมอีก 100 ชิ้น
update dbo.Products
set UnitsInStock = UnitsInStock+100
where ProductName = 'น้ำส้ม'
select * from dbo.Products
--ปรับปรุงราคาแซมพู ลดราคา 5บาท
update dbo.Products
set UnitPrice = UnitPrice-5
where ProductName = 'แชมพู'
select * from dbo.Products

delete from dbo.Products
where productID = N'P1';
select * from dbo.Products

--การใช้ where ในคำสั่ง Select
---ข้อมูลสินค้าที่มีราคาน้อยกว่า 20

--ชื่อ นามสกุล พนักงาน ที่มีตำแหน่ง 'Sale Manager'
Select FirstName, LastName From dbo.Employees
Where Position = 'Sale Manager'

--รหัส ชื่อสินค้า ที่เลิกจำหน่ายแล้ว (discontinued) =1
select productID, productName from dbo.Products
where Discontinued = 1 

SELECT *
FROM dbo.Products
WHERE UnitPrice >= 10
  AND UnitsInStock < 200;

SELECT *
FROM dbo.Products
WHERE CategoryID = 2
   OR CategoryID = 4;

SELECT *
FROM dbo.Products
WHERE NOT Discontinued = 1;

SELECT
    ProductID,
    ProductName,
    UnitPrice
FROM dbo.Products
WHERE UnitPrice BETWEEN 10 AND 20;

SELECT
    ProductID,
    ProductName,
    CategoryID
FROM dbo.Products
WHERE CategoryID IN (1, 2, 4);
--ต้องการข้อมูลสินค้าที่มีจำวนคงเหลือ 300-500 ชิ้น
select * from dbo.Products
where UnitsInStock between 300 and 500

--การใช้เงื่อนไขร่วมกับ Wildcard %
--ต้องการข้อมูลพนักงานที่มีชื่อขึ้นต้นด้วย ก
select * from Employees
where FirstName Like 'ก%'

--ต้องการข้อมูลพนักงานที่มีนามสกุลลงทายด้วย "คำ"
select * from Employees
where LastName Like 'คำ%'

--เตรียมข้อมูลใช้กับคำสั่ง is Null
insert into Employees(FirstName, UserName, Password)
values ('ไอซ์','ice','1234'),('บาส','Bas','1234')

select * from Employees
where LastName is NUll or LastName='';
--ปรับปรุงข้อมูลทดสอบช่องว่าง
update Employees set LastName = ''
where firstname='บาส'

--ปัญหาเบื้องต้นจกาค่า Null คือ ไปรวมกับใครก็เป็น Null ไปหมด
select FirstName+' '+LastName as ชื่อพนักงาน
from Employees

--ต้องการข้อมูลที่ขายสินค้าก่อนวันที่ 10 ก.พ. 2013
select * from Receipts
where ReceiptDate < '2013-02-10'
--บางกรณีใช้ funtion year() หรือ Month() ร่วมกับเงื่อนไขได้
--ต้องการข้อมูลในใบเสร็จที่ขายสินค้าในเดือนกุมภาพันธ์ ปี 2013
select * from Receipts
where Year(ReceiptDate)=2013
and Month(ReceiptDate)= 02

select ProductID,ProductName,UnitPrice
from dbo.Products
order by UnitPrice desc;
--ต้องการข้อมูลใบเสร็จ อันใหมที่สุดขึ้นก่อน
select * from Receipts
order by ReceiptDate desc;

select * from Receipts
order by ReceiptDate asc;

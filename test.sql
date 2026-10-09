SELECT 
    c.CompanyName,
    c.City,
    COUNT(o.OrderID) AS TotalOrders
FROM Customers c
JOIN Orders o 
    ON c.CustomerID = o.CustomerID
WHERE 
    -- เติมเงื่อนไขเมืองตรงนี้ (London หรือ Berlin)
GROUP BY 
    -- เติมคอลัมน์ที่จะจัดกลุ่มตรงนี้ (ระวัง: คอลัมน์ที่อยู่ใน SELECT ที่ไม่ใช่ฟังก์ชันนับ ต้องเอามาใส่ใน GROUP BY ให้หมด)
HAVING 
    -- เติมเงื่อนไขจำนวนออเดอร์ (>= 3) ตรงนี้
ORDER BY 
    -- เติมการเรียงลำดับจากมากไปน้อยตรงนี้

-- ==============================================================================
-- โจทย์: จงเขียนคำสั่ง SQL เพื่อแสดงรายชื่อพนักงาน (โดยนำคำนำหน้าชื่อ, ชื่อ, 
-- และนามสกุลมาต่อกันเป็นคอลัมน์เดียว), ตำแหน่งงาน (title), จำนวนคำสั่งซื้อที่ไม่ซ้ำกัน 
-- (TotalOrders), และยอดขายรวมหลังหักส่วนลดที่แปลงเป็นทศนิยม 2 ตำแหน่ง (TotalSales) 
-- ของพนักงานแต่ละคน โดยให้เลือกเฉพาะคำสั่งซื้อที่เกิดขึ้นในปี ค.ศ. 1996 
-- และลูกค้าของคำสั่งซื้อนั้นอาศัยอยู่ในประเทศฝรั่งเศส (France), สเปน (Spain), 
-- อิตาลี (Italy) หรือเยอรมนี (Germany)
-- ==============================================================================
SELECT 
    -- 1. นำคำนำหน้า, ชื่อ, ช่องว่าง 2 เคาะ และนามสกุลมาต่อกันเป็นคอลัมน์เดียว ตั้งชื่อว่า EmployeeName
    e.titleofcourtesy + e.firstname + SPACE(2) + e.lastname AS EmployeeName,
    
    -- 2. แสดงตำแหน่งงานของพนักงาน
    e.title,
    
    -- 3. นับจำนวนรหัสคำสั่งซื้อที่ไม่ซ้ำกันของพนักงานแต่ละคน ตั้งชื่อว่า TotalOrders
    COUNT(DISTINCT o.orderID) AS TotalOrders,
    
    -- 4. คำนวณยอดขายรวม (ราคา x จำนวน x ส่วนลด) แล้วแปลงให้เป็นทศนิยม 2 ตำแหน่ง ตั้งชื่อว่า TotalSales
    CAST(SUM((od.UnitPrice * od.Quantity * (1 - od.Discount))) AS DECIMAL(10,2)) AS TotalSales

FROM employees e -- เริ่มต้นที่ตารางพนักงาน (กำหนดชื่อย่อเป็น e)

-- เชื่อมตารางคำสั่งซื้อ (orders) เพื่อดูว่าพนักงานคนไหนรับผิดชอบออเดอร์ใดบ้าง
JOIN orders o 
    ON o.employeeID = e.employeeID

-- เชื่อมตารางรายละเอียดสินค้า ([order details]) เพื่อดึงราคาและจำนวนมาคำนวณยอดขาย
JOIN [order details] od 
    ON o.orderId = od.orderid

-- เชื่อมตารางลูกค้า (customers) เพื่อดึงข้อมูลประเทศของลูกค้ามาเช็กเงื่อนไข
JOIN customers c 
    ON c.customerid = o.customerid

WHERE 
    -- กรองเฉพาะลูกค้าที่มาจากประเทศ ฝรั่งเศส, สเปน, อิตาลี หรือ เยอรมนี เท่านั้น
    c.country IN ('france', 'spain', 'italy', 'germany')
    
    -- และกรองเฉพาะคำสั่งซื้อที่เกิดขึ้นในปี ค.ศ. 1996 เท่านั้น
    AND YEAR(o.orderdate) = 1996

GROUP BY 
    -- จัดกลุ่มผลลัพธ์ตามชื่อ-นามสกุลและตำแหน่งพนักงาน เพื่อให้คำนวณยอดรวมแยกตามรายบุคคลได้อย่างถูกต้อง
    e.titleofcourtesy, 
    e.firstname, 
    e.lastname, 
    e.title;

    -- ==============================================================================
-- รวมชุดข้อสอบ SQL (ฐานข้อมูล Northwind) สำหรับเตรียมสอบ
-- ==============================================================================


-- ==============================================================================
-- [ข้อ 1] โจทย์: จงแสดงชื่อสินค้า (ProductName), ชื่อหมวดหมู่ (CategoryName), 
-- และจำนวนรวมของสินค้าที่ถูกขายไปทั้งหมด (TotalQuantity) เฉพาะสินค้าที่มียอดขายรวม 
-- มากกว่า 200 ชิ้นขึ้นไป โดยเรียงลำดับจากสินค้าที่ขายดีที่สุดลงมา
-- ==============================================================================

SELECT 
    p.ProductName,                 -- เลือกชื่อสินค้า
    c.CategoryName,                -- เลือกชื่อหมวดหมู่สินค้า
    SUM(od.Quantity) AS TotalQuantity -- รวมจำนวนสินค้าที่ขายได้ทั้งหมด ตั้งชื่อว่า TotalQuantity
FROM Products p                    -- ตารางสินค้า (กำหนดชื่อย่อ p)
INNER JOIN Categories c            -- เชื่อมตารางหมวดหมู่สินค้า (กำหนดชื่อย่อ c)
    ON p.CategoryID = c.CategoryID
INNER JOIN [Order Details] od      -- เชื่อมตารางรายละเอียดการสั่งซื้อ (มีเว้นวรรคต้องใช้ก้ามปูหรือ Backtick ครอบ)
    ON p.ProductID = od.ProductID
GROUP BY 
    p.ProductName, 
    c.CategoryName                 -- จัดกลุ่มตามชื่อสินค้าและหมวดหมู่ เพื่อรวมจำนวนชิ้น
HAVING 
    SUM(od.Quantity) > 200         -- กรองเอาเฉพาะกลุ่มที่มียอดขายรวมมากกว่า 200 ชิ้น
ORDER BY 
    TotalQuantity DESC;            -- เรียงลำดับจากมากไปน้อย (ขายดีที่สุดอยู่บนสุด)


-- ==============================================================================
-- [ข้อ 2] โจทย์: จงแสดงชื่อสินค้า (ProductName), ราคาต่อหน่วย (UnitPrice), 
-- และชื่อหมวดหมู่ (CategoryName) ของสินค้าที่มีราคาแพงกว่าค่าเฉลี่ยราคาสินค้าทั้งหมดในร้าน 
-- และอยู่ในหมวดหมู่ 'Beverages' หรือ 'Condiments' เท่านั้น
-- ==============================================================================

SELECT 
    p.ProductName,                 -- แสดงชื่อสินค้า
    p.UnitPrice,                   -- แสดงราคาต่อหน่วย
    c.CategoryName                 -- แสดงชื่อหมวดหมู่
FROM Products p                    -- จากตารางสินค้า
INNER JOIN Categories c            -- เชื่อมกับตารางหมวดหมู่สินค้า
    ON p.CategoryID = c.CategoryID
WHERE 
    p.UnitPrice > (                -- เงื่อนไขที่ 1: ราคาต้องมากกว่า...
        SELECT AVG(UnitPrice)      -- (Subquery) หาค่าเฉลี่ยราคาสินค้าทั้งหมดในร้าน
        FROM Products
    )
    AND c.CategoryName IN ('Beverages', 'Condiments'); -- เงื่อนไขที่ 2: ต้องอยู่ในหมวดหมู่ที่กำหนด


-- ==============================================================================
-- [ข้อ 3] โจทย์: จงแสดงชื่อบริษัทขนส่ง (CompanyName จากตาราง Shippers), 
-- จำนวนคำสั่งซื้อทั้งหมดที่รับผิดชอบ (TotalOrders), และค่าขนส่งรวม (TotalFreight) 
-- ของแต่ละบริษัท เฉพาะคำสั่งซื้อที่เกิดขึ้นในปี ค.ศ. 1997
-- ==============================================================================

SELECT 
    s.CompanyName AS ShipperName,  -- แสดงชื่อบริษัทขนส่ง ตั้งชื่อว่า ShipperName
    COUNT(o.OrderID) AS TotalOrders, -- นับจำนวนออเดอร์ที่บริษัทนั้นจัดส่ง
    SUM(o.Freight) AS TotalFreight -- รวมค่าขนส่ง (Freight) ทั้งหมดของบริษัทนั้น
FROM Shippers s                    -- เริ่มจากตารางบริษัทขนส่ง (ตั้งชื่อย่อ s)
INNER JOIN Orders o                -- เชื่อมกับตารางคำสั่งซื้อ (Orders ตั้งชื่อย่อ o)
    ON s.ShipperID = o.ShipVia     -- เชื่อมด้วยรหัสบริษัทขนส่ง (ShipVia ในตาราง Orders)
WHERE 
    YEAR(o.OrderDate) = 1997       -- กรองเฉพาะออเดอร์ที่เกิดขึ้นในปี 1997
GROUP BY 
    s.CompanyName                  -- จัดกลุ่มตามชื่อบริษัทขนส่ง เพื่อหายอดรวมและจำนวนออเดอร์
ORDER BY 
    TotalFreight DESC;             -- เรียงลำดับตามค่าขนส่งรวมจากมากไปน้อย


-- ==============================================================================
-- [ข้อ 4] โจทย์: จงเขียนคำสั่ง SQL เพื่อแสดงรายชื่อพนักงาน (โดยนำคำนำหน้าชื่อ, ชื่อ, 
-- และนามสกุลมาต่อกันเป็นคอลัมน์เดียว), ตำแหน่งงาน (title), จำนวนคำสั่งซื้อที่ไม่ซ้ำกัน 
-- (TotalOrders), และยอดขายรวมหลังหักส่วนลดที่แปลงเป็นทศนิยม 2 ตำแหน่ง (TotalSales) 
-- ของพนักงานแต่ละคน โดยให้เลือกเฉพาะคำสั่งซื้อที่เกิดขึ้นในปี ค.ศ. 1996 
-- และลูกค้าของคำสั่งซื้อนั้นอาศัยอยู่ในประเทศฝรั่งเศส (France), สเปน (Spain), 
-- อิตาลี (Italy) หรือเยอรมนี (Germany)
-- ==============================================================================

SELECT 
    -- 1. นำคำนำหน้า, ชื่อ, ช่องว่าง 2 เคาะ และนามสกุลมาต่อกันเป็นคอลัมน์เดียว ตั้งชื่อว่า EmployeeName
    e.titleofcourtesy + e.firstname + SPACE(2) + e.lastname AS EmployeeName,
    
    -- 2. แสดงตำแหน่งงานของพนักงาน
    e.title,
    
    -- 3. นับจำนวนรหัสคำสั่งซื้อที่ไม่ซ้ำกันของพนักงานแต่ละคน ตั้งชื่อว่า TotalOrders
    COUNT(DISTINCT o.orderID) AS TotalOrders,
    
    -- 4. คำนวณยอดขายรวม (ราคา x จำนวน x ส่วนลด) แล้วแปลงให้เป็นทศนิยม 2 ตำแหน่ง ตั้งชื่อว่า TotalSales
    CAST(SUM((od.UnitPrice * od.Quantity * (1 - od.Discount))) AS DECIMAL(10,2)) AS TotalSales

FROM employees e -- เริ่มต้นที่ตารางพนักงาน (กำหนดชื่อย่อเป็น e)

-- เชื่อมตารางคำสั่งซื้อ (orders) เพื่อดูว่าพนักงานคนไหนรับผิดชอบออเดอร์ใดบ้าง
JOIN orders o 
    ON o.employeeID = e.employeeID

-- เชื่อมตารางรายละเอียดสินค้า ([order details]) เพื่อดึงราคาและจำนวนมาคำนวณยอดขาย
JOIN [order details] od 
    ON o.orderId = od.orderid

-- เชื่อมตารางลูกค้า (customers) เพื่อดึงข้อมูลประเทศของลูกค้ามาเช็กเงื่อนไข
JOIN customers c 
    ON c.customerid = o.customerid

WHERE 
    -- กรองเฉพาะลูกค้าที่มาจากประเทศ ฝรั่งเศส, สเปน, อิตาลี หรือ เยอรมนี เท่านั้น
    c.country IN ('france', 'spain', 'italy', 'germany')
    
    -- และกรองเฉพาะคำสั่งซื้อที่เกิดขึ้นในปี ค.ศ. 1996 เท่านั้น
    AND YEAR(o.orderdate) = 1996

GROUP BY 
    -- จัดกลุ่มผลลัพธ์ตามชื่อ-นามสกุลและตำแหน่งพนักงาน เพื่อให้คำนวณยอดรวมแยกตามรายบุคคลได้อย่างถูกต้อง
    e.titleofcourtesy, 
    e.firstname, 
    e.lastname, 
    e.title;

-- 1. ดูข้อมูลลูกค้าทั้งหมด
SELECT * FROM customers;

-- 2. ดูข้อมูลคำสั่งซื้อทั้งหมด
SELECT * FROM orders;

-- 3. ดูข้อมูลรายละเอียดสินค้าในแต่ละออร์เดอร์
SELECT * FROM [order details];

-- 4. ดูข้อมูลสินค้าทั้งหมด
SELECT * FROM products;

-- 5. ดูข้อมูลประเภทสินค้า (หมวดหมู่สินค้า)
SELECT * FROM categories;

-- 6. ดูข้อมูลบริษัทผู้จัดส่งสินค้า
SELECT * FROM shippers;

-- 7. ดูข้อมูลบริษัทผู้ผลิต/ผู้จัดจำหน่ายสินค้า
SELECT * FROM suppliers;

-- 1. ดูรายชื่อประเทศทั้งหมดของลูกค้า (Customers) แบบไม่ซ้ำกัน
SELECT DISTINCT Country 
FROM customers;

-- 2. ดูรายชื่อประเทศทั้งหมดของผู้จัดจำหน่าย (Suppliers)
SELECT DISTINCT Country 
FROM suppliers;

-- 3. ดูรายชื่อประเทศของพนักงาน (Employees)
SELECT DISTINCT Country 
FROM employees;

SELECT CompanyName, Country        -- เลือกคอลัมน์ CompanyName และ Country มาแสดง
FROM Customers                     -- ดึงข้อมูลจากตาราง Customers (ลูกค้า)
WHERE Country IN ('USA', 'UK')     -- กรองเฉพาะแถวที่ประเทศเป็น USA หรือ UK
ORDER BY CompanyName ASC;          -- เรียงลำดับผลลัพธ์ตามชื่อบริษัทจากน้อยไปมาก (A-Z)

SELECT 
    EmployeeID,                    -- แสดงรหัสพนักงาน
    COUNT(OrderID) AS TotalOrders  -- นับจำนวน OrderID ของแต่ละคน ตั้งชื่อคอลัมน์ผลลัพธ์ว่า TotalOrders
FROM Orders                        -- ดึงข้อมูลจากตาราง Orders (คำสั่งซื้อ)
GROUP BY EmployeeID;               -- จัดกลุ่มข้อมูลตามรหัสพนักงาน เพื่อให้คำนวณแยกตามรายบุคคล

SELECT 
    p.ProductName,                 -- เลือกชื่อสินค้าจากตาราง Products (ตั้งย่อว่า p)
    c.CategoryName                 -- เลือกชื่อหมวดหมู่จากตาราง Categories (ตั้งย่อว่า c)
FROM Products p                    -- กำหนดตารางหลักคือ Products
INNER JOIN Categories c            -- เชื่อมตาราง Categories เข้ามา
    ON p.CategoryID = c.CategoryID; -- เงื่อนไขการเชื่อมคือรหัสหมวดหมู่ (CategoryID) ต้องตรงกัน


SELECT ProductName, UnitPrice     -- แสดงชื่อสินค้าและราคา
FROM Products                     -- จากตาราง Products
WHERE UnitPrice > (               -- เงื่อนไข: ราคาต้องมากกว่า...
    SELECT AVG(UnitPrice)         -- (Subquery) คำนวณหาค่าเฉลี่ยราคาสินค้าทั้งหมดในร้าน
    FROM Products
);



-- ==============================================================================
-- โจทย์ฝึกหัด: จงเขียนคำสั่ง SQL เพื่อแสดงชื่อบริษัทลูกค้า (CompanyName), เมือง (City), 
-- และจำนวนคำสั่งซื้อทั้งหมด (TotalOrders) ของลูกค้าที่อาศัยอยู่ในเมือง 'London' หรือ 'Berlin' 
-- โดยให้แสดงเฉพาะลูกค้าที่มีจำนวนคำสั่งซื้อตั้งแต่ 3 ออเดอร์ขึ้นไป และเรียงลำดับ 
-- จากลูกค้าที่มียอดคำสั่งซื้อมากที่สุดไปหาน้อยที่สุด
-- ==============================================================================

-- เขียนโค้ดของคุณด้านล่างนี้ได้เลยครับ:
select 
     c.CompanyName,
     c.City,
     count(c.CustomerID) as TotalOrders
from Customers c
join Orders o on c.CustomerID = o.CustomerID
where c.City in ('London', 'Berlin')
group by c.CompanyName,
     c.City
having
     count(c.CustomerID) >=3
order by TotalOrders desc;

-- ==============================================================================
-- โจทย์: จงเขียนคำสั่ง SQL เพื่อแสดงชื่อสินค้า (ProductName) และราคาต่อหน่วย (UnitPrice) 
-- ของสินค้าทั้งหมดที่มีราคาแพงกว่าราคาสินค้าเฉลี่ยของสินค้าทุกตัวในร้าน 
-- โดยให้เรียงลำดับสินค้าจากราคาแพงที่สุดลงมาหาถูกที่สุด
-- ==============================================================================

SELECT 
    p.ProductName,                 -- เลือกชื่อสินค้ามาแสดงผล
    p.UnitPrice                    -- เลือกราคาต่อหน่วยของสินค้ามาแสดงผล
FROM Products p                    -- กำหนดตารางหลักคือ Products และตั้งชื่อย่อว่า p
WHERE 
    p.UnitPrice > (                -- เงื่อนไข: ราคาของสินค้าตัวนั้นต้องมากกว่า...
        SELECT AVG(UnitPrice)      -- (Subquery) คำนวณหาค่าเฉลี่ยราคาสินค้าทั้งหมดในตาราง Products
        FROM Products
    )
ORDER BY 
    p.UnitPrice DESC;            -- เรียงลำดับผลลัพธ์ตามราคาจากมากไปน้อย (แพงสุดอยู่บนสุด)
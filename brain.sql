-- ==============================================================================
-- สรุปโครงสร้างตารางและความสัมพันธ์ (Schema & Relationships) ฐานข้อมูล Northwind
-- สำหรับใช้อ่านทบทวนก่อนสอบ SQL
-- ==============================================================================


-- ==============================================================================
-- 1. แผนผังความสัมพันธ์หลัก (Primary Key & Foreign Key Map)
-- ==============================================================================
-- 
--   [Categories] (หมวดหมู่สินค้า)
--        |
--        | (1 to M)ผ่าน CategoryID
--        v
--   [Products] (สินค้า) <------------------ (1 to M) ผ่าน ProductID ----+
--        |                                                              |
--        | (1 to M) ผ่าน ProductID                                       |
--        v                                                              |
--   [Order Details] (รายละเอียดคำสั่งซื้อ) <--- (1 to M) ผ่าน OrderID --- [Orders] (คำสั่งซื้อ)
--                                                                       ^      ^      ^
--                                        (M to 1 ผ่าน CustomerID) ------+      |      |
--                                        (M to 1 ผ่าน EmployeeID) -------------+      |
--                                        (M to 1 ผ่าน ShipVia) -----------------------+ [Shippers] (บริษัทขนส่ง)
-- 
-- ==============================================================================


-- ==============================================================================
-- 2. รายละเอียดตารางหลักและคอลัมน์สำคัญที่ต้องจำ
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- A. ตาราง Customers (ข้อมูลลูกค้า)
-- คอลัมน์สำคัญ: CustomerID (PK), CompanyName, ContactName, City, Country
-- ------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------
-- B. ตาราง Employees (ข้อมูลพนักงาน)
-- คอลัมน์สำคัญ: EmployeeID (PK), FirstName, LastName, Title, TitleOfCourtesy
-- ------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------
-- C. ตาราง Orders (ข้อมูลคำสั่งซื้อ / หัวบิล)
-- คอลัมน์สำคัญ: OrderID (PK), CustomerID (FK), EmployeeID (FK), OrderDate, Freight, ShipVia (FK)
-- ------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------
-- D. ตาราง [Order Details] (รายละเอียดสินค้าในแต่ละคำสั่งซื้อ)
-- คอลัมน์สำคัญ: OrderID (FK), ProductID (FK), UnitPrice, Quantity, Discount
-- ------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------
-- E. ตาราง Products (ข้อมูลสินค้า)
-- คอลัมน์สำคัญ: ProductID (PK), ProductName, CategoryID (FK), UnitPrice, UnitsInStock
-- ------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------
-- F. ตาราง Categories (หมวดหมู่สินค้า)
-- คอลัมน์สำคัญ: CategoryID (PK), CategoryName, Description
-- ------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------
-- G. ตาราง Shippers (บริษัทขนส่ง)
-- คอลัมน์สำคัญ: ShipperID (PK), CompanyName, Phone
-- ------------------------------------------------------------------------------


-- ==============================================================================
-- 3. ตัวอย่างโค้ด SQL (แยกตามประเภทการ JOIN และการใช้งานจริง)
-- ==============================================================================


-- ------------------------------------------------------------------------------
-- ตัวอย่างที่ 1: การ JOIN 2 ตาราง (Customers + Orders)
-- โจทย์: แสดงชื่อบริษัทลูกค้าและวันที่สั่งซื้อ
-- ------------------------------------------------------------------------------
SELECT 
    c.CompanyName,
    o.OrderDate
FROM Customers c
JOIN Orders o 
    ON c.CustomerID = o.CustomerID;


-- ------------------------------------------------------------------------------
-- ตัวอย่างที่ 2: การ JOIN 3 ตารางเพื่อดึงข้อมูลข้ามสาย (Customers + Orders + Employees)
-- โจทย์: แสดงชื่อลูกค้า, วันที่สั่งซื้อ, และชื่อพนักงานที่รับออเดอร์นั้น
-- ------------------------------------------------------------------------------
SELECT 
    c.CompanyName AS CustomerName,
    o.OrderDate,
    e.FirstName + SPACE(1) + e.LastName AS EmployeeName
FROM Customers c
JOIN Orders o 
    ON c.CustomerID = o.CustomerID
JOIN Employees e 
    ON o.EmployeeID = e.EmployeeID;


-- ------------------------------------------------------------------------------
-- ตัวอย่างที่ 3: การ JOIN ข้ามฝั่งไปหาตารางสินค้า (Orders + [Order Details] + Products)
-- โจทย์: แสดงรหัสออเดอร์, ชื่อสินค้า, และจำนวนที่ซื้อ
-- ------------------------------------------------------------------------------
SELECT 
    od.OrderID,
    p.ProductName,
    od.Quantity
FROM Orders o
JOIN [Order Details] od 
    ON o.OrderID = od.OrderID
JOIN Products p 
    ON od.ProductID = p.ProductID;


-- ------------------------------------------------------------------------------
-- ตัวอย่างที่ 4: การ JOIN ครบวงจรฝั่งสินค้า (Products + Categories + [Order Details])
-- โจทย์: แสดงชื่อหมวดหมู่, ชื่อสินค้า และยอดรวมจำนวนที่ขายได้ของแต่ละสินค้า
-- ------------------------------------------------------------------------------
SELECT 
    c.CategoryName,
    p.ProductName,
    SUM(od.Quantity) AS TotalSold
FROM Categories c
JOIN Products p 
    ON c.CategoryID = p.CategoryID
JOIN [Order Details] od 
    ON p.ProductID = od.ProductID
GROUP BY 
    c.CategoryName,
    p.ProductName;


-- ------------------------------------------------------------------------------
-- ตัวอย่างที่ 5: การใช้ Subquery ร่วมกับการคำนวณค่าเฉลี่ย
-- โจทย์: หาสินค้าที่มีราคาแพงกว่าค่าเฉลี่ยของราคาสินค้าทั้งหมด
-- ------------------------------------------------------------------------------
SELECT 
    ProductName,
    UnitPrice
FROM Products
WHERE UnitPrice > (
    SELECT AVG(UnitPrice) 
    FROM Products
);

-- ==============================================================================
-- เฉลยโจทย์ที่ 1: JOIN 3 ตาราง (Employees + Orders + Customers) + กรองชื่อและเดือน
-- ==============================================================================
SELECT 
    e.FirstName + SPACE(1) + e.LastName AS EmployeeName,
    c.CompanyName,
    o.OrderDate
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE e.LastName = 'Davolio'
  AND YEAR(o.OrderDate) = 1996
  AND MONTH(o.OrderDate) = 10
ORDER BY o.OrderDate ASC;


-- ==============================================================================
-- เฉลยโจทย์ที่ 2: JOIN 2 ตาราง (Shippers + Orders) + GROUP BY และ HAVING
-- ==============================================================================
SELECT 
    s.CompanyName AS ShipperName,
    SUM(o.Freight) AS TotalFreight
FROM Shippers s
JOIN Orders o ON s.ShipperID = o.ShipVia
GROUP BY s.CompanyName
HAVING SUM(o.Freight) > 500
ORDER BY TotalFreight DESC;


-- ==============================================================================
-- เฉลยโจทย์ที่ 3: JOIN 4 ตาราง (Categories + Products + [Order Details] + Orders)
-- ==============================================================================
SELECT 
    cat.CategoryName,
    p.ProductName,
    SUM(od.UnitPrice * od.Quantity) AS TotalSales
FROM Categories cat
JOIN Products p ON cat.CategoryID = p.CategoryID
JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON od.OrderID = o.OrderID
GROUP BY cat.CategoryName, p.ProductName
ORDER BY TotalSales DESC;


-- ==============================================================================
-- เฉลยโจทย์ที่ 4: JOIN 4 ตาราง + DISTINCT กรองประเทศ France
-- ==============================================================================
SELECT DISTINCT
    c.CompanyName,
    c.City,
    p.ProductName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE c.Country = 'France'
ORDER BY c.CompanyName ASC;

-- ==============================================================================
-- เฉลยโจทย์: การใช้ GROUP BY คู่กับฟังก์ชัน MAX และ HAVING
-- ==============================================================================

SELECT 
    c.CategoryName,                     -- 1. เลือกแสดงชื่อหมวดหมู่สินค้าจากตาราง Categories
    MAX(p.UnitPrice) AS MaxPrice        -- 2. หาค่าราคาสินค้าที่แพงที่สุดในกลุ่มนั้น ตั้งชื่อว่า MaxPrice
FROM Categories c                       -- 3. กำหนดตารางหลักคือ Categories (ตั้งชื่อย่อว่า c)

JOIN Products p                         -- 4. เชื่อมไปยังตาราง Products (ตั้งชื่อย่อว่า p)
    ON c.CategoryID = p.CategoryID      --    โดยใช้ CategoryID เป็นสะพานเชื่อมระหว่าง 2 ตาราง

GROUP BY 
    c.CategoryName                      -- 5. จัดกลุ่มข้อมูลตามชื่อหมวดหมู่ เพื่อให้คำนวณ MAX แยกตามแต่ละประเภท

HAVING 
    MAX(p.UnitPrice) > 50               -- 6. กรองข้อมูลหลังจัดกลุ่ม: เลือกเฉพาะกลุ่มที่ราคาสุกยอด > 50 เท่านั้น

ORDER BY 
    MaxPrice DESC;                      -- 7. เรียงลำดับผลลัพธ์จากราคาแพงที่สุดลงมาหาถูกที่สุด

    -- ==============================================================================
-- โจทย์: จงเขียนคำสั่ง SQL เพื่อแสดงชื่อประเภทสินค้า (CategoryName) 
-- และจำนวนสินค้าทั้งหมดที่มีอยู่ในแต่ละประเภท (ตั้งชื่อคอลัมน์ว่า TotalProducts) 
-- พร้อมทั้งเรียงลำดับจากประเภทที่มีจำนวนสินค้ามากที่สุดไปหาน้อยที่สุด
-- ==============================================================================

SELECT 
    c.CategoryName,                     -- 1. เลือกแสดงชื่อประเภทสินค้าจากตาราง Categories (ตั้งชื่อย่อว่า c)
    COUNT(p.ProductID) AS TotalProducts -- 2. นับจำนวนรหัสสินค้า (ProductID) ในแต่ละกลุ่ม ตั้งชื่อว่า TotalProducts
FROM Categories c                       -- 3. กำหนดตารางหลักคือ Categories

JOIN Products p                         -- 4. เชื่อมกับตาราง Products (ตั้งชื่อย่อว่า p)
    ON c.CategoryID = p.CategoryID      --    โดยใช้ CategoryID เป็นคีย์เชื่อมระหว่างสองตาราง

GROUP BY 
    c.CategoryName                      -- 5. จัดกลุ่มข้อมูลตามชื่อประเภท เพื่อให้นับจำนวนแยกตามแต่ละหมวดหมู่ได้

ORDER BY 
    TotalProducts DESC;                 -- 6. เรียงลำดับผลลัพธ์จากประเภทที่มีสินค้ามากที่สุดไปหาน้อยที่สุด
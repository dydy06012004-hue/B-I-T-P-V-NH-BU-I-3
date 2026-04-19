--Thống kê cơ bản & GROUP BY
--Bài tập 1: 
--Tính tổng doanh thu hàng năm (AnnualRevenue) theo từng loại hình kinh doanh (BusinessType) 
--và dòng sản phẩm (ProductLine) trong bảng DimReseller. 
--Viết truy vấn để kết quả chỉ hiện thị những nhóm có tổng doanh thu lớn hơn 10 triệu. 
use [AdventureWorksDW2022]
go
select
BusinessType,
ProductLine,
sum(AnnualRevenue) as totalannualrevenue
from DimReseller
group by
BusinessType, 
ProductLine
HAVING 
SUM(AnnualRevenue) > 10000000

-- bài tập 2
--Dựa vào bảng FactInternetSales, hãy viết truy vấn trả về bảng gồm 3 cột:
--Mã khách hàng 
--Ngày gần nhất mà khách hàng thực hiện mua hàng 
--Số lượng đơn khách hàng đã mua (lưu ý phân biệt giữa COUNT và COUNT DISTINCT) 
--Chỉ hiển thị những khách hàng có ngày mua hàng gần nhất nằm trong khoảng từ năm 2012 trở về sau. 
select
customerkey,
max(OrderDate) AS LastPurchaseDate,
COUNT(DISTINCT SalesOrderNumber) AS TotalOrders
from FactInternetSales 
GROUP BY 
CustomerKey
HAVING 
MAX(OrderDate) >= '2012-01-01'

-- bài tập 3
--Viết truy vấn tính tổng doanh số bán hàng online theo từng năm. 
select
YEAR(ORDERDATE) AS SALESYEAR,
SUM(SalesAmount) AS TotalRevenue
from FactInternetSales 
GROUP BY 
YEAR(ORDERDATE)
ORDER BY
SALESYEAR ASC

--Xử lý giá trị NULL 
--Bài tập 1
--Truy vấn tất cả các nhân viên đã nghỉ việc trong bảng DimEmployee 
SELECT
EmployeeKey, 
FirstName, 
LastName, 
EndDate
FROM DIMEMPLOYEE
WHERE ENDDATE IS NOT NULL

--Bài tập 2
--Truy vấn tất cả các nhân viên không có MiddleName và được tuyển vào trong năm 2008 trong bảng DimEmployee 
SELECT
EmployeeKey, 
FirstName, 
MiddleName, 
LastName, 
HireDate
FROM DIMEMPLOYEE
WHERE 
MiddleName IS NULL
AND YEAR(HireDate) = 2008

--Bài tập 3
--(Nâng cao) Liệt kê các sản phẩm (ProductKey, EnglishProductName) trong DimProduct không có Size, 
--và ListPrice cao hơn giá trung bình của tất cả sản phẩm có Color giống nhau.
SELECT
ProductKey, 
EnglishProductName
FROM DimProduct
WHERE 
SIZE IS NULL
AND LISTPRICE > (
SELECT AVG(ListPrice)
FROM DimProduct 
WHERE Color = Color
)

--Bài tập xử lý dạng ngày tháng 
--Bài tập 1
--Viết truy vấn liệt kê thông tin các nhân viên đã nghỉ việc, kèm theo một cột tính số tháng họ đã làm việc tại công ty. 
SELECT
EmployeeKey, 
FirstName, 
LastName, 
HireDate,
EndDate,
DATEDIFF(MONTH, HireDate, EndDate) AS MonthsWorked
FROM DimEmployee
WHERE 
EndDate IS NOT NULL
--Viết truy vấn trả về trung bình số tháng gắn bó của các nhân viên trên với công ty. 
SELECT 
AVG(DATEDIFF(MONTH, HireDate, EndDate)) AS AverageMonthsWorked
FROM DimEmployee
WHERE 
EndDate IS NOT NULL

--Bài tập 2
--Viết truy vấn lấy thông tin các đơn hàng (bảng FactResellerSales) được đặt trong tháng 11 năm 2013, từ các khách hàng doanh nghiệp
--Thêm một cột mới có tên PlanShipDate, là ngày giao hàng dự kiến, được tính bằng OrderDate cộng thêm 15 ngày. 
SELECT
SalesOrderNumber,
OrderDate,
---- Cộng thêm 15 ngày vào ngày đặt hàng để có ngày giao dự kiến
DATEADD(DAY, 15, OrderDate) AS PlanShipDate,
ResellerKey
FROM FactResellerSales
WHERE
OrderDate >= '2013-11-01' 
AND OrderDate < '2013-12-01'

--Toán tử logic - LIKE statement  
-- bài tập 1
-- Từ bảng Dim product, hãy trả về bảng kết quả có các cột ProductKey, EnglishProductName, ListPrice, StandardCost. 
-- Lọc ra các sản phẩm có chữ d ở kí tự thứ 4 và đồng thời cũng có chữ t ở kí tự thứ 7 
select
ProductKey,
EnglishProductName, 
ListPrice, 
StandardCost
from Dimproduct
where EnglishProductName LIKE '___d__t%'

--bài tập 2
--Danh sách các sản phẩm áo dài tay để bán cho mùa lạnh, 
--biết mã thay thế các sản phẩm này (ProductAlternateKey) bắt đầu bằng chữ LJ trong bảng DimProduct 
select
productkey,
englishproductname,
ProductAlternateKey
from DimProduct
WHERE 
ProductAlternateKey LIKE 'LJ%'

-- bài tập 3
--Sử dụng LIKE tìm các sản phẩm có ProductAlternateKey 
--có kí tự đầu là chữ F, kí tự thứ 7 là chữ S 
--và kí tự cuối cùng là số 6 trong bảng DimProduct 
select
ProductKey, 
EnglishProductName, 
ProductAlternateKey
from DimProduct
WHERE 
ProductAlternateKey LIKE 'F_____S%6';

-- Bài tập 4
--Trong DimProduct, tìm sản phẩm có EnglishProductName bắt đầu bằng "Mountain" và có chứa "Bike". 
select
ProductKey, 
EnglishProductName
from DimProduct
where 
EnglishProductName LIKE 'Mountain%Bike%'

--Bài tập 5
--Trong bảng DimCustomer, tìm danh sách khách hàng có EmailAddress bắt đầu bằng chữ s, 
--ký tự thứ hai không phải là a hoặc e. 
select
customerkey,
firstname,
lastname,
emailaddress
from 
dimcustomer
where 
EmailAddress like 's[^ae]%'

--Bài tập 6
--Trong bảng DimCustomer, tìm tất cả khách hàng có EmailAddress bắt đầu bằng chữ "a",
--ký tự thứ hai không phải là "b" hoặc "c",
--và tiếp theo có ít nhất một ký tự bất kỳ.
select
customerkey,
firstname,
lastname,
emailaddress
from 
dimcustomer
WHERE 
EmailAddress LIKE 'a[^bc]_%'

--Bài tập 7
--Trong bảng DimEmployee, lấy danh sách nhân viên có LoginID bắt đầu bằng "adventure-", 
--ký tự tiếp theo không phải là số. 
select 
employeekey,
FirstName, 
LastName, 
LoginID
from dimemployee
where
loginID Like 'adventure-[^0-9]%'

--Bài tập 8
--Trong DimProduct, lọc sản phẩm có ProductAlternateKey: 
--Bắt đầu bằng "B". 
--Ký tự thứ ba không nằm trong khoảng 0–9 và a–f (tức là không phải số và không phải a–f). 
--Ký tự thứ tư không phải chữ cái 
--Tổng độ dài ProductAlternateKey đúng 7 ký tự. 
select
productkey,
EnglishProductName,
ProductAlternateKey
from DimProduct
where 
ProductAlternateKey LIKE 'B_[^0-9a-f][^a-zA-Z]___'

--Bài tập xử lý chuỗi 
--Bài tập 1: 
--Lấy ra tên miền email của từng nhân viên phòng marketing trong bảng DimEmployee
SELECT
firstname,
lastname,
emailaddress,
SUBSTRING(EmailAddress, CHARINDEX('@', EmailAddress) + 1, LEN(EmailAddress)) AS EmailDomain
FROM DimEmployee
where 
DepartmentName = 'Marketing'
AND EmailAddress LIKE '%@%'

--Bài tập 2: 
--Thay thế tên miền email của từng nhân viên phòng production thành production.com trong bảng DimEmployee 
SELECT
FirstName, 
LastName,
EmailAddress AS OldEmail,
-- Lấy phần tên trước dấu @ rồi nối với tên miền mới
LEFT(EmailAddress, CHARINDEX('@', EmailAddress)) + 'production.com' AS NewEmail
FROM DimEmployee
WHERE 
DepartmentName = 'Production'
AND EmailAddress LIKE '%@%'

--Bài tập 3
--Thêm một cột trong bảng Product theo logic: 
--Nếu có Color thì lấy phần trước dấu – của ProductAlternateKey 
--Nếu không có Color thì lấy phần sau dấu – của ProductAlternateKey 
SELECT 
EnglishProductName,
Color,
ProductAlternateKey,
CASE 
WHEN Color IS NOT NULL THEN LEFT(ProductAlternateKey, pos - 1)
ELSE SUBSTRING(ProductAlternateKey, pos + 1, LEN(ProductAlternateKey))
END AS NewProductCode
FROM DimProduct
CROSS APPLY (SELECT CHARINDEX('-', ProductAlternateKey) AS pos) AS p;

--Bài tập 4: (Nâng cao) 
--Tạo thêm một cột mới để chuẩn hóa lại Size của sản phẩm, theo quy tắc sau: 
--Nếu không có Size thì ghi là NULL 
--Nếu Size là chữ thì giữ nguyên 
--Nếu Size là số thì theo logic như sau: 
-- < 45 = S 

-- 45 – 50 = M 

-- 51 – 55 = L 

-- Còn lại là XL


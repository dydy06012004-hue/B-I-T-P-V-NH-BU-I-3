--Viết truy vấn để trả về bảng kết quả bao gồm các cột sau từ bảng DimAccount: AccountKey, AccountDescription, AccountType. 
USE[AdventureWorksDW2022]
GO
SELECT
AccountKey,
AccountDescription,
AccountType
from DimAccount;

--Viết truy vấn trả về bảng kết quả bao gồm các cột sau từ bảng DimCustomer: CustomerKey, FirstName, MiddleName, LastName, BirthDate, MaritalStatus, Gender, EmailAddress. 
select
CustomerKey,
FirstName,
MiddleName,
LastName,
--kết hợp các cột thành fullName
FirstName + ' ' + ISNULL(MiddleName + ' ', '') + LastName AS FullName,
BirthDate, 
MaritalStatus, 
Gender, 
EmailAddress
from dimcustomer;

--Truy vấn bảng FactInternetSales trả về các cột OrderDate, ProductKey, CustomerKey, SalesAmount, OrderQuantity, UnitPrice. Sắp xếp cột OrderDate theo thứ tự tăng dần 
Select
 OrderDate,
 ProductKey,
 CustomerKey, 
 SalesAmount, 
 OrderQuantity, 
 UnitPrice
from FactInternetSales
order by orderdate ASC;

-- Truy vấn bảng FactResellerSales trả về các cột OrderDate, ProductKey, CustomerPOnumber, SalesAmount, OrderQuantity, UnitPrice. Sắp xếp cột OrderDate theo thứ tự tăng dần và cột ProductKey theo thứ tự tăng dần và SalesAmount theo thứ tự giảm dần. 
SELECT
OrderDate,
ProductKey, 
CustomerPOnumber, 
SalesAmount, 
OrderQuantity,
UnitPrice
FROM FactResellerSales
ORDER BY 
OrderDate ASC,
ProductKey ASC, 
SalesAmount DESC;

--Truy vấn WHERE cơ bản 
--Viết truy vấn để lấy thông tin khách hàng có tên đầy đủ là Hannah E Long, Mason D Roberts, Jennifer S Cooper. Sắp xếp kết quả tăng dần theo BirthDate.
SELECT 
    CustomerKey, 
    FirstName, 
    MiddleName, 
    LastName, 
    FirstName + ' ' + ISNULL(MiddleName + ' ', '') + LastName AS FullName,
    BirthDate, 
    MaritalStatus, 
    Gender, 
    EmailAddress
FROM DimCustomer
WHERE 
    (FirstName + ' ' + ISNULL(MiddleName + ' ', '') + LastName) 
    IN ('Hannah E Long', 'Mason D Roberts', 'Jennifer S Cooper')
ORDER BY BirthDate ASC;

--Viết truy vấn thống tin về OrderDate, SalesOrderNumber, ProductKey, UnitPrice, OrderQuantity của bản ghi có ResellerKey = 322 trong bảng FactResellerSales. 
select
OrderDate,
SalesOrderNumber, 
ProductKey, 
UnitPrice, 
OrderQuantity 
from FactResellerSales
where ResellerKey = 322

--Viết truy vấn để lấy thông tin về chỉ số tài chính doanh nghiệp (bảng FactFinance) mà có AccountKey = 61
select*
from  FactFinance
where accountkey=61

--Hãy truy vấn ra những shift buổi sáng mà nhận nhiều hơn hoặc bằng 400 cuộc gọi trong bảng FactCallCenter. Sắp xếp cột Calls từ lớn xuống bé. 
select*
from FactCallCenter
where shift='am'
and callS >=400
order by calls DESC

-- Truy vấn trả về duy nhất cột những ngày mà nhận được IssuesRaised lớn hơn 2 
--và AverageTimePerIssue lớn hơn 60 trong bảng FactCallCenter 
SELECT DISTINCT DateKey
FROM FactCallCenter
WHERE
IssuesRaised >2 
AND AverageTimePerIssue>60

--Viết truy vấn trả về EnglishProductName, ProductKey, ListPrice và StandardCost của sản phẩm đáp ứng đủ các tiêu chí sau trong bảng DimProduct: 
--ListPrice bé hơn 50 
--Màu khác màu đen 
SELECT EnglishProductName, ProductKey, ListPrice, StandardCost
FROM DimProduct
WHERE ListPrice<50
AND COLOR<>'BLACK'

--Viết truy vấn trả về thông tin của nhân viên đáp ứng đầy đủ các tiêu chí sau trong bảng DimEmployee: 
-- Nhân viên có title là Sales Representative 
--Có SalesTerritoryKey bằng 10 hoặc 1 
SELECT 
employeekey,
title,
SalesTerritoryKey
FROM DIMEMPLOYEE
WHERE title='Sales Representative '
and (
SalesTerritoryKey =10
or SalesTerritoryKey =1
)

-- Bài tập về ORDER BY và TOP 
--Viết truy vấn trả về TOP 9 sản phẩm hiện tại vẫn đang bán mà có ListPrice lớn nhất thỏa mãn một trong các điều kiện sau trong bảng DimProduct: 
--Reorder point > 300 và Safety Stock > 400
--ListPrice nằm trong khoảng từ 100 - 300. 
select top 9 PRODUCTKEY,
productAlternatekey,
ReorderPoint,
SafetyStockLevel,
ListPrice
from DimProduct
where ( Reorderpoint > 300 AND SafetyStockLEVEL  > 400)
OR ( LISTPRICE BETWEEN 100 AND 300)
AND STATUS = 'CURRENT'
ORDER BY ListPrice DESC

--Bài tập về toán tử 
--Viết truy vấn trả về bảng kết quả có mẫu như dưới đây. Biết rằng, Gap Price được tính theo công thức: Gap Price = (ListPrice – DealerPrice) 
--Chỉ tính GapPrice cho những sản phẩm có thông tin màu sắc trong bảng DimProduct. 
--Sắp xếp kết quả theo GapPrice từ cao đến thấp. 
SELECT PRODUCTKEY,
(ListPrice - DealerPrice) * 1.1 AS 'GapPrice'
FROM DimProduct
WHERE Color <> 'NA'
ORDER BY (ListPrice - DealerPrice) * 1.1 DESC

--Đối với các đơn hàng giao đúng hạn được đặt vào năm 2012, 2013 của khách hàng doanh nghiệp, thực hiện tính toán các chỉ số sau: 
--Chi phí vận chuyển trên một đơn vị sản phẩm, biết chi phí vận chuyển là Freight 
--Tổng số tiền khách phải trả (SalesAmount + TaxAmt + Freight) 
--% thuế trên tổng số tiền khách phải trả, biết tiền thuế là TaxAmt 
--Lợi nhuận (SalesAmount - TotalProductCost) 
SELECT
Salesordernumber,
Freight,
(SalesAmount + TaxAmt + Freight) AS 'CustomerPayment',
( TaxAmt)/(SalesAmount + TaxAmt + Freight) AS '%Tax',
(SalesAmount - TotalProductCost) AS 'Profit',
ShipDate,
DueDate
FROM FactResellerSales
where orderdate between '2012-01-01' and '2013-12-31'
AND ShipDate < DueDate

--Bài tập về IN
--Truy vấn ra bảng kết quả bao gồm những khách hàng có học vấn là Partial High School hoặc High School hoặc Graduate Degree trong bảng DimCustomer 
SELECT*
FROM DimCustomer
where EnglishEducation In (
'Partial High School',
'High School',
'Graduate Degree'
)

--Truy vấn ra bảng kết quả bao gồm những khách hàng có học vấn là Partial High School hoặc High School hoặc Graduate Degree và đáp ứng một trong các điều kiện sau ở trong bảng DimCustomer 
--Có nghề (EnglishOccupation) là Professional và khoảng cách là 10+ Miles
--Có nghề là Clerical và khoảng cách là 0-1 Miles 
select*
from DimCustomer 
where englisheducation IN (
'Partial High School',
'High School',
'Graduate Degree'
)
AND ( 
(EnglishOccupation = 'Professional' AND COMMUTEdistance = '10+ Miles')
or
(EnglishOccupation='Clerical' and COMMUTEdistance ='0-1 Miles')
)

-- Truy vấn lồng với IN 
--Lấy danh sách khách hàng (CustomerKey) từ bảng DimCustomer có City nằm trong nhóm các thành phố đã từng có đơn hàng với SalesAmount > 2000 trong bảng FactInternetSales. 
select*
from DimCustomer
where GeographyKey IN (
select GeographyKey
FROM DimCustomer
	WHERE CustomerKey IN (
		SELECT CustomerKey
		FROM FactInternetSales
		WHERE SalesAmount > 2000)
);

--Trả về thông tin của top 5 sản phẩm bán chạy nhất màu đỏ có ListPrice > 500 
select TOP 5*
from dimproduct
where COLOR='RED'
AND ListPrice > 500 


-- 1.	Find customers who have ordered a product from BOTH the caps and the gloves categories. 
--		Display the customer ID, first name, last name, and email address.  
 
--      Include the code you used to determine the answer. 
--		Include a comment with the number of records returned.

USE [AdventureWorksDW2012];
SELECT DISTINCT dc.[CustomerKey], [FirstName], [LastName], [EmailAddress]
FROM [dbo].[DimCustomer] AS dc
WHERE EXISTS
(SELECT *
FROM [dbo].[FactInternetSales] AS fis
INNER JOIN [dbo].[DimProduct] AS dp ON dp.[ProductKey] = fis.[ProductKey]
WHERE dp.[ProductSubcategoryKey] = 19 AND fis.[CustomerKey] = dc.[CustomerKey])
AND EXISTS
(SELECT *
FROM [dbo].[FactInternetSales] AS fis
INNER JOIN [dbo].[DimProduct] AS dp ON dp.[ProductKey] = fis.[ProductKey]
WHERE dp.[ProductSubcategoryKey] = 20 AND fis.[CustomerKey] = dc.[CustomerKey])
ORDER BY [LastName], [FirstName]
--86 records

--------------------------------------------------------------------------------
-- 2.	Find customers who have *not* ordered a vest.  
--		Display the customer ID, first name, last name, and email address.  
 
--      Include the code you used to determine the answer. 
--		Include a comment with the number of records returned.

USE [AdventureWorksDW2012];
SELECT DISTINCT dc.[CustomerKey], [FirstName], [LastName], [EmailAddress]
FROM [dbo].[DimCustomer] AS dc
WHERE [CustomerKey] NOT IN
(SELECT DISTINCT [CustomerKey]
FROM [dbo].[FactInternetSales] AS fis
INNER JOIN [dbo].[DimProduct] AS dp ON dp.[ProductKey] = fis.[ProductKey]
WHERE dp.[ProductSubcategoryKey] = 25)
ORDER BY [LastName], [FirstName]
--17,927 records


---------------------------------------------------------------------------------
--	3.	Show the price of the cheapest gloves listed, the most expensive gloves
--		listed, and the average list price for gloves. Use one code statement
--		to simultaneously display all three of these data points (three columns).

--      Include the code you used to determine the answer. 
--		Include a comment with the number of records returned.

USE [AdventureWorksDW2012];
SELECT CAST(MIN([ListPrice]) AS DEC(20,2)) AS CheapestGloves, MAX([ListPrice]) AS MostExpensiveGloves, 
CAST(AVG([ListPrice]) AS DEC(20,2)) AvgListPrice
FROM [dbo].[DimProduct]
WHERE [ProductSubcategoryKey] = 20
--1 record 3 columns

----------------------------------------------------------------------------------
--	4.	List all products and the most recent date each product was ordered
--		in a reseller sale.

--      Include the code you used to determine the answer. 
--		Include a comment with the number of records returned.

USE [AdventureWorksDW2012];
SELECT dp.[ProductKey], [EnglishProductName], CONVERT(NVARCHAR, MAX([OrderDate]), 101) AS MostRecentOrderDate
FROM [dbo].[DimProduct] AS dp
INNER JOIN [dbo].[FactResellerSales] AS frs ON frs.[ProductKey] = dp.[ProductKey]
GROUP BY dp.[ProductKey], [EnglishProductName]
ORDER BY [EnglishProductName], 'MostRecentOrderDate'
--334 records (NOTE: I ran this same syntax without the product key and just the englishproduct name and got 250 records. I noticed that
--when I include the product key there are multiple different product keys associated with the same item/product which can be seen if
--you run this syntax. I'm guessing that maybe these products have some sort of different model/distinction to the product and that is
--the reason they have different product keys. Since the question is asking for all products I decided to include them in my answer 
--otherwise I might go with 250 records for my answer if they truly had no difference because that means I wouldn't be listing the same
--product multiple times.

-----------------------------------------------------------------------------------
--  5.	Show the count of customers, by country and by total children. 
--		Display english country region name, total children, and the 
--		corresponding count of customers.  

--      Include the code you used to determine the answer. 
--		Include a comment with the number of records returned.

USE [AdventureWorksDW2012];
SELECT [EnglishCountryRegionName], COUNT([CustomerKey]) AS NumOfCustomers, [TotalChildren]
FROM [dbo].[DimCustomer] AS dc
INNER JOIN [dbo].[DimGeography] AS dg ON dg.[GeographyKey] = dc.[GeographyKey]
GROUP BY [EnglishCountryRegionName], [TotalChildren]
ORDER BY [EnglishCountryRegionName], 'NumOfCustomers' DESC
--36 records 3 columns, (NOTE: By the wording of the question im guessing it is referring to the totalchildren column and not asking for
--SUM([TotalChildren]) otherwise I would have written the syntax differently for the total children part).

-------------------------------------------------------------------------------
--	6.	Find all employees who have vacation hours that are ABOVE the average 
--		number of vacation hours for all employees.  Display the employee key, 
--		first name, last name, and the vacation hours.  Include a comment with 
--		the number of records returned.
 
--      Include the code you used to determine the answer. 
--		Include a comment with the number of records returned.

USE [AdventureWorksDW2012];
SELECT [EmployeeKey], [FirstName], [LastName], [VacationHours]
FROM [dbo].[DimEmployee]
WHERE [VacationHours] >
(SELECT AVG([VacationHours])
FROM [dbo].[DimEmployee])
ORDER BY [LastName], [FirstName]
--147 records

---------------------------------------------------------------------------------------
--	7.	Show a list of customers who have placed more than 30 orders in a single year.
--		Show the year, customer key, first name, last name, and the number of orders.
 
--      Include the code you used to determine the answer. 
--		Include a comment with the number of records returned.

USE [AdventureWorksDW2012];
SELECT YEAR([OrderDate]) AS OrderYear, dc.[CustomerKey], [FirstName], [LastName], SUM([OrderQuantity]) AS NumberOfOrders
FROM [dbo].[DimCustomer] AS dc
INNER JOIN [dbo].[FactInternetSales] AS fis ON fis.[CustomerKey] = dc.[CustomerKey]
WHERE ([OrderDate] BETWEEN '2005-01-01' AND '2005-12-31') OR ([OrderDate] BETWEEN '2006-01-01' AND '2006-12-31')
OR ([OrderDate] BETWEEN '2007-01-01' AND '2007-12-31') OR ([OrderDate] BETWEEN '2008-01-01' AND '2008-12-31')
GROUP BY YEAR([OrderDate]), dc.[CustomerKey], [FirstName], [LastName]
HAVING SUM([OrderQuantity]) > 30
ORDER BY [LastName], 'OrderYear'
--12 records, I think this is one method/way to solve this question it definitely took some thinking.

----------------------------------------------------------------------------------------
----- End of File ---------------------------------------------------------------------
----------------------------------------------------------------------------------------
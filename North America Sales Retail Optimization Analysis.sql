SELECT * FROM [Sales Retail]
USE [North America Sales]

-- TO CREATE A DIMCUSTOMER TABLE FROM SALES TABLE
SELECT * INTO DIMCUSTOMER
FROM
	(SELECT Customer_ID, Customer_Name FROM [Sales Retail]) AS DimC

WITH CTE_DimC
AS (SELECT Customer_ID, Customer_Name, Row_number() OVER(PARTITION BY Customer_ID, Customer_Name ORDER BY Customer_ID ASC) As RowNum
FROM DIMCUSTOMER

DELETE CTE_DimC
WHERE RowNum > 1 --TO REMOVE DUPLICATES FROM THE DIMCUSTOMER

SELECT * FROM DIMCUSTOMER

--TO CREATE DIMLOCATION TABLE FROM THE SALES RETAILS TABLE
SELECT * INTO DIMLOCATION FROM (SELECT Postal_Code, Country, City, State, Region FROM [Sales Retail]) AS DimL

WITH CTE_DimL
AS (SELECT Postal_Code, Country, City, State, Region, ROW_NUMBER() OVER (PARTITION BY Postal_Code, Country, City, State, Region
	ORDER BY Postal_Code ASC) As RowNum 
		FROM DIMLOCATION
		)
DELETE FROM CTE_DimL
	WHERE RowNum > 1 --TO REMOVE DUPLICATES FROM THE DIMLOCATION

SELECT* FROM DIMLOCATION

--TO CREATE DIMPRODUCT FROM THE SALES RETAILS TABLES
SELECT * INTO DIMPRODUCT
	FROM (SELECT Product_ID, Category, Sub_Category, Product_Name FROM [Sales Retail]) AS DIM_P

SELECT * FROM DIMPRODUCT

WITH CTE_DimP
AS (SELECT Product_ID, Category, Sub_Category, Product_Name, ROW_NUMBER() OVER (PARTITION BY Product_ID, Category, Sub_Category, Product_Name
	ORDER BY Product_ID ASC) AS RowNum
	FROM DIMPRODUCT
	)
DELETE FROM CTE_DimP
	WHERE RowNum > 1 -- TO REMOVE DUPLICATES FROM THE DIMPRODUCT

--TO CREATE OUR SALESFACTTABLE
SELECT * INTO SALESFACTTABLE
	FROM (SELECT Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID, Segment, Postal_Code, 
	Retail_Sales_People, Product_ID, Returned, Sales, Quantity, Discount, Profit
		FROM [Sales Retail])
	AS ORDERFACT

	WITH CTE_OFT
	AS (SELECT Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID, Segment, Postal_Code, 

	Retail_Sales_People, Product_ID, Returned, Sales, Quantity, Discount, Profit,ROW_NUMBER () 

	OVER (PARTITION BY Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID, Segment, Postal_Code,
	
	Retail_Sales_People, Product_ID, Returned, Sales, Quantity, Discount, Profit ORDER BY Order_ID ASC) AS RowNum

	FROM SALESFACTTABLE)

	DELETE FROM CTE_OFT
	WHERE RowNum > 1
	SELECT * FROM SALESFACTTABLE

	SELECT * FROM DIMPRODUCT WHERE Product_ID ='FUR-FU-10004091'

	-- TO ADD A SURROGATE KEY CALLED PRODUCT KEY TO SERVE AS A UNIQUE IDENTIFIER FOR THE TABLE DIMPROCUCT
	ALTER TABLE DIMPRODUCT
	ADD Product_Key INT IDENTITY (1,1) PRIMARY KEY;

	SELECT * FROM DIMPRODUCT

	-- TO ADD A SURROGATE KEY CALLED PRODUCT KEY TO SALESFACTTABLE
	ALTER TABLE SALESFACTTABLE
	ADD Product_Key INT;

	UPDATE SALESFACTTABLE
	SET Product_Key = DIMPRODUCT.Product_Key
	FROM SALESFACTTABLE
	JOIN DIMPRODUCT
	ON SALESFACTTABLE.Product_ID = DIMPRODUCT.Product_ID
	
	--TO DROP THE PRODUCTID IN THE SALESFACTTABLE AND IN THE DIMPRODUCT TABLE

	ALTER TABLE DIMPRODUCT
	DROP COLUMN Product_ID 

	ALTER TABLE SALESFACTTABLE
	DROP COLUMN Product_ID

	SELECT * FROM SALESFACTTABLE
	WHERE Order_ID = 'CA-2014-102652'

	SELECT * FROM DIMPRODUCT

	-- TO ADD A UNIQUE IDENTIFIER TO THE SALESFACTTABLE
	ALTER TABLE SALESFACTTABLE
	ADD Row_ID INT IDENTITY (1,1)



	-- EXPLORATION ANALYSIS
	-- What was the Average delivery days for different product subcategory? 
	SELECT * FROM SALESFACTTABLE
	SELECT * FROM DIMPRODUCT

	SELECT Sub_Category, AVG(DATEDIFF(DAY, Order_Date, Ship_Date)) AS AvgDeliveryDays
	FROM SALESFACTTABLE AS oft
	LEFT JOIN DIMPRODUCT AS dp
	ON oft.Product_Key = dp.Product_Key
	GROUP BY dp.Sub_Category;
	/* It takes an average of 32 Days to deliver products in the chair and Bookcases Sub category,
	also and Average of 34 days to deliver products in the furnishings Sub-category 
	and an average of 36 Days to Deliver products in the Table Sub-category*/



-- What was the Average delivery days for each segment ?
 SELECT * FROM SALESFACTTABLE
 SELECT Segment,AVG(DATEDIFF(DAY, Order_Date, Ship_Date)) AS AvgDeliveryDays
 FROM SALESFACTTABLE
 GROUP BY Segment
 ORDER BY AvgDeliveryDays DESC
 /* It takes an average of 35 Delivery days to get products to the corporate customer segment,
 An average of 24 Delivery days to get products to the consumer customer segment,
 And an average of 31 Delivery days to get products across to the Home office cunstomer segment*/



 -- What are the Top 5 Fastest delivered products and Top 5 slowest delivered products?
 SELECT TOP 5 (Product_Name), (DATEDIFF(DAY, Order_Date, Ship_Date)) AS DeliveryDays
	FROM SALESFACTTABLE AS oft
	LEFT JOIN DIMPRODUCT AS dp
	ON oft.Product_Key = dp.Product_Key
	ORDER BY 2 ASC;
	/* The top 5 Fastest delivered products with 0 delivery days are;
Sauder Camden County Barrister Bookcase, Planked Cherry Finish
Sauder Inglewood Library Bookcases
O'Sullivan 2-Shelf Heavy-Duty Bookcases
O'Sullivan Plantations 2-Door Library in Landvery Oak
O'Sullivan Plantations 2-Door Library in Landvery Oak*/

SELECT TOP 5 (Product_Name), (DATEDIFF(DAY, Order_Date, Ship_Date)) AS DeliveryDays
	FROM SALESFACTTABLE AS oft
	LEFT JOIN DIMPRODUCT AS dp
	ON oft.Product_Key = dp.Product_Key
	ORDER BY 2 DESC;
	/* The top 5 Slowest delivered products with 214 delivery days are;
Bush Mission Pointe Library
Hon Multipurpose Stacking Arm Chairs
Global Ergonomic Managers Chair
Tensor Brushed Steel Torchiere Floor Lamp
Howard Miller 11-1/2" Diameter Brentwood Wall Clock*/



-- Which product Subcategory generate most profit?
SELECT * FROM SALESFACTTABLE
SELECT dp.Sub_Category, Round (SUM (oft.Profit),2) AS TotalProfit
	FROM SALESFACTTABLE AS oft
	LEFT JOIN DIMPRODUCT AS dp
	ON oft.Product_Key = dp.Product_Key
	WHERE oft.Profit > 0
	GROUP BY dp.Sub_Category
	ORDER BY 2 DESC;
	/* The Sub-Category Chairs generate the highest Profit with a Total of $36471.1
	while the least comes from Tables*/
	


	-- Which segment generates the most profit? 
	SELECT Segment, ROUND(SUM (Profit), 2) AS TotalProfit
	FROM SALESFACTTABLE
	WHERE Profit > 0
	GROUP BY Segment
	ORDER BY 2 DESC;

	/* The Consumer customer segment generates the highest Profit,
	while the Home office generates the least*/



	--Which Top 5 customers made the most profit?
	SELECT Top 5 (Customer_Name), ROUND(SUM (Profit), 2) AS TotalProfit
	FROM SALESFACTTABLE
	LEFT JOIN DIMCUSTOMER
	ON SALESFACTTABLE.Customer_ID = DIMCUSTOMER.Customer_ID
	WHERE Profit > 0
	GROUP BY Customer_Name
	ORDER BY 2 DESC;

	/*The Top 5 Customers generating the highest Profits are
	Laura Armstrong
	Joe Elijah
	Seth Vernon
	Quincy Jones
	Maria Etezadi*/



	-- What is the total number of products by Subcategory?
	SELECT Sub_Category, COUNT(DISTINCT Product_Name) AS TotalProduct
	FROM DIMPRODUCT
	GROUP BY Sub_Category;
	
/*The Total Product for each Sub-category are 48,87,184,34 for Bookcases, Chairs, Furninshings, Tables respectively*/
# North America Sales Retail Optimisation Analysis
## Project Overview
North America Retail is a major company as it offers a wide range of products to Different customers in various locations. Their main focus is to provide Outstanding customer service which inturn enhancing excellent shopping experience. This Analysis is made to understand the sales and provide majorly, insights on the Profitability and the overall Business performance of the Company.


## Data Source
The Dataset used is Retail supply chain Analysis.csv

## Tools Used
- SQL

## Data Cleaning and Preparation
- Data Importation and Inspection
- Data-splitting Into Fact and Dimension Tables

## Exploratory Analysis
1. What was the Average delivery days for different product subcategory?  
2. What was the Average delivery days for each segment ? 
3. What are the Top 5 Fastest delivered products and Top 5 slowest delivered products?   
4. Which product Subcategory generate most profit?
5. Which segment generates the most profit?
6. Which Top 5 customers made the most profit?
7. What is the total number of products by Subcategory?

## Data Analysis
### 1. What was the Average delivery days for different product subcategory?
```sql
  SELECT Sub_Category, AVG(DATEDIFF(DAY, Order_Date, Ship_Date)) AS AvgDeliveryDays
	FROM SALESFACTTABLE AS oft
	LEFT JOIN DIMPRODUCT AS dp
	ON oft.Product_Key = dp.Product_Key
	GROUP BY dp.Sub_Category;
	/* It takes an average of 32 Days to deliver products in the chair and Bookcases Sub category,
	also and Average of 34 days to deliver products in the furnishings Sub-category 
	and an average of 36 Days to Deliver products in the Table Sub-category*/
```
### 2. What was the Average delivery days for each segment ?
```sql
 SELECT * FROM SALESFACTTABLE
 SELECT Segment,AVG(DATEDIFF(DAY, Order_Date, Ship_Date)) AS AvgDeliveryDays
 FROM SALESFACTTABLE
 GROUP BY Segment
 ORDER BY AvgDeliveryDays DESC
 /* It takes an average of 35 Delivery days to get products to the corporate customer segment,
 An average of 24 Delivery days to get products to the consumer customer segment,
 And an average of 31 Delivery days to get products across to the Home office cunstomer segment*/
```
### 3. What are the Top 5 Fastest delivered products and Top 5 slowest delivered products?
```sql
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
```
### 4. Which product Subcategory generate most profit?
```sql
  SELECT dp.Sub_Category, Round (SUM (oft.Profit),2) AS TotalProfit
	FROM SALESFACTTABLE AS oft
	LEFT JOIN DIMPRODUCT AS dp
	ON oft.Product_Key = dp.Product_Key
	WHERE oft.Profit > 0
	GROUP BY dp.Sub_Category
	ORDER BY 2 DESC;
	/* The Sub-Category Chairs generate the highest Profit with a Total of $36471.1
	while the least comes from Tables*/
```
### 5. Which segment generates the most profit?
```sql
  SELECT Segment, ROUND(SUM (Profit), 2) AS TotalProfit
	FROM SALESFACTTABLE
	WHERE Profit > 0
	GROUP BY Segment
	ORDER BY 2 DESC;
	/* The Consumer customer segment generates the highest Profit,
	while the Home office generates the least*/
```
### 6. Which Top 5 customers made the most profit?
```sql
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
```
### 7. What is the total number of products by Subcategory?
```sql
  SELECT Sub_Category, COUNT(DISTINCT Product_Name) AS TotalProduct
	FROM DIMPRODUCT
	GROUP BY Sub_Category;
  /*The Total Product for each Sub-category are 48,87,184,34 for Bookcases, Chairs, Furninshings, Tables respectively*/
```
## Result/Findings
#### Average Delivery Days Analysis
The analysis of delivery times across product subcategories revealed notable differences. On average, Chairs and Bookcases took approximately 32 days to be delivered, while Furnishings required 34 days and Tables had the longest wait time at 36 days.

Similarly, when analyzing delivery times across customer segments, Corporate customers experienced the longest delivery times, averaging 35 days. Home Office customers had a slightly shorter average wait time of 31 days, while Consumer customers benefited from the fastest deliveries, receiving their orders in just 24 days on average.

#### Delivery Speed Analysis
Further exploration into delivery efficiency highlighted the top five fastest and slowest-delivered products. The fastest-delivered products had an astonishing 0-day delivery time, meaning they did not take up to a day to be delivered. These products included:

- Sauder Camden County Barrister Bookcase
- O'Sullivan 2-Shelf Heavy-Duty Bookcases

Conversely, the slowest-delivered products took up to 214 days to reach customers. Some of the slowest-moving items included:

- Bush Mission Pointe Library
- Hon Multipurpose Stacking Arm Chairs

#### Profitability Analysis
A profitability analysis across different product subcategories and customer segments provided key insights into revenue generation. Among product categories, Chairs proved to be the most profitable, generating a total of $36,471.1 in profit, while Tables contributed the least profit.

When examining customer segments, Consumer customers accounted for the highest profits, while the Home Office segment yielded the least profit. Additionally, an evaluation of customer profitability identified the top five most profitable customers, which included:

- Laura Armstrong
- Joe Elijah
- Seth Vernon
- Quincy Jones
- Maria Etezadi

#### Product Distribution Analysis
The distribution of distinct products across subcategories revealed the following breakdown:

- Bookcases: 48 unique products
- Chairs: 87 unique products
- Furnishings: 184 unique products
- Tables: 34 unique products

## Recommendations
I recommend that the company:
- Optimizes Delivery Time – Reduce delays in Tables and Furnishings by improving inventory management, logistics, and offering priority shipping.
- Improves Corporate & Home Office Deliveries – Provide bulk order incentives and collaborate with reliable logistics providers.
- Boosts High-Profit Subcategories – Focus marketing on Chairs while reassessing pricing and costs for Tables.
- Retains High-Value Customers – Implement loyalty programs, personalized marketing, and dedicated account management.
- Expands Consumer Segment Engagement – Strengthen digital marketing, offer bundle discounts, and partner with office suppliers.
- Ensures Stock Availability – Monitor sales trends and automate restocking for high-demand products.
## Challenges
The major Challenge was introducing Surrogate key to the Fact table and the Dimension Product-table because there were two different Products that shared the same unique identifier (Primay key) and i could not eaily Connect the Entity Relationship Diagram (ERD).

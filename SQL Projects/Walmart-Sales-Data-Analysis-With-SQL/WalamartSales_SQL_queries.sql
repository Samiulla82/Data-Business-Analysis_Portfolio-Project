CREATE DATABASE walmartSales

USE walmartSales

SELECT * FROM WalmartSalesData

---Cloned Data Table from Original Table "WalmartSalesData"
SELECT * INTO SalesData FROM WalmartSalesData



-- --------------------------------------------------------------------
-- ----------------------------- Generic -------------------------------
-- --------------------------------------------------------------------

--How many unique cities does the data have?
SELECT COUNT(DISTINCT City) AS Num_Cities
FROM SalesData

--In which city is each branch?
SELECT Branch,City     
FROM SalesData;  


-- --------------------------------------------------------------------
-- ----------------------------- Product --------------------------------
-- --------------------------------------------------------------------

--How many unique product lines does the data have?
SELECT COUNT(DISTINCT Product_line) AS unique_product_lines
FROM SalesData



--What is the most common payment method?
SELECT TOP (1) Payment, COUNT(*) AS payment_count
	FROM SalesData
	GROUP BY Payment
	ORDER BY payment_count DESC

--What is the most selling product line?
SELECT TOP(1) Product_line, SUM(Quantity) AS total_quantity_sold
FROM SalesData
GROUP BY Product_line
ORDER BY total_quantity_sold DESC

--Creating Revenue coulumn 
SELECT unit_price * Quantity + Tax_5 FROM SalesData

--What is the total revenue by month?

SELECT DATENAME(MONTH, Date), SUM(Revenue)AS total_revenue
FROM SalesData
GROUP BY DATENAME(MONTH, Date)
ORDER BY total_revenue DESC

---OR-- 
SELECT MONTH(Date) AS months, SUM(Revenue) AS total_revenue 
FROM SalesData
GROUP BY MONTH(Date)
ORDER BY total_revenue DESC


--What month had the largest COGS?

SELECT TOP(1) MONTH(Date)AS Month_Num, SUM(cogs) AS total_cogs 
FROM SalesData
GROUP BY MONTH(Date)
ORDER BY total_cogs DESC

--OR With CTE

WITH CTE1 AS (

SELECT FORMAT(Date,'yyyy-MMM') as Month, -- Converts the datetime to the full month name 
SUM(cogs) AS total_cogs  -- Replace COGS with the actual column name for Cost of Goods Sold
FROM SalesData 
GROUP BY FORMAT(Date,'yyyy-MMM') -- Groups by year and month to handle multiple years

)

SELECT TOP(1) Month, total_cogs FROM CTE1
ORDER BY total_cogs DESC;
 



--What product line had the largest revenue?

SELECT TOP(1) Product_line, 
	SUM(Revenue) AS total_revenue 
FROM SalesData
GROUP BY Product_line
ORDER BY total_revenue DESC




--What is the city with the largest revenue?

SELECT TOP(1) City, Sum(Revenue) AS total_revenue
 FROM SalesData
	GROUP BY City
	ORDER BY total_revenue DESC


--What product line had the largest VAT?

SELECT TOP(1) Product_line, SUM(Tax_5) Total_VAT
	FROM SalesData
	GROUP BY Product_line 
	ORDER BY Total_VAT DESC

	

--Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales


--With CTE 

WITH AverageRevenue AS (

SELECT AVG(Total_Revenue) AS Avg_Revenue
FROM (
		SELECT Product_line, SUM(Revenue) AS Total_Revenue
		FROM SalesData
		GROUP BY Product_line
	   ) AS t
),

--53827.79
ProductLineSales AS (

SELECT Product_line, SUM(revenue) AS Total_Revenue
FROM SalesData
GROUP by Product_line
)

--ProductLine ,Total Revenue Agreggeted

--Main Query
SELECT p.Product_line, p.Total_Revenue,
		CASE
		WHEN p.Total_Revenue > a.Avg_Revenue THEN 'Good'
		ELSE 'Bad'
		END as Remark
FROM ProductLineSales p
CROSS JOIN AverageRevenue a;



------This Main Query performs a cross join between ProductLineSales and AverageRevenue. 
----The result is a Cartesian product where each row from ProductLineSales is paired with the single row from AverageRevenue.
------Since AverageRevenue has only one row (the average revenue), 
----this cross join effectively attaches this single average value to each product line.


--Which branch sold more products than average product sold?

SELECT Branch, SUM(Quantity) Total_Sold
FROM SalesData
GROUP BY Branch
HAVING SUM(Quantity)> (
						SELECT AVG(Total_Sold) AS Avg_Product_Sold
						FROM (
								SELECT Branch, SUM(Quantity) Total_Sold
								FROM SalesData
								GROUP BY Branch
												) AS t
						);


--with CTE

WITH AverageProductsSold AS (
	SELECT AVG(Total_Sold) AS Avg_Products
	FROM (
			SELECT  branch, SUM(Quantity) AS Total_Sold 
			FROM SalesData
			GROUP BY branch
		
		   ) AS BranchTotalsAvg
),

BranchSales AS (
    SELECT Branch, SUM(Quantity) AS Total_Products
    FROM SalesData
    GROUP BY Branch
)

SELECT b.Branch, b.Total_Products, a.Avg_Products
FROM BranchSales AS b
CROSS JOIN AverageProductsSold AS a
WHERE b.Total_Products > a.Avg_Products; 




--What is the most common product line by gender?

WITH CTE1  AS (
SELECT Gender, Product_line, COUNT(*) AS ProductLineCount 
FROM SalesData
GROUP BY Gender, Product_line
),

RankedProductLines AS (
SELECT Gender, Product_line, ProductLineCount,
RANK() OVER(PARTITION BY Gender Order BY ProductLineCount DESC) AS rank
FROM CTE1
)

SELECT Gender, Product_line
FROM RankedProductLines
WHERE rank = 1




--What is the average rating of each product line?

SELECT Product_line, ROUND(AVG(Rating),1) AS Average_Rating FROM SalesData
GROUP BY Product_line
ORDER BY Average_Rating DESC;



-- --------------------------------------------------------------------
-- --------------------------------------------------------------------
-- --------------------------------------------------------------------
-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------


--Number of sales made in each time of the day per weekday

SELECT 
    CASE
        WHEN DATEPART(HOUR, Time) BETWEEN 0 AND 5 THEN 'Late Night'
        WHEN DATEPART(HOUR, Time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, Time) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN DATEPART(HOUR, Time) BETWEEN 18 AND 23 THEN 'Evening'
    END AS TimeOfDay,
    COUNT(*) AS NumberOfSales
FROM SalesData
GROUP BY 
    CASE
        WHEN DATEPART(HOUR, Time) BETWEEN 0 AND 5 THEN 'Late Night'
        WHEN DATEPART(HOUR, Time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, Time) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN DATEPART(HOUR, Time) BETWEEN 18 AND 23 THEN 'Evening'
    END
ORDER BY 
    TimeOfDay;




--Which of the customer types brings the most revenue?
SELECT TOP(1) Customer_type, sum(revenue) Total_Revenue
FROM SalesData
GROUP BY Customer_type
order by Total_Revenue DESC

--Which city has the largest tax percent/ VAT (Value Added Tax)?

SELECT 
    City,
    MAX(Tax_5 / Revenue * 100) AS Max_VAT_Percent
FROM SalesData
GROUP BY City
ORDER BY Max_VAT_Percent DESC;

--Which customer type pays the most in VAT?

SELECT TOP(1) Customer_type, SUM(Tax_5) Total_VAT
FROM SalesData
GROUP BY Customer_type
ORDER BY SUM(Tax_5) DESC



-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------

--How many unique customer types does the data have?

SELECT COUNT(DISTINCT Customer_type) AS UniqueCustomerTypes
FROM salesData


--How many unique payment methods does the data have?
SELECT COUNT(DISTINCT Payment) as UniquePaymentMethods
FROM SalesData

--What is the most common customer type?
SELECT TOP(1) Customer_type, COUNT(*) CountOfCustomerType
FROM SalesData
GROUP BY Customer_type
ORDER BY CountOfCustomerType DESC

--Which customer type buys the most?
SELECT TOP(1) Customer_type, COUNT(DISTINCT Invoice_ID) Count_Of_Invoice_ID
FROM SalesData
GROUP BY Customer_type
ORDER BY Count_Of_Invoice_ID DESC


--What is the gender of most of the customers?
SELECT TOP(1) Gender, COUNT(DISTINCT Invoice_ID) AS Count_Of_Invoice_ID
FROM SalesData
GROUP BY Gender
ORDER BY Count_Of_Invoice_ID DESC


--What is the gender distribution per branch?

SELECT Branch, Gender, COUNT(*) AS Num_Gender
FROM SalesData
GROUP BY Branch, Gender
ORDER BY Branch, Num_Gender DESC 

--Which time of the day do customers give most ratings?


SELECT TOP(1)
    CASE
        WHEN DATEPART(HOUR, Time) BETWEEN 0 AND 5 THEN 'Late Night'
        WHEN DATEPART(HOUR, Time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, Time) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN DATEPART(HOUR, Time) BETWEEN 18 AND 23 THEN 'Evening'
    END AS TimeOfDay,
    COUNT(Rating) AS NumberOfRatings  
FROM SalesData
GROUP BY 
    CASE
        WHEN DATEPART(HOUR, Time) BETWEEN 0 AND 5 THEN 'Late Night'
        WHEN DATEPART(HOUR, Time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, Time) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN DATEPART(HOUR, Time) BETWEEN 18 AND 23 THEN 'Evening'
    END
ORDER BY 
    NumberOfRatings DESC;



--Which time of the day do customers give most ratings per branch?

WITH RankedRatings AS (
    SELECT 
        Branch,   
        CASE
            WHEN DATEPART(HOUR, Time) BETWEEN 0 AND 5 THEN 'Late Night'
            WHEN DATEPART(HOUR, Time) BETWEEN 6 AND 11 THEN 'Morning'
            WHEN DATEPART(HOUR, Time) BETWEEN 12 AND 17 THEN 'Afternoon'
            WHEN DATEPART(HOUR, Time) BETWEEN 18 AND 23 THEN 'Evening'
        END AS TimeOfDay,
        COUNT(Rating) AS NumberOfRatings,  
        ROW_NUMBER() OVER (PARTITION BY Branch ORDER BY COUNT(Rating) DESC) AS rn
    FROM SalesData
    GROUP BY 
        Branch,
        CASE
            WHEN DATEPART(HOUR, Time) BETWEEN 0 AND 5 THEN 'Late Night'
            WHEN DATEPART(HOUR, Time) BETWEEN 6 AND 11 THEN 'Morning'
            WHEN DATEPART(HOUR, Time) BETWEEN 12 AND 17 THEN 'Afternoon'
            WHEN DATEPART(HOUR, Time) BETWEEN 18 AND 23 THEN 'Evening'
        END
)
SELECT 
    Branch, 
    TimeOfDay, 
    NumberOfRatings
FROM RankedRatings
WHERE rn = 1
ORDER BY Branch;

--Which day for the week has the best avg ratings?



SELECT TOP(1) DATENAME(WEEKDAY, Date) AS Weekday, AVG(Rating) AS AvgRating
FROM SalesData
GROUP BY DATENAME(WEEKDAY, Date)
ORDER BY AvgRating DESC


-----------------------------



--Which day of the week has the best average ratings per branch?

WITH AvgRatingByDay AS(

SELECT Branch, DATENAME(WEEKDAY, Date) AS Weekday, AVG(rating) AS AvgRating
FROM SalesData
GROUP BY Branch, DATENAME(WEEKDAY, Date)

),
RankedDays AS(

SELECT Branch, Weekday, AvgRating,
Rank() OVER(PARTITION BY Branch ORDER BY AvgRating DESC ) AS rn
FROM AvgRatingByDay
)

SELECT Branch, Weekday, AvgRating
FROM RankedDays
WHERE rn<2




---------------------------------------------------------------------------------------------
-------------------Revenue And Profit Calculations-----------------------------------------
---------------------------------------------------------------------------------------------

--$ COGS = unitsPrice * quantity $

--$ VAT = 5% * COGS $
--A value-added tax (VAT or goods and services tax (GST), general consumption tax (GCT)), is a consumption tax that is levied on the value added at each stage of a product's production and distribution.

--Cost of goods sold (COGS) is the cost of acquiring or manufacturing the products or finished goods that a company then sells  0during a period.
 
--$  Revenue(gross_sales) = VAT + COGS $

--$ grossProfit(grossIncome) = Revenue(gross_sales) - COGS $

--Gross Margin is gross profit expressed in percentage of the total(gross profit/revenue)

--$ \text{Gross Margin} = \frac{\text{gross income}}{\text{total revenue}} $

--Example with the first Record OR row in our DataBase:
--Data given:

--$ \text{Unite Price} = 45.79 $
--$ \text{Quantity} = 7 $
--$ COGS = 45.79 * 7 = 320.53 $

--$ \text{VAT} = 5% * COGS\= 5% 320.53 = 16.0265 $

--$ total = VAT + COGS\= 16.0265 + 320.53 = 
--336.5565

--$ \text{Gross Margin Percentage} = \frac{\text{gross income}}{\text{total revenue}}\=\frac{16.0265}{336.5565} = 0.047619\\approx 4.7619% $


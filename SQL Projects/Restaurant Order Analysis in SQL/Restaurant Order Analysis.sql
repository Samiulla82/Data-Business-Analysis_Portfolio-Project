--Analyze restaurant order and customer data in SQL in this beginner-level Guided Project!

--The goal is to solve a pre-defined series of tasks and objectives, designed to simulate the exact types of problems that data professionals encounter on the job.

--------------------------------The assignment:---------------------------
--The Taste of the World Cafe debuted a new menu at the start of the year.

--You've been asked to dig into the customer data to see which menu items are doing well/not well and what the top customers seem to like best.

---------------------The objectives:-------------------------
--1.	Explore the menu_items table to get an idea of what's on the new menu.
--2.	Explore the order_details table to get an idea of the data that's been collected.
--3.	Use both tables to understand how customers are reacting to the new menu.

SELECT * FROM menu_items;
SELECT * FROM order_details;


--------------------------OBJECTIVE 1:-------------------------------------

---EXPLORE THE ITEMS TABLE---------------------------- 

--1.View the menu _items table.
SELECT * FROM menu_items;

--2. Find the number of items on the menu. 

SELECT Count(DISTINCT menu_item_id) AS num_of_Items FROM menu_items 


--3.What are the least and most expensive items on the menu? 

SELECT * FROM menu_items
WHERE price = (SELECT MIN(price) FROM menu_items)

SELECT * FROM menu_items
WHERE price = (SELECT MAX(price) FROM menu_items)



--4.How many Italian dishes are on the menu?

SELECT Count(*) Num_of_Italian_Dishes FROM menu_items
WHERE category='Italian'




--5.What are the least and most expensive Italian dishes on the menu?

SELECT * FROM menu_items
WHERE category='Italian'
ORDER BY price ASC;

SELECT * FROM menu_items
WHERE category = 'Italian'
ORDER BY price DESC;

----OR-----

SELECT category, MIN(price) AS Least_Price_Italian_Food, ROUND(MAX(price),2) AS Expensive_Italian_Least_Price
FROM menu_items 
WHERE category ='Italian'
GROUP BY category

--6.How many dishes are in each category?

SELECT category, COUNT(*) AS num_items_Categ FROM menu_items
GROUP BY category;

--7. What is the average dish price within each category? 

SELECT category, AVG(price) avg_dish_price FROM menu_items
GROUP BY category;



--------------------------OBJECTIVE 2:----------------------------------

--EXPLORE THE ORDERS TABLE---------------------------------

--8. View the order_details table. 

SELECT * FROM order_details


--9. What is the date range of the table? 

SELECT  MIN(order_date) First_order_date, MAX(order_date) Last_order_date FROM order_details



--10- How many orders were made within this date range? 

SELECT COUNT(DISTINCT order_id) FROM order_details




--11. How many items were ordered within this date range? 

SELECT COUNT(DISTINCT order_details_id)  FROM order_details




--12. Which orders had the most number of items? 

SELECT order_id, COUNT(order_details_id) AS Num_items FROM order_details
GROUP BY order_id
ORDER BY Num_items DESC




--13. How many orders had more than 12 items? 

SELECT COUNT(*)AS Num_order FROM

(SELECT order_id, COUNT(item_id) AS Num_items
FROM order_details
GROUP BY order_id
HAVING COUNT(item_id) > 12 ) AS Num_orders   




--------------------------OBJECTIVE 3:----------------------------------

--ANALYZE CUSTOMER BEHAVIOR---------------------------------

 
--14. Combine the menu_items and order_details tables into a single table. 

SELECT * FROM menu_items AS t3
JOIN order_details AS t4 ON t3.menu_item_id= t4.item_id



--15. What were the least and most ordered items, What categories were they in? 

SELECT m1.item_name, m1.category, COUNT(*) As Num_items FROM menu_items m1
JOIN order_details  o1 ON m1.menu_item_id= o1.item_id
GROUP BY  category, item_name
ORDER BY Num_items ASC;

SELECT m1.item_name, m1.category, COUNT(*) As Num_items FROM menu_items m1
JOIN order_details  o1 ON m1.menu_item_id= o1.item_id
GROUP BY  category, item_name
ORDER BY Num_items DESC;

--16. What were the top 5 orders that spent the most money? 

SELECT TOP(5) od.order_id, SUM(price) Top_purchases FROM order_details AS od
LEFT JOIN menu_items AS mi
  ON od.item_id= mi.menu_item_id
  GROUP BY od.order_id
  ORDER BY Top_purchases DESC;



--17. View the details of the highest spend order, What insights can you gather from the results 


SELECT category, COUNT(*) Num_items , ROUND(SUM(price),1) Total_spend  FROM order_details od
LEFT JOIN menu_items mi
ON item_id=menu_item_id
WHERE order_id = 440
GROUP BY category




--18.View the details of the top 5 highest spend orders,  What insights can you gather from the results?

SELECT TOP(5) od.order_id, SUM(price) Top_purchases FROM order_details AS od
LEFT JOIN menu_items AS mi
  ON od.item_id= mi.menu_item_id
  GROUP BY od.order_id
  ORDER BY Top_purchases DESC;

  SELECT order_id,category, COUNT(*) Num_items  FROM order_details od
LEFT JOIN menu_items mi
ON item_id=menu_item_id
WHERE order_id IN (440,2075,1957,330,265)
GROUP BY category, order_id
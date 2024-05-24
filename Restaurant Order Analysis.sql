USE RESTAURANT_DB;
-- EXPLORE ITEMS TABLE
-- View the menu_items table
SELECT * FROM menu_items;

-- Find number of items on menu
SELECT COUNT(*) AS number_of_items_on_menu FROM menu_items;

-- least and most expesive items on the menu
SELECT mi.item_name, mi.category, mi.price AS least_expensive_dish FROM menu_items mi WHERE mi.price = (SELECT MIN(price) FROM menu_items) LIMIT 1;
SELECT mi.item_name, mi.category, mi.price AS most_expensive_dish FROM menu_items mi WHERE mi.price = (SELECT MAX(PRICE) FROM menu_items) LIMIT 1;

-- number of italian dishes on the menu
SELECT COUNT(category) FROM menu_items WHERE category = "Italian" ORDER BY price;

-- least and most expensive italian dishes
SELECT mi.item_name, mi.category, mi.price AS least_expensive_dish FROM menu_items mi WHERE mi.price = (SELECT MIN(price) FROM menu_items WHERE category = "Italian") LIMIT 1;
SELECT mi.item_name, mi.category, mi.price AS most_expensive_dish FROM menu_items mi WHERE mi.price = (SELECT MAX(price) FROM menu_items WHERE category = "Italian") LIMIT 1;

-- number of dishes in each category
SELECT category, COUNT(menu_item_id) AS num_dishes FROM menu_items GROUP BY category;

-- average dish price within each category   
SELECT category, ROUND(AVG(price),3) AS average_price FROM menu_items GROUP BY category;

-- EXPLORE ORDERS TABLE
-- view order_details table
SELECT * FROM order_details;

-- date range of the table
SELECT MIN(order_date) AS Start_Date, MAX(order_date) AS End_Date FROM order_details;

-- orders made within date range
SELECT COUNT(DISTINCT order_id) FROM order_details;

-- number of items ordered during date range
SELECT COUNT(*) FROM order_details;

-- which orders had most number of items
SELECT order_id, COUNT(item_id) AS num_items FROM order_details GROUP BY order_id ORDER BY num_items DESC;

-- how many orders had more that 12 items
SELECT COUNT(*) FROM (SELECT order_id, COUNT(item_id) AS num_items FROM order_details GROUP BY order_id HAVING num_items > 12) AS num_orders;

-- ANALYZE CUSTOMER BEHAVIOUR
-- combine menu_items and order_details tables into single table 
SELECT * FROM order_details od LEFT JOIN menu_items mi ON mi.menu_item_id = od.item_id;

-- least and most ordered items
SELECT mi.item_name, COUNT(od.order_details_id) AS num_purchases FROM order_details od LEFT JOIN menu_items mi ON mi.menu_item_id = od.item_id GROUP BY item_name ORDER BY num_purchases;
SELECT mi.item_name, COUNT(od.order_details_id) AS num_purchases FROM order_details od LEFT JOIN menu_items mi ON mi.menu_item_id = od.item_id GROUP BY item_name ORDER BY num_purchases DESC;

-- categories of least and most ordered items
SELECT mi.item_name, COUNT(od.order_details_id) AS num_purchases, mi.category FROM order_details od LEFT JOIN menu_items mi ON mi.menu_item_id = od.item_id GROUP BY item_name, category ORDER BY num_purchases;
SELECT mi.item_name, COUNT(od.order_details_id) AS num_purchases, mi.category FROM order_details od LEFT JOIN menu_items mi ON mi.menu_item_id = od.item_id GROUP BY item_name, category ORDER BY num_purchases DESC;

-- top 5 orders that spent the most money
SELECT od.order_id, SUM(mi.price) AS total_spending FROM order_details od LEFT JOIN menu_items mi ON mi.menu_item_id = od.item_id GROUP BY od.order_id ORDER BY total_spending DESC LIMIT 5;

-- view details of highest spend order and which specific items were purchased 
SELECT category, SUM(price), COUNT(item_name) FROM order_details od LEFT JOIN menu_items mi ON mi.menu_item_id = od.item_id WHERE order_id = 440 GROUP BY category;

-- view details of top 5 highest spend orders
SELECT order_id, category, SUM(price), COUNT(item_name) FROM order_details od LEFT JOIN menu_items mi ON mi.menu_item_id = od.item_id WHERE order_id IN (440, 2075, 1957, 330, 2675) GROUP BY order_id, category;

-- FINAL QUESTION
-- how much was the most expensive order in the dataset?
SELECT order_id, SUM(price) AS total_price FROM order_details od LEFT JOIN menu_items mi ON mi.menu_item_id = od.item_id GROUP BY order_id ORDER BY total_price DESC LIMIT 1;

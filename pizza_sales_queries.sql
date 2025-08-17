-- ================================
-- Pizza Sales Analysis Project SQL
-- ================================

-- 1. Total Revenue:
SELECT SUM(total_price) AS Total_Revenue 
FROM pizza_sales_excel_file;

-- 2. Average Order Value:
SELECT SUM(total_price) / COUNT(DISTINCT order_id) AS Avg_order 
FROM pizza_sales_excel_file;

-- 3. Total Pizzas Sold:
SELECT SUM(quantity) AS Total_pizzas 
FROM pizza_sales_excel_file;

-- 4. Total Orders:
SELECT COUNT(DISTINCT order_id) AS Total_Orders 
FROM pizza_sales_excel_file;

-- 5. Average Pizzas per Order:
SELECT SUM(quantity) / COUNT(DISTINCT order_id) AS Avg_Pizza 
FROM pizza_sales_excel_file;

-- ================================
-- CHART REQUIREMENTS
-- ================================

-- 1. Daily Trend for Total Orders (Bar Chart)
SELECT 
    DAYNAME(order_date) AS order_day, 
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales_excel_file
WHERE (order_date) IS NOT NULL
GROUP BY DAYOFWEEK(order_date), 
         DAYNAME(order_date)
ORDER BY DAYOFWEEK(order_date);

-- 2. Monthly Trend for Total Orders (Line Chart)

-- Method 1: Ensuring proper month order
SELECT 
    m.month_name,
    IFNULL(t.Total_orders, 0) AS Total_orders
FROM (
    SELECT 1 AS month_num,  'January' AS month_name UNION
    SELECT 2, 'February' UNION
    SELECT 3, 'March' UNION
    SELECT 4, 'April' UNION
    SELECT 5, 'May' UNION
    SELECT 6, 'June' UNION
    SELECT 7, 'July' UNION
    SELECT 8, 'August' UNION
    SELECT 9, 'September' UNION
    SELECT 10, 'October' UNION
    SELECT 11, 'November' UNION
    SELECT 12, 'December'
) AS m
LEFT JOIN (
    SELECT 
        MONTH(order_date) AS month_num,
        COUNT(DISTINCT order_id) AS Total_orders
    FROM pizza_sales_excel_file
    WHERE (order_date) IS NOT NULL
    GROUP BY MONTH(order_date)
) AS t
ON m.month_num = t.month_num
ORDER BY m.month_num;

-- Method 2: Simple version (alphabetical month issue)
SELECT 
    MONTHNAME(order_date) AS Month_name,
    COUNT(DISTINCT order_id) AS Total_orders
FROM pizza_sales_excel_file
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date), 
         MONTHNAME(order_date)
ORDER BY MONTH(order_date);

-- 3. Percentage of Sales by Pizza Category (Pie Chart)
SELECT 
    pizza_category, 
    SUM(total_price) AS Total_Sales, 
    ROUND(SUM(total_price) * 100 / 
          (SELECT SUM(total_price) 
           FROM pizza_sales_excel_file
           WHERE MONTH(order_date) = 1), 2) AS PCT
FROM pizza_sales_excel_file
WHERE MONTH(order_date) = 1
GROUP BY pizza_category;

-- 4. Percentage of Sales by Pizza Size (Pie Chart)
SELECT 
    pizza_size, 
    ROUND(SUM(total_price), 2) AS Total_Sales,
    ROUND(SUM(total_price) * 100 / 
          (SELECT SUM(total_price) 
           FROM pizza_sales_excel_file
           WHERE QUARTER(order_date) = 1), 2) AS PCT
FROM pizza_sales_excel_file
WHERE QUARTER(order_date) = 1
GROUP BY pizza_size
ORDER BY PCT DESC;

-- 5. Total Pizzas Sold by Pizza Category (Funnel Chart)
SELECT 
    pizza_category,
    SUM(quantity) AS Total_Pizzas_Sold
FROM pizza_sales_excel_file
WHERE pizza_category IS NOT NULL
GROUP BY pizza_category
ORDER BY Total_Pizzas_Sold DESC;

-- 6. Top 5 Best Sellers by Revenue, Quantity, Orders (Bar Chart)
SELECT 
    pizza_name, 
    SUM(total_price) AS Total_Revenue,
    SUM(quantity) AS Total_Quantity,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales_excel_file
GROUP BY pizza_name
ORDER BY Total_Revenue DESC, Total_Quantity DESC, Total_Orders DESC
LIMIT 5;

-- Alternative: Break into 3 queries if you want separate ranking by each metric

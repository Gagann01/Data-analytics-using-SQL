/*                           PIZZA SALES ANALYSIS
                                                               Author- Gagan Kumar 
														
*/

-- KPI's Requirement 
-- Total Revenue
select sum(order_details.quantity * pizzas.price)
AS Total_Revenue
from order_details
left join pizzas on order_details.pizza_id = pizzas.pizza_id;

--Average order value 
select sum(pizzas.price)/count(distinct order_details.order_id)
from order_details 
left join pizzas on order_details.pizza_id = pizzas.pizza_id;

-- Total Pizza Sold
select sum(quantity) AS Total_pizza_sold
from order_details ;

-- Total Orders
select count(distinct(order_id))AS Total_orders
from orders;

--Average Pizza Per Order
select cast(cast(sum(quantity)AS decimal (10,2))/
cast(count(distinct order_id)AS decimal(10,2)) as decimal(10,2))
as Avg_pizza_per_order
from order_details;

select * from order_details;
select * from orders;
select * from pizza_types;
select * from pizzas;


-- Chart's Requirement 
-- Sector wise analysis
-- create can create a view of the tales to extract insights easily.
-- >>
create view Pizza_Sales_view AS 
select t1.order_id,t1.pizza_id, t2.order_date, t2.order_time,
t3.pizza_name,t1.quantity, t4.price, t4.pizza_size, t3.pizza_ingredients, t3.pizza_category
from order_details t1
join orders t2 on t1.order_id = t2.order_id 
join pizzas t4 on t1.pizza_id = t4.pizza_id 
join pizza_types t3 on t4.pizza_type_id = t3.pizza_type_id ;

select * from pizza_sales_view;

-- Sales performance analysis 
--  What is the average unit price and revenue of pizza across different categories?
-- >>
select pizza_category, avg(price) AS Avg_unit_price,
sum(quantity*price) AS Total_revenue
from pizza_sales_view
group by pizza_category 
order by Total_revenue desc;

-- What is the average unit price and revenue of pizza across different sizes?
-- >>
select pizza_size, avg(price) AS Avg_unit_price,
sum(quantity*price) AS Total_revenue
from pizza_sales_view
group by pizza_size
order by Total_revenue desc;

-- What is the average unit price and revenue of most sold 3 pizzas?
-- >>
select pizza_name,avg(price) AS Avg_unit_price,
sum(quantity*price) As Revenue
from pizza_sales_view
group by pizza_name
order by revenue 
limit 3;


-- Seasonal Analysis
-- Which days of the week having the highest number of orders?
-- >>
select to_char(order_date, 'day') AS Day_of_week,
count(*) AS order_count
from pizza_sales_view
group by Day_of_week
order by order_count desc ;

-- At what time most of the orders have occurred?
-- >>
select to_char(order_time, 'hh24:mi:ss') AS Day_of_time,
count(*) As order_count 
from pizza_sales_view
group by Day_of_time
order by order_count desc
limit 8 ;

-- Which month has highest revenue?
-- >>
select to_char(order_date, 'month') As Month ,
sum(quantity*price) AS Revenue 
from pizza_sales_view
group by Month
order by Revenue desc
limit 1 ;

-- which season has highest revenue?
-- >>
select
 case 
    when to_char(order_date,'month') in ('March','April','May') then 'Spring'
	when to_char(order_date, 'month') in ('June','July','August') then 'Summer'
	when to_char(order_date, 'month') in ('September','october','november') then 'Fall'
 else 'winter'
 end AS Seasons,
sum(quantity*price) AS Highest_revenue
from pizza_sales_view
group by Seasons
order by Highest_revenue
limit 1;


-- Customer behavior analysis 
-- Which is the favourite pizza of customers (most ordered pizza)?
-- >>
select pizza_name As pizza_name,count(distinct order_id) AS order_count
from pizza_sales_view
group by pizza_name
order by order_count desc
limit 1;

-- Which pizza size is preferred by cutomers?
-- >>
select pizza_size AS pizza_size,avg(price) AS avg_unit_price,
count(distinct order_id) AS order_count
from pizza_sales_view
group by pizza_size
order by order_count
limit 1 ;


-- Pizza analysis 
-- Pizza with the least price 
-- >>
select pizza_name as lowest_priced_Pizza, price as price 
from pizza_sales_view
order by price asc
limit 1 ;

-- pizza with highest price
-- >>
select pizza_name as highest_priced_Pizza, price as price 
from pizza_sales_view
order by price desc
limit 1 ;

-- number of pizza's sold per category
-- >>
select pizza_category AS pizza_category,
count(distinct order_id) AS Number_of_pizza_sold
from pizza_sales_view
group by pizza_category
order by Number_of_pizza_sold desc;

-- Number of pizzas per pizza_size
-- >>
select pizza_size AS pizza_size,
count(distinct order_id) AS Number_of_pizza_sold
from pizza_sales_view
group by pizza_size
order by Number_of_pizza_sold desc;


-- Pizza's with more than one category
-- >>
select pizza_name AS pizza_name,
count(distinct pizza_category) AS category_count
from pizza_sales_view
group by pizza_name
having count(distinct pizza_category)>1;

 




------------✅ Beginner Level (Basic Exploration)-----
create database bike_store;
use bike_store;

show tables;

#How many rows are in the brands table?
select count(*) from brands;

#What are the column names and data types in the table?
desc brands;

#Are there any duplicate brand_id values?
select brand_id, count(*) as count_id
from brands
group by brand_id 
having count(*)>1;

#How many customers are there in total?
select count(customer_id) as total_customers
from customers;

#How many unique brands are there in the products table?
select distinct product_name from products;

#What are the different categories in the categories table?
select distinct category_name from categories ;

#Find the earliest and latest order dates in the orders table.
select order_date as orderss 
from orders 
order by orderss desc; #---------IT WILL ALSO WORK------

select 
max(order_date) as latest_order ,
min(order_date) as earliest_order
from orders;

#List all stores with their store_id and store_name.
select store_id,store_name 
from stores;

#-----------------------INTERMEDIATE LEVEL ------------------------------
#For each brand, count how many products are under it.

select brand_name, count(product_id) as total_product_count
from brands left join products
on brands.brand_id = products.brand_id
group by brand_name;

#What is the average, min, and max list_price of products in each category?
SELECT 
    c.category_name,
    ROUND(AVG(p.list_price), 2) AS avg_price,
    MIN(p.list_price) AS min_price,
    MAX(p.list_price) AS max_price
FROM products p
JOIN categories c 
    ON p.category_id = c.category_id
GROUP BY c.category_name;

#Which customer has placed the most orders?

select first_name , last_name,count(order_id) as total_orders
from customers 
join orders
on customers.customer_id = orders.customer_id
group by  first_name,last_name
order by total_orders desc
limit 1;

#Which staff member handled the most distinct orders?

select staffs.staff_id,staffs.first_name,staffs.last_name,count(distinct order_id) as total_orders
from orders join staffs
on staffs.staff_id = orders.staff_id
group by staff_id,staffs.first_name,staffs.last_name
order by total_orders desc
limit 1;


#What is the monthly order volume (number of orders) for the past year?

select year(order_date) as order_year,
		month(order_date) as order_month,
        count(order_id)
from orders
where order_date >= curdate() - interval 12 month
group by order_year,order_month
order by order_year,order_month ;
#------------WE CAN SOLVE WITH USING 2 DIFFERNET WHERE CLAUSE----------

select year(order_date) as order_year,
       month(order_date) as order_month,
       count(order_id) as total_orders
from orders
where order_date >= date_sub(curdate(), interval 1 year)
group by order_year, order_month
order by order_year, order_month;

select * from order_items join stores;


# for each store, compute the total revenue (sum of unit_price * quantity) from all order items.

select s.store_name,
       sum(p.list_price * oi.quantity) as revenue
from order_items oi
join products p on oi.product_id = p.product_id
join orders o on oi.order_id = o.order_id
join stores s on o.store_id = s.store_id
group by s.store_name;

#Which products are never ordered?

select p.product_name
from products p
left join order_items oi on p.product_id = oi.product_id
where oi.product_id is null;

#------⭐ Advanced Level (Complex Queries / Insights)----------------

#Find the top 5 customers by revenue (total money spent), along with their names and total spend.

SELECT 
    c.first_name,
    c.last_name,
    SUM(oi.list_price * oi.quantity) AS revenue
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY revenue DESC
LIMIT 5;


# identify products whose price is significantly higher than the category average 
#---(e.g. more than 1.5× category average).---

SELECT 
    p.product_name,
    c.category_name,
    p.list_price,
    cat_stats.avg_price,
    ROUND(p.list_price / cat_stats.avg_price, 2) AS price_ratio
FROM products p
JOIN categories c 
    ON p.category_id = c.category_id
JOIN (
    SELECT category_id, AVG(list_price) AS avg_price
    FROM products
    GROUP BY category_id
) cat_stats
    ON p.category_id = cat_stats.category_id
WHERE p.list_price > 1.5 * cat_stats.avg_price
ORDER BY price_ratio DESC;

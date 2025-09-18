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

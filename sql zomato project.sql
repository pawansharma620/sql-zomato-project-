create database zomato;

use zomato;

/*1.We’ll use these key tables:

restaurants – Info about restaurants

customers – Info about users/customers

orders – Orders placed by customers

order_items – Dishes in each order

dishes – Menu items

ratings – Customer ratings and reviews
*/


CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50),
    cuisine_type VARCHAR(50),
    average_cost INT
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    signup_date DATE
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

CREATE TABLE dishes (
    dish_id INT PRIMARY KEY,
    restaurant_id INT,
    name VARCHAR(100),
    price DECIMAL(6,2),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    dish_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (dish_id) REFERENCES dishes(dish_id)
);

CREATE TABLE ratings (
    rating_id INT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review TEXT,
    rating_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);



INSERT INTO restaurants (restaurant_id, name, city, cuisine_type, average_cost) VALUES
(1, 'Domino’s Pizza', 'Mumbai', 'Pizza', 300),
(2, 'Biryani Blues', 'Delhi', 'Biryani', 250),
(3, 'Barbeque Nation', 'Bangalore', 'Grill', 600),
(4, 'Haldiram’s', 'Delhi', 'Indian', 200),
(5, 'KFC', 'Mumbai', 'Fried Chicken', 350);

select* from restaurants;

INSERT INTO customers (customer_id, name, email, signup_date) VALUES
(1, 'Amit Sharma', 'amit@example.com', '2023-01-15'),
(2, 'Sneha Kapoor', 'sneha@example.com', '2023-05-20'),
(3, 'Rahul Mehta', 'rahul@example.com', '2024-02-10'),
(4, 'Priya Desai', 'priya@example.com', '2024-06-01'),
(5, 'Karan Yadav', 'karan@example.com', '2022-12-01');

select* from customers;


INSERT INTO orders (order_id, customer_id, restaurant_id, order_date, total_amount) VALUES
(101, 1, 1, '2024-05-01', 600.00),
(102, 2, 2, '2024-05-03', 300.00),
(103, 3, 3, '2024-06-01', 1200.00),
(104, 4, 4, '2024-06-03', 250.00),
(105, 1, 5, '2024-06-05', 700.00),
(106, 2, 1, '2024-06-06', 400.00),
(107, 3, 2, '2024-06-07', 280.00);

select* from orders;

INSERT INTO dishes (dish_id, restaurant_id, name, price) VALUES
(1, 1, 'Veg Pizza', 300.00),
(2, 1, 'Cheese Burst', 350.00),
(3, 2, 'Chicken Biryani', 250.00),
(4, 3, 'Grilled Paneer', 600.00),
(5, 4, 'Chole Bhature', 200.00),
(6, 5, 'Zinger Burger', 350.00),
(7, 2, 'Mutton Biryani', 280.00),
(8, 3, 'Grilled Chicken', 650.00);


select* from dishes;


INSERT INTO order_items (order_item_id, order_id, dish_id, quantity) VALUES
(1, 101, 1, 1),
(2, 101, 2, 1),
(3, 102, 3, 1),
(4, 103, 4, 2),
(5, 104, 5, 1),
(6, 105, 6, 2),
(7, 106, 1, 1),
(8, 106, 2, 1),
(9, 107, 7, 1);

select* from order_items;

INSERT INTO ratings (rating_id, customer_id, restaurant_id, rating, review, rating_date) VALUES
(1, 1, 1, 5, 'Excellent pizza!', '2024-05-01'),
(2, 2, 2, 4, 'Good biryani.', '2024-05-04'),
(3, 3, 3, 5, 'Loved the grill.', '2024-06-02'),
(4, 4, 4, 3, 'Decent food.', '2024-06-04'),
(5, 1, 5, 4, 'Crispy chicken, yum!', '2024-06-06');

select * from ratings;


-- QUESTATION

-- 1.list ALL restaurant in mumbai.

select* from restaurants where city='mumbai';

-- 2.  Show all dishes offered by 'Domino’s Pizza'.

select d.*
from dishes d
join restaurants r on d.restaurant_id= r.restaurant_id
where r.name="domino's pizza";

-- 3. Find all orders placed after 1st May 2024.

select* from orders where order_date >2024-05-01;

-- 4.Count the number of customers who signed up in 2023.

select count(*) as total_customers_2023 from customers
where year(signup_date) =2023;

-- 5.Get the total amount of each order.

select order_id, total_amount from orders;

-- 6.List the top 5 most expensive dishes across all restaurants.

select* from dishes order by price desc limit 5;

-- 7.show total sale per restaurant.

select r.name as restaurant_name , sum(o.total_amount) as total_sale
from orders o
join restaurants r on o.restaurant_id= r.restaurant_id
group by r.name;

-- 8.List restaurants along with their average customer rating.

select r.name as restaurant_name, avg(rt.rating) as avg_rating
from ratings rt
join restaurants r on rt.restaurant_id=r.restaurant_id
group by r.name;

-- 9. Find customers who ordered more than 3 times.

select c.name, count(o.order_id) as total_orders
from orders o
join customers c on o.customer_id=c.customer_id
group by c.name
having count(o.order_id)>3;

-- 10. Which dishes were ordered more than 100 times?

select d.name ,sum(oi.quantity) as total_quantity
from order_items oi
join dishes d on oi. dish_id=d.dish_id
group by d.name
having sum(oi.quantity)>100;

-- 11. Which dishes were ordered more than 100 times?

select c.name
from customers c
left join ratings rt on c.customer_id=rt.customer_id
where rt.rating is null;


-- 12.Find restaurants with more than 50 orders and average rating > 4.


select r.name 
from restaurants r
join orders o on r.restaurant_id=o.restaurant_id
join ratings rt on r.restaurant_id=rt.restaurant_id
group by r.name
having count(o.order_id) and avg(rt.rating)>4;

-- 13.Rank restaurants in each city by total sales.


select city,name,total_sales,
      rank() over(partition by city order by total_sales desc) as city_rank
from (
select r.city,r.name ,sum(o.total_amount) as total_sales
from orders o
join restaurants r on o.restaurant_id=r.restaurant_id
group by r.city,r.name
) ranked_sales;


-- 14. Find the top 3 most popular dishes per restaurant

select *
from(
 select r.name as restaurant_name, d.name as dish_name, sum(oi.quantity) as total_order,
          row_number() over (partition by r.restaurant_id order by sum(oi.quantity) desc)as rn
          from order_items oi
          join deshes d on oi.dish_id=d.dish_id
          join restaurants r on d.restaurant_id=r.restaurant_id
          group by r.name,d.name,restaurant_id
          )t
          where rn <=3;
          
-- 15.Monthly revenue trend (last 6 months)

          
SELECT 
    DATE_FORMAT(order_date, '%y-%M') AS month,
    SUM(total_amount) AS monthly_sales
FROM orders
WHERE order_date >= CURDATE() - INTERVAL 6 MONTH
GROUP BY DATE_FORMAT(order_date, '%y-%M')
ORDER BY month;

-- 16. Average number of items per order (using CTE)

WITH item_counts AS (
  SELECT order_id, SUM(quantity) AS total_items
  FROM order_items
  GROUP BY order_id
)
SELECT AVG(total_items) AS avg_items_per_order FROM item_counts;

-- 17.Running total of sales per restaurant

select r.name, o.order_date, o.total_amount,
           sum(o.total_amount) over (partition by r.restaurant_id order by o.order_date) as running_total
 from orders o
 join restaurants r on o.restaurant_id=r.restaurant_id;
 
 -- 18. Stored Procedure: Daily sales summary (example for MySQL)
 
 delimiter //
 
 create procedure daily_sales_summary(in sales_date date)
 begin
      select r.name as restaurant, sum(o.total_amount)as total_sales
      from orders o
      join restaurants r on o.restaurant_id=r.restaurant_id
      where order_date=sales_date
      group by r.name;
      end;
delimiter //      


-- 19. 
      
      
 
 



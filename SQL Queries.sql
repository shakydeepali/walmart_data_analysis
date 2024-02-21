 Create DATABASE Walmartsales_data;
 USe Walmartsales_data;
 Create table  sales(
       invoice_id varchar(30) Not null PRIMARY KEY,
       branch varchar(5) not null,
       city varchar(30) not null,
       customer_type varchar (30) not null,
       gender varchar (10) not null,
       product_line varchar (100) not null,
       unit_price decimal(10,2) not null,
       quantity int not null,
       vat float(6,4) not null,
       total decimal(12,4) not null,
       date DATETIME not null,
       time TIME not null,
       payment_method varchar (15) not null,
       cogs decimal(10,2) not null,
       gross_margin_pct float(11,9),
       gross_income decimal(12.4) not null,
       rating float(2,1)
	);
 select* from walmartsales_data.sales;  
 
 
 
-- ---------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------Feature Engineering-----------------------------------------------------------------------

-- time_of_day 

select 
   time,
   (case
      when `time` between "00:00:00" and "12:00:00" then "Morning"
      when `time` between "12:01:00" and "16:00:00" then "Afternoon"
      Else "Evening"
   end) As time_of_day
from sales;
   
 alter table sales add column time_of_day varchar(20);
 
 update sales 
 set time_of_day =(
   case
      when `time` between "00:00:00" and "12:00:00" then "Morning"
      when `time` between "12:01:00" and "16:00:00" then "Afternoon"
      Else "Evening"
   end
);

-- day_name
select
     date,
     dayname(date) as day_name
from sales;

 alter table sales add column day_name varchar(10);
 
 update sales
 set day_name = dayname(date);
 
 -- month_name
 select
    date,
    monthname(date)
from sales;

alter table sales add column month_name varchar(10);
 
 update sales
 set month_name =monthname(date);
 
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------- Generic --------------------------------------------------------------------------------------------------------------------

-- How many unique cities does the data have?
select 
  distinct city
from sales;
  
-- In which city is each branch?
select 
  distinct branch
from sales;

select 
   distinct city,
   branch
from sales;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------Product-------------------------------------------------------------------------------------------------

-- How many unique product lines does the data have?
select 
    count(distinct product_line)
from sales;

-- What is the most common payment method?
select
   payment_method ,
   count(payment_method) as cnt
from sales 
group by payment_method
order by cnt desc;

-- What is the most selling product line?
select 
    product_line,
    count(product_line) as cnt
from sales
group by product_line
order by cnt desc;

-- What is the total revenue by month?
select 
    month_name as month,
    sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

-- What month had the largest COGS?
select 
   month_name as month,
   sum(cogs) as cogs
from sales
group by month_name
order by cogs desc;

-- What product line has the lasrgest revenue?
select
    product_line,
    sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

-- What is the city with the largest revenue?
select
    city,branch,
    sum(total) as total_revenue
from sales
group by city,branch
order by total_revenue desc;

-- What product line had the largest VAT?
select 
   product_line,
   avg(VAT) as avg_tax
from sales
group by product_line
order by avg_tax desc;

-- Fetch each product line and add a column to those product line showing 
-- "Good","Bad". Good if its greater than average sales.alter

-- Which branch sold more product than average product sold?
select
    branch,
    sum(quantity) as qty
from sales
group by branch
having sum(quantity)>(select avg(quantity) from(sales));

-- What is the most common product line by gender?
select 
	gender,
    product_line,
    count(gender) as total_cnt
from sales
group by gender, product_line
order by total_cnt desc;

-- what is the average rating of each product line?
select
   round(avg(rating),2) as avg_rating,
   product_line
from sales
group by product_line
order by avg_rating desc;

-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------- Sales ---------------------------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday.
select 
    time_of_day,
    count(*) as total_sales
from sales
where day_name = "monday"
group by time_of_day
order by total_sales desc;
-- Which of the customer types brings the most revenue?
select
    customer_type,
    sum(total) as total_revenue
from sales
group by customer_type
order by total_revenue desc;
-- Which city has the largest tax percent/VAT(Value added tax)?
select 
    city,
    avg(vat) as VAT
from sales
group by city
order by VAT desc;
    
-- Which customer type pays the most in VAT?
select 
    customer_type,
    avg(VAT) as VAT
from sales
group by customer_type
order by VAT desc;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------- Customer --------------------------------------------------------------------------------------

-- How many unique customer types does the data have?
select 
    distinct customer_type
from sales;

-- How many unique payment methods does the data have?
select 
    distinct payment_method
from sales;

-- What is the most common customer type?
select
	customer_type,
    count(customer_type) as common_cnt
from sales
group by customer_type
order by common_cnt desc;


-- Which customer type buys the most?
select
	customer_type,
    count(*) as cstm_cnt
from sales
group by customer_type;
    
-- What is the gender of the most of the customer?
select
   gender,
   count(*) as gender_cnt
from sales
group by gender
order by gender_cnt desc;
   
-- What is the gender distribution per branch?
select
   gender,
   count(*) as gender_cnt
from sales
where branch ="c"
group by gender
order by gender_cnt desc; 
    
 -- Which time of the day do customer give most rating?
 Select 
      time_of_day,
      avg(rating) as avg_rating
from sales
group by time_of_day
order by avg_rating;

-- Which time of the day do customer give most ratings per branch?
 Select 
      time_of_day,
      avg(rating) as avg_rating
from sales
where branch ="A"
group by time_of_day
order by avg_rating; 

-- Which day for the week has the best avg ratings?
select
   day_name,
   avg(rating) as avg_rating
from sales
group by day_name
order by avg_rating desc;
-- Which day of the week has the best average ratings per branch?
select
   day_name,
   avg(rating) as avg_rating
from sales
where branch ="B"
group by day_name
order by avg_rating desc;

 


       
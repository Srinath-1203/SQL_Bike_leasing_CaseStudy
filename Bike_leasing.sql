
--1. Emily would like to know how many bikes the shop owns by category. Can
--you get this for her? 
--Display the category name and the number of bikes the shop owns in
--each category (call this column number_of_bikes ). Show only the categories
--where the number of bikes is greater than 2 

select count(id) as number_of_bikes,category
from bike
group by category
having count(id) >2
---------------------------------------------------------------------------------------------
--2. Emily needs a list of customer names with the total number of
--memberships purchased by each.
--For each customer, display the customer's name and the count of
--memberships purchased (call this column membership_count ). Sort the
--results by membership_count , starting with the customer who has purchased
--the highest number of memberships.
--Keep in mind that some customers may not have purchased any
--memberships yet. In such a situation, display 0 for the membership_count '

select c.name,count(membership_type_id) as membership_count
from customer c left join membership m on m.customer_Id=c.Id
group by c.name
order by count(membership_type_id) desc
------------------------------------------------------------------------------------------
--3. Emily is working on a special offer for the winter months. Can you help her to
--prepare a list of new rental prices?
--For each bike, display its ID, category, old price per hour (call this column 
--old_price_per_hour ), discounted price per hour (call it new_price_per_hour ), old
--price per day (call it old_price_per_day ), and discounted price per day (call it
--new_price_per_day ).
--Electric bikes should have a 10% discount for hourly rentals and a 20%
--discount for daily rentals. Mountain bikes should have a 20% discount for
--hourly rentals and a 50% discount for daily rentals. All other bikes should
--have a 50% discount for all types of rentals.
--Round the new prices to 2 decimal digits.

select id,model,category,price_per_hour as old_price_per_hour, case
when category='electric'
then round(price_per_hour-(price_per_hour*0.10),2)
when category='mountain bike' 
then round(price_per_hour-(price_per_hour*0.20),2) 
else round(price_per_hour-(price_per_hour*0.50),2)
end as new_price_per_hour,
price_per_day as old_price_per_day,
case 
when category='electric'
then round(price_per_day-(price_per_day*0.20),2)
when category='mountain bike' 
then round(price_per_day-(price_per_day*0.50),2)
else round(price_per_day-(price_per_day*0.50),2)
end as new_price_per_day
from bike
-----------------------------------------------------------------------------------------------------
--4. Emily is looking for counts of the rented bikes and of the available bikes 
--each category.
--Display the number of available bikes (call this column as
--available_bikes_count ) and the number of rented bikes (call this column as
--rented_bikes_count ) by bike category
 


select category,count(case when status='available' then 1 end) as available_bikes_count,
count(case when status='rented' then 1 end) as rented_bikes_count
from bike
group by category
----------------------------------------------------------------------------------------------
5. Emily is preparing a sales report. She needs to know the total reven
from rentals by month, the total by year, and the all-time across all the
years. 
Bike rental shop  SQL Case study 
Display the total revenue from rentals for each month, the total for each
year, and the total across all the years. Do not take memberships into
account. There should be 3 columns: year , month , and revenue .
Sort the results chronologically. Display the year total after all the month
totals for the corresponding year. Show the all-time total as the last row.
The resulting table looks something like this:
year month revenue
2022 11 200.00
2022 12 150.00
2022 null 350.00
2023 1 110.00
...
2023 10 335.00
2023 null 1370.00
null null 1720.00


select extract(year from start_timestamp) as year,
extract(month from start_timestamp) as month,sum(total_paid)
from rental
group by year,month
union all
select extract(year from start_timestamp) as year,null as month,sum(total_paid)
from rental
group by year
union all
select null as year,null as month,sum(total_paid)
from rental
group by ()
order by year,month
------------------------------------------------------
select extract(year from start_timestamp) as year
, extract(month from start_timestamp) as month
,sum(total_paid) as revenue
from rental
group by grouping sets((year,month),(year),())
order by year,month

  --You can use any of the query above


  
--6. Emily has asked you to get the total revenue from memberships for each
--combination of year, month, and membership type.
--Display the year, the month, the name of the membership type (call this
--column membership_type_name ), and the total revenue (call this column 
--total_revenue ) for every combination of year, month, and membership type.
--Sort the results by year, month, and name of membership type.//

select extract(year from m.start_date) as year,
extract (month from m.start_date) as month,
mt.name as membership_type_name, 
sum(total_paid)as total_revenue
from membership m join membership_type mt on m.membership_type_id=mt.id
group by year,month, mt.name
order by year,month, mt.name
--------------------------------------------------------------------------------------
--7. Next, Emily would like data about memberships purchased in 2023, with
--subtotals and grand totals for all the different combinations of membership
--types and months.
--Display the total revenue from memberships purchased in 2023 for each
--combination of month and membership type. Generate subtotals and
--grand totals for all possible combinations. There should be 3 columns: 
--membership_type_name , month , and total_revenue .
--Sort the results by membership type name alphabetically and then 
--chronologically by month

select mt.name as member_ship_type_name,
extract(month from start_date) as month ,
sum(total_paid) as total_revenue
from membership m 
join membership_type mt on m.membership_type_id=mt.id
where extract (year from start_date)=2023 
group by cube(mt.name,month)
order by member_ship_type_name asc,month


select mt.name as membership_type_name
, extract(month from start_date) as month
, sum(total_paid) as total_revenue
from membership m
join membership_type mt on m.membership_type_id = mt.id
where extract(year from start_date) = 2023
group by CUBE(membership_type_name, month)
order by membership_type_name, month;


--You can use any of the query above




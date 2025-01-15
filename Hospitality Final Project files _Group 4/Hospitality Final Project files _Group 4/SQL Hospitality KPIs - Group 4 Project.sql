use hospitalty_project_group_4;
select * from dim_hotels;
show tables;
# Hospitality Project Group- 4
# 1. Total Revenue
select * from fact_bookings;
select sum(revenue_generated)as Total_Revenue from fact_bookings;

# 2. Occupancy
Select * from fact_aggregated_bookings;
select property_id, sum(successful_bookings) * 100.0 / sum(capacity) as Occupancy_Rate
from fact_aggregated_bookings group by property_id;

# 3. Cancellation Rate
Select * from fact_bookings;
SELECT count(*) * 100.0 / (select count(*) from fact_bookings) as Cancellation_Rate
from fact_bookings where booking_status = 'Cancelled';

# 4. Total Bookings
select * from fact_bookings;
select count(booking_id) as Total_Bookings
from fact_bookings;

# 5. Utilize capacity 
select * from fact_aggregated_bookings;
select property_id, sum(successful_bookings) * 100.0 / sum(capacity) as Utilization_Rate
from fact_aggregated_bookings group by property_id;

# 6. Trend Analysis (Weekly)
select * from fact_bookings;
select * from dim_date;
desc dim_date;

# change column name
alter table dim_date
change column `week no` week_no text;

# replace W from Week column
UPDATE dim_date
SET week_no = REPLACE(week_no, 'W ', '');

# update the column with the correct DATE values
UPDATE dim_date
SET date = STR_TO_DATE(date, '%d-%b-%y');

# alter the column to the DATE data type
ALTER TABLE dim_date
MODIFY date DATE;

select distinct b.week_no, sum(a.revenue_generated) as Weekly_Revenue
from fact_bookings a left join dim_date b on a.check_in_date = b.date
group by b.week_no order by b.week_no;

# 6. Trend Analysis (Monthly)
select distinct extract(month from b.date) as Month,  ##  Extracting the month from the date column
sum(a.revenue_generated) as Monthly_Revenue from fact_bookings a
left join dim_date b on a.check_in_date = b.date
group by extract(month from b.date)
order by extract(month from b.date);

# 7. Weekday & Weekend Revenue and Booking
select * from fact_bookings;
select * from dim_date;

select b.day_type, sum(a.revenue_generated) as Total_Revenue,
count(a.booking_id) as Total_Bookings from fact_bookings a
join dim_date b on a.check_in_date = b.date
group by b.day_type;

# 8. Revenue by State & hotel 
select * from dim_hotels;

alter table dim_hotels
add state varchar(100);

update dim_hotels
set state = case 
when city = 'Delhi' then 'Delhi'
when city = 'Mumbai' then 'Maharashtra'
when city = 'Hyderabad' then 'Telangana'
when city = 'Bangalore' then 'Karnataka'
else 'Unknown State'
end;

select b.state,b.property_name, sum(a.revenue_generated) as Total_Revenue
from fact_bookings a
join dim_hotels b on a.property_id = b.property_id
group by b.state, b.property_name;


# 9. Class Wise Revenue

select * from dim_rooms;
select * from fact_bookings;

select b.room_class, sum(a.revenue_generated) as Total_Revenue from fact_bookings a
join dim_rooms b on a.room_category = b.room_id 
group by b.room_class;

# 10. Checked-Out, Cancelled, and No-show Status
select * from fact_bookings;

select booking_status, count(booking_status) as Count from fact_bookings
where booking_status in ('Checked Out', 'Cancelled', 'No show')
group by booking_status;

# 11 Weekly trend Key trend (Revenue, Total booking, Occupancy) 
select * from fact_bookings;
select distinct c.week_no, sum(b.revenue_generated) as Total_Revenue, count(b.booking_id) as Total_Bookings,
sum(a.successful_bookings) *100.0 /sum(a.capacity)  as Occupancy
from fact_bookings b join dim_date c on b.check_in_date = c.date
join fact_aggregated_bookings a on b.property_id = a.property_id
group by c.week_no order by c.week_no;


select c.week_no, sum(b.revenue_generated) as Total_Revenue, count(b.booking_id) as Total_Bookings
from fact_bookings b join dim_date c on b.check_in_date = c.date
group by c.week_no order by c.week_no;

SELECT COUNT(*) 
FROM fact_bookings b
JOIN fact_aggregated_bookings a ON b.property_id = a.property_id;

SELECT DISTINCT c.week_no 
FROM dim_date c;
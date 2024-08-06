use zomato;
set SQL_SAFE_UPDATES = 0;
select * from table1;
select * from table2;
update table1
Set Datekey_Opening = replace(Datekey_Opening,"_","-");
ALTER TABLE table1  
MODIFY Datekey_Opening date;
ALTER TABLE table1 RENAME COLUMN Average_Cost_for_two TO Pricefor2;

#------------------------------ IMPORTANT_VALUES------------------#
select count(Country) as Total_Countries from table2;
select count(distinct City) as Total_Cities from table1;
select count(RestaurantID) as Total_Restaurants from table1;
select concat('Rs ',round(avg(Pricefor2))) as 'Avg.cost' from table1;
select avg(Rating) as 'Avg.Rating' from table1;


#------------------------------COUNTRY WISE NO. OF RESTAURANTS-------------------------------#	
select table2.Country, count(RestaurantID) as Restaurants from table1
inner join table2
on table1.CountryCode = table2.Country_Code
group by table2.Country;

#-----------------------------YEAR WISE OPENING OF RESTAURANTS---------------------------
select year(Datekey_Opening) as 'Year', count(RestaurantID)  as Restaurants from table1
group by year(Datekey_Opening)
order by year(Datekey_Opening);

#------------------------------QUARTER WISE RESTAURANTS-----------------------------------
select quarter(Datekey_Opening) as 'Quarter', count(RestaurantID)  as Restaurants from table1
group by Quarter(Datekey_Opening)
order by Quarter(Datekey_Opening);

#------------------------------YEAR AND QUARTER WISE OPENING OF RESTAURANTS-------------------------
select  year(Datekey_Opening) as 'Year',quarter(Datekey_Opening) as 'Quarter', count(RestaurantID)  as Restaurants from table1
group by year(Datekey_Opening),quarter(Datekey_Opening)
order by year(Datekey_Opening),quarter(Datekey_Opening);

#-----------------------------RATING WISE RESTAURANTS--------------------------------------------------
select case
when rating <=1 then "0-1" 
when rating <=2 then "1-2"
when rating <=3 then "2-3"
when Rating <=4 then "3-4"
when rating <=5 then "4-5"
end Rating_Bucket,count(restaurantid) as Restaurants
from table1 
group by Rating_Bucket
order by Rating_Bucket;

#----------------------------PRICE WISE RESTAURANTS---------------------------------------------
select case
when pricefor2 <=500 then "0-500"
when pricefor2 <=1000 then "501-1000"
when pricefor2 <=5000 then "1001-5000"
when pricefor2 <=10000 then "5001-10000"
when pricefor2 > 10000 then "10000 and above"
end Price_Bucket,count(restaurantid) as Restaurants
from table1 
group by Price_Bucket 
order by Field(Price_Bucket,"0-500", "501-1000","1001-5000","5001-10000","10000 and above");

#-------------------------------AVAILABILITY OF ONLINE TABLE BOOKING---------------------------
select has_table_booking , count(RestaurantID) as No_Of_Restaurants, concat(round((count(RestaurantID)/9551)*100),"%") as Percent
from table1
group by has_table_booking;

#-------------------------------AVAILABILITY OF ONLINE DELIVERY---------------------------
select Has_Online_delivery , count(RestaurantID) as No_Of_Restaurants, concat(round((count(RestaurantID)/9551)*100),"%") as Percent
from table1
group by Has_Online_delivery;

#--------------------------------------CUISINES--------------------------------------------------
select CUISINES FROM table1;

select SUBSTRING_INDEX(cuisines, ',',1) AS unique_cuisines, count(SUBSTRING_INDEX(cuisines, ',',1)) as Count_of_Cuisines
FROM table1
group by unique_cuisines;

#------------------------------------- TOP 5 CUISINES------------------------------------------------
select SUBSTRING_INDEX(cuisines, ',',1) AS unique_cuisines,
count(SUBSTRING_INDEX(cuisines, ',',1)) as Count_of_Cuisines
FROM table1
group by unique_cuisines
order by Count_of_Cuisines desc
limit 5;

#----------------------------------------CALENDER------------------------------------------------------
select Datekey_Opening,
year(Datekey_Opening) as YEAR_,
month(Datekey_Opening) as MONTH_,
monthname(Datekey_Opening) as MONTHNAME_,
concat("QRT-",Quarter(Datekey_Opening)) as QUARTER_,
concat(year(Datekey_Opening),'-',monthname(Datekey_Opening)) as YEAR_MONTH_,
case
when month(datekey_opening)= 1 then 'FM-10'
when month(datekey_opening)= 2 then 'FM-11'
when month(datekey_opening)= 3 then 'FM-12'
when month(datekey_opening)= 4 then 'FM-1'
when month(datekey_opening)= 5 then 'FM-2'
when month(datekey_opening)= 6 then 'FM-3'
when month(datekey_opening)= 7 then 'FM-4'
when month(datekey_opening)= 8 then 'FM-5'
when month(datekey_opening)= 9 then 'FM-6'
when month(datekey_opening)= 10 then 'FM-7'
when month(datekey_opening)= 11 then 'FM-8'
when month(datekey_opening)= 12 then 'FM-9'
end as Financial_Months,
case
when month(datekey_opening) <=3 then 'FQ4'
when month(datekey_opening) <=6 then 'FQ1'
when month(datekey_opening) <= 9 then 'FQ2'
else  'FQ3'
end as F_QRT
from table1; 
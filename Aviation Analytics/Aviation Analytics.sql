create database Aviation_Analytics;
use aviation_analytics;
CREATE TABLE Flights (
Year_ INT,
MONTH_ INT,
Day_ INT,
DAY_OF_WEEK INT,
AIRLINE VARCHAR(300),
FLIGHT_NUMBER INT,
TAIL_NUMBER VARCHAR(300),
ORIGIN_AIRPORT VARCHAR(300),
DESTINATION_AIRPORT VARCHAR(300),
SCHEDULED_DEPARTURE INT,
DEPARTURE_TIME VARCHAR(300),
DEPARTURE_DELAY VARCHAR(300),
TAXI_OUT VARCHAR(300),
WHEELS_OFF VARCHAR(300),
SCHEDULED_TIME VARCHAR(300),
ELAPSED_TIME VARCHAR(300),
AIR_TIME VARCHAR(300),
DISTANCE INT,
WHEELS_ON VARCHAR(300),
TAXI_IN VARCHAR(300),
SCHEDULED_ARRIVAL INT,
ARRIVAL_TIME VARCHAR(300),
ARRIVAL_DELAY VARCHAR(300),
DIVERTED INT,
CANCELLED INT,
CANCELLATION_REASON varchar(300),
AIR_SYSTEM_DELAY VARCHAR(300),
SECURITY_DELAY VARCHAR(300),
AIRLINE_DELAY VARCHAR(300),
LATE_AIRCRAFT_DELAY VARCHAR(300),
WEATHER_DELAY VARCHAR(300));

select * from flights;
select * from airlines;
use aviation_analytics;
#-------------------------------------------------------------------------------------------------------------------------
select * from airlines;
desc airlines;
select * from airports;
desc airports;
select * from flights;
desc flights;
#-------------------------------------------------------------------------------------------------------------------------
#Total flights in a ariline
create view flight_count as
select a.iata_code, a.airline, count(f.flight_number) as Total_flights from flights f
inner join airlines a on a.iata_code = f.airline
group by a.iata_code, a.airline;

select * from flight_count;
#-------------------------------------------------------------------------------------------------------------------------

select count(flight_number) as total_flights from flights;
#--------------------------------------------------------------------------------------------------------------------------
#KPI-1: Weekday Vs Weekend total flights statistics
create view kpi1 as
SELECT
    CASE
        WHEN day_of_week IN (1, 2, 3, 4, 5) THEN 'weekday'
        WHEN day_of_week IN (6, 7) THEN 'weekend'
        ELSE 'invalid day'
    END AS day_type,
    count(flight_number)
FROM
    flights
group by day_type;

select * from kpi1;

#---------------------------------------------------------------------------------------------------------------------------
#kpi-2: Total number of cancelled flights for JetBlue Airways on first date of every month
create view kpi2 as
SELECT distinct MONTHNAME(concat(f.year_,'-',f.month_,'-',f.day_)) AS month_name,
a.airline,count(flight_number) as total_count_of_cancelled_flights
FROM flights f
inner join airlines a on a.iata_code = f.airline
WHERE a.airline = 'JetBlue Airways'
AND Day_  = 1
AND cancelled = 1
group by month_name,a.airline;
select * from kpi2;
SELECT SUM(total_count_of_cancelled_flights) FROM KPI2;
#----------------------------------------------------------------------------------------------------------------------------
#kpi-3:Week wise, State wise and City wise statistics of delay of flights with airline details
create view kpi3 as
SELECT distinct DAYNAME(concat(f.year_,'-',f.month_,'-',f.day_)) AS Day_name,
a.state, a.city, count(f.flight_number) as total_flights_delayed from flights f
inner join airports a on a.iata_code=f.origin_airport
where f.ARRIVAL_DELAY > 15 and f.DEPARTURE_DELAY > 15
group by day_name, a.state, a.city;

select * from kpi3;
#----------------------------------------------------------------------------------------------------------------------------------
#kpi-4: Number of airlines with No departure/arrival delay with distance covered between 2500 and 3000
create view kpi4 as
SELECT a.airline,count(flight_number) as Number_of_airlines_without_delay
from flights f
inner join airlines a on a.iata_code = f.airline
where ARRIVAL_DELAY <= 15 and DEPARTURE_DELAY <= 15
and DISTANCE between 2500 and 3000
group by a.airline;

select * from kpi4;
#--------------------------------------------------------------------------------------------------------------------------
# KPI-5 :Total Number of flights in scheduled and Total number of flights cancelled in airlines statistics

create view kpi5 as
SELECT a.iata_code, a.airline,
SUM(CASE WHEN f.cancelled = 0 THEN 1 ELSE 0 END) AS total_scheduled_flights,
SUM(CASE WHEN f.cancelled = 1 THEN 1 ELSE 0 END) AS total_cancelled_flights
FROM flights f
inner join airlines a on a.iata_code = f.airline
GROUP BY a.iata_code, a.airline;
    
Select * from kpi5;

#---------------------------------------------------------------------------------------------------------------------
#kpi-6: Airline wise Total number of flights diverted

create view kpi6 as
select a.airline, count(f.diverted) as Total_Diverted_Flights from flights f
inner join airlines a on a.iata_code=f.airline
where diverted = 1
group by a.airline;

select * from kpi6;
#----------------------------------------------------------------------------------------------------------------------
Select * from KPI1;
Select * from KPI2;
Select * from KPI3;
Select * from KPI4;
Select * from KPI5;
Select * from KPI6;

#---------------------------------------------------------------------------------------------------------------------------

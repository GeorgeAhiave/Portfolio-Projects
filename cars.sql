select*
from cars;

-- duplicate table for cleaning and formating 
create table car_data
like cars;

insert  car_data
select * from cars;

select* from car_data;

-- changing column names

alter table car_data
change `Company Names` Company varchar(100),
change `Cars Names` Car_model varchar(100),
change `Total Speed` `Total_Speed(km/h)` varchar(100),
change `CC/Battery Capacity` CC_Battery_Capacity varchar(100),
change `Cars Prices` Car_Prices varchar(100),
change `Fuel Types` Fuel_Types varchar(100),
change HorsePower `Horse_Power(hp)` varchar(100);

-- standadizing data
update car_data
set 
	CC_Battery_Capacity = regexp_replace(CC_Battery_Capacity, '[^0-9]', ''),
	`Horse_Power(hp)` = regexp_substr(`Horse_Power(hp)`, '[0-9]+'),
    `Total_Speed(km/h)` = regexp_replace(`Total_Speed(km/h)`, '[^0-9]', ''),
    `Performance(0 - 100 )KM/H` = regexp_replace(`Performance(0 - 100 )KM/H`, '[^0-9\.]', ''),
    Car_Prices = regexp_substr(Car_Prices, '[0-9,]+'),
    Car_Prices = REPLACE(Car_Prices, ',', ''),
    Seats = regexp_replace(Seats, '[^0-9]', ''),
    Torque = regexp_substr(Torque, '[0-9]+');
    


-- checking for NULLs ans empty rows
select * 
from car_data
where CC_Battery_Capacity is null
	or CC_Battery_Capacity =''
	or Company is null
    or Company =''
    or car_model is null
    or car_model =''
    or `Engines` is null
    or `Engines` =''
    or `Horse_Power(hp)` is null
    or `Horse_Power(hp)` =''
    or `Total_Speed(km/h)` is null
    or `Total_Speed(km/h)` =''
    or `Performance(0 - 100 )KM/H` is null
    or `Performance(0 - 100 )KM/H`=''
    or `Car_Prices` is null
    or `Car_Prices` =''
    or Fuel_Types is null
    or Fuel_Types =''
    or Seats is null
    or Seats =''
    or Torque is null
    or Torque ='';
 
 
 -- clearing nulls and empty values
delete
from car_data
where CC_Battery_Capacity is null
	or CC_Battery_Capacity =''
	or Company is null
    or Company =''
    or car_model is null
    or car_model =''
    or `Engines` is null
    or `Engines` =''
    or `Horse_Power(hp)` is null
    or `Horse_Power(hp)` =''
    or `Total_Speed(km/h)` is null
    or `Total_Speed(km/h)` =''
    or `Performance(0 - 100 )KM/H` is null
    or `Performance(0 - 100 )KM/H`=''
    or `Car_Prices` is null
    or `Car_Prices` =''
    or Fuel_Types is null
    or Fuel_Types =''
    or Seats is null
    or Seats =''
    or Torque is null
    or Torque ='';


-- changing data types to match values
alter table car_data
modify CC_Battery_Capacity int,
modify `Horse_Power(hp)`int,
modify `Total_Speed(km/h)` int,
modify `Performance(0 - 100 )KM/H` decimal(5,2),
modify Car_Prices int,
modify Seats int;

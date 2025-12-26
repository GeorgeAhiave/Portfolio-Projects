select * 
from cleaned_climate_energy;

select country,
       SUM(co2_emission) as total_co2
from cleaned_climate_energy
where year = 2024
group by  country
order by  total_co2 desc
limit 10;


select country,
       year,
       renewable_share,
       renewable_share 
       - lag(renewable_share) 
       over (partition by country order by year) as renewable_growth
from cleaned_climate_energy;


select year,
       avg(co2_emission) as avg_co2,
       avg(energy_consumption) as avg_energy,
       avg(renewable_share) as avg_renewables
from cleaned_climate_energy
group by year
order by year;


select 
    country,
    `year`,
    co2_emission,
    ROUND(
        (co2_emission - lag(co2_emission) 
         over (partition by country order by year))
        / lag(co2_emission) 
         over (partition by country order by year) * 100, 
    2) as co2_yoy_percent_change
from cleaned_climate_energy
order by country, year;




with co2_trend as (
    select 
        country,
        `year`,
        co2_emission,
        co2_emission - lag(co2_emission)
        over (partition by country order by year) as yearly_change
    from cleaned_climate_energy
)
select country
from co2_trend
group by country
having SUM(case when yearly_change > 0 then 1 else 0 end) = 0;


select 
    country,
    ROUND(
        avg(renewable_share 
            - lag(renewable_share) 
              over (partition by country order by year)
        ), 2
    ) AS avg_renewable_growth
from cleaned_climate_energy
group by country
order by avg_renewable_growth desc;


select 
    country,
    year,
    co2_emission,
    renewable_share,
    case
        when co2_emission > avg(co2_emission) over () 
             and renewable_share < avg(renewable_share) over ()
            then 'High Emissions / Low Renewables'
        when co2_emission <= avg(co2_emission) over () 
            and renewable_share >= avg(renewable_share) over ()
            then 'Low Emissions / High Renewables'
        else 'Mixed Profile'
    end as climate_profile
from cleaned_climate_energy;

select 
    country,
    round(
        sum(co2_emission) * 100.0 
        / sum(sum(co2_emission)) over (), 
    2) as percent_of_global_co2
from cclimate_energy
group by country
order by percent_of_global_co2 desc;



select 
    country,
    year,
    round(co2_emission / nullif(energy_consumption, 0), 4) 
    as carbon_intensity
from cleaned_climate_energy;


select 
    country,
    year,
    round(
        avg(co2_emission) 
        over (
            partition by country 
            order by year 
            rows between 2 preceding and current row
        ), 2
    ) as rolling_3yr_avg_co2
from cleaned_climate_energy;

select *
from adidas_us_sales_datasets
limit 10;

describe adidas_us_sales_datasets;

select count(*) as total_rows
from adidas_us_sales_datasets;

select 
    min(invoice_date) as start_date,
    max(invoice_date) as end_date
from adidas_us_sales_datasets;


create or replace view adidas_sales_clean as
select
    `Retailer` as retailer,
    `Retailer ID` as retailer_id,
    str_to_date(`Invoice Date`, '%d/%m/%Y') as invoice_date,
    `Region` as region,
    `State` as state,
    `City` as city,
    `Product` as product,

    cast(replace(replace(`Price per Unit`, '$', ''), ',', '') as decimal(10,2)) as price_per_unit,
    cast(replace(`Units Sold`, ',', '') as unsigned) as units_sold,
    cast(replace(replace(`Total Sales`, '$', ''), ',', '') as decimal(12,2)) as total_sales,
    cast(replace(replace(`Operating Profit`, '$', ''), ',', '') as decimal(12,2)) as operating_profit,
    cast(replace(`Operating Margin`, '%', '') as decimal(5,2)) as operating_margin,

    `Sales Method` as sales_method
from adidas_us_sales_datasets;



select
    count(*) as total_rows,
    count(total_sales) as valid_sales,
    count(units_sold) as valid_units
from adidas_sales_clean;

create or replace view adidas_sales_final as
select *
from adidas_sales_clean
where invoice_date is not null
  and total_sales is not null
  and units_sold is not null
  and total_sales > 0
  and units_sold > 0;

  
  
  
select *
from adidas_sales_final
limit 5;

select
    min(invoice_date) as start_date,
    max(invoice_date) as end_date
from adidas_sales_final;

select
    region,
    sum(total_sales) as revenue
from adidas_sales_final
group by region
order by revenue desc;

select
    year(invoice_date) as year,
    sum(total_sales) as revenue,
    lag(sum(total_sales)) over (order by year(invoice_date)) as prev_year_revenue,
    round(
        (sum(total_sales) - lag(sum(total_sales)) over (order by year(invoice_date))) /
        lag(sum(total_sales)) over (order by year(invoice_date)) * 100,
        2
    ) as yoy_growth_percent
from adidas_sales_final
group by year;

select
    date_format(invoice_date, '%Y-%m') as month,
    sum(total_sales) as revenue,
    sum(total_sales) -
    lag(sum(total_sales)) over (order by date_format(invoice_date, '%Y-%m')) as mom_change
from adidas_sales_final
group by month;

select
    product,
    sum(total_sales) as revenue,
    sum(operating_profit) as profit,
    rank() over (order by sum(operating_profit) desc) as profit_rank
from adidas_sales_final
group by product;

select
    retailer,
    sum(total_sales) as revenue,
    round(
        sum(total_sales) / sum(sum(total_sales)) over () * 100,
        2
    ) as contribution_percent
from adidas_sales_final
group by retailer
order by revenue desc;

select
    sales_method,
    sum(units_sold) as total_units,
    sum(total_sales) as revenue,
    round(sum(total_sales) / sum(units_sold), 2) as revenue_per_unit
from adidas_sales_final
group by sales_method;

select
    state,
    count(distinct retailer) as retailer_count,
    sum(total_sales) as revenue
from adidas_sales_final
group by state
order by revenue desc;

select
    product,
    round(avg(price_per_unit), 2) as avg_price,
    sum(units_sold) as total_units
from adidas_sales_final
group by product
order by avg_price desc;

select *
from adidas_sales_final;

create table adidas_sales_final_table as
select *
from adidas_sales_final;

select *
from adidas_sales_final_table;














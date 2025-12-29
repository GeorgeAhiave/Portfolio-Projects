-- Average Yield by Crop
SELECT crops, AVG(yields) AS avg_yield
FROM agric_data
GROUP BY crops
ORDER BY avg_yield DESC;

-- Yield by Season
SELECT season, AVG(yields) AS avg_yield
FROM agric_data
GROUP BY season;

-- Climate Impact
SELECT
  crops,
  AVG(rainfall) AS avg_rainfall,
  AVG(temperature) AS avg_temp,
  AVG(yields) AS avg_yield
FROM agric_data
GROUP BY crops;

-- Top Locations
SELECT location, SUM(yields) AS total_yield
FROM agric_data
GROUP BY location
ORDER BY total_yield DESC
LIMIT 10;

-- Year-over-Year Yield Change
SELECT
  year,
  AVG(yields) AS avg_yield,
  AVG(yields) - LAG(AVG(yields)) OVER (ORDER BY year) AS yoy_change
FROM agric_data
GROUP BY year;

-- Most Profitable Crops
SELECT
  crops,
  SUM(yields * price) AS estimated_revenue
FROM agric_data
GROUP BY crops
ORDER BY estimated_revenue DESC;

-- Climate Sensitivity Ranking
SELECT
  crops,
  CORR(rainfall, yields) AS rainfall_corr,
  CORR(temperature, yields) AS temp_corr
FROM agric_data
GROUP BY crops;


ALTER TABLE agric_data
ADD COLUMN estimated_revenue DOUBLE;

UPDATE agric_data
SET estimated_revenue = yields * price;


select * from agric_data;






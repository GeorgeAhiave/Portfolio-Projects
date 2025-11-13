-- data cleaning
select *
from layoffs;

create table layoffs_st
like layoffs;

insert layoffs_st
select* from layoffs;

select *
from layoffs_st;

-- remove duplicates
select *,
row_number() over(partition by
 company,industry,total_laid_off,percentage_laid_off,'date') as row_num
from layoffs_st;

with duplicate_cte as
(
select *,
row_number() over(partition by
 company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) as row_num
from layoffs_st
)
select *
from duplicate_cte
where row_num >1;

CREATE TABLE `layoffs_st2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


select *
from layoffs_st2;

insert into layoffs_st2
select*,
row_number() over(partition by
 company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) as row_num
from layoffs_st;

select *
from layoffs_st2
where row_num >1;

delete 
from layoffs_st2
where row_num >1;

select *
from layoffs_st2
where row_num >1;

-- standadising data

select company,trim(company) 
from layoffs_st2;

select distinct(industry)
from layoffs_st2
order by 1;

select distinct location
from layoffs_st2
order by 1;

update layoffs_st2
set industry = 'Crypto'
where industry like 'Crypto%';

update layoffs_st2
set company = trim(company);

select  distinct country, trim(trailing '.' from country) 
from layoffs_st2
order by 1;

update layoffs_st2
set country=  trim(trailing '.' from country) 
where country like 'United States%';

select `date`,
str_to_date(`date`,'%m/%d/%Y')
from layoffs_st2;


update layoffs_st2
set `date`=str_to_date(`date`,'%m/%d/%Y');

alter table layoffs_st2
modify column `date` date;

select*
from layoffs_st2 t1
join layoffs_st2 t2
	on t1.company=t2.company
where (t1.industry is null or t1.industry='')		
and t2.industry is not null;

update layoffs_st2 t1
join layoffs_st2 t2
	on t1.company=t2.company
set t1.industry=t2.industry	
where (t1.industry is null or t1.industry='')		
and t2.industry is not null;	

update layoffs_st2
set industry= null
where industry='';

update layoffs_st2 t1
join layoffs_st2 t2
	on t1.company=t2.company
set t1.industry=t2.industry	
where t1.industry is null; 		

delete 
from layoffs_st2
where total_laid_off is null
and percentage_laid_off is null;

alter table layoffs_st2
drop column row_num;
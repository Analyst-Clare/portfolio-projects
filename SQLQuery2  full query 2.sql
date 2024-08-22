select *
from [portfolio project]..[dataAnalyst ratings]

select *
from [portfolio project]..[dataAnalyst jobs 1]


---select data that we are going to be using

select S_N, job_title,company,experience,location,joblisted_days_ago
from [portfolio project]..[dataAnalyst jobs 1]
order by 1,2


---looking at total company vs total locationa
---showing where all the companies are situated

select s_n, job_title, company, location
from [portfolio project]..[dataAnalyst jobs 1]
order by 1,2


---loking at the joblisted_days_aga vs location
---showing what percentage of jobs get listed in a particular location

select job_title, jobListed_days_ago, location, (joblisted_days_ago/100) *100 as percentagelocation
from [portfolio project]..[dataAnalyst jobs 1]
where location is not null
order by percentagelocation desc
--order by location


--looking at location with the highest joblisted_days_ago compared to experience

select job_title,experience, max(joblisted_days_ago) as highestjoblisted, max(joblisted_days_ago/100) * 100 as percentagejoblisted_days_ago
from [portfolio project]..[dataAnalyst jobs 1]
where location is not null
group by job_title,experience
order by percentagejoblisted_days_ago desc


---showing the company with the highest experience per location

select location, MAX(experience) as highestexperience
from [portfolio project]..[dataAnalyst jobs 1]
where location is not null
group by location
order by highestexperience desc



--let's break things down by location

select location, MAX(joblisted_days_ago )as totaljoblisteddaysago
from [portfolio project]..[dataAnalyst jobs 1]
--where location like '%mumba%'
where location is not null
group by location
order by totaljoblisteddaysago desc


---showing the total number of location with data analyst jobs


select  COUNT(location) as totallocation
from [portfolio project]..[dataAnalyst jobs 1]
where job_title ='Data Analyst'
order by totallocation desc

select *
from [portfolio project]..[dataAnalyst jobs 1]


---looking at the location with the highest jobtitle

select job_title, max(location) as highestlocation
from [portfolio project]..[dataAnalyst jobs 1]
where location is not null
group by job_title
order by highestlocation desc


---looking at the joblisted in variou location according to jobtitles
---showing the highest number of jobs that's been listed in different locations

select job_title,location, sum(jobListed_days_ago) as totaljoblisted
from [portfolio project]..[dataAnalyst jobs 1]
group by job_title,location
order by totaljoblisted desc



--global numbers


select experience, sum(joblisted_days_ago)  as totaljoblisted_days_ago, sum(s_n) as totalsn, sum(joblisted_days_ago) /sum(s_n) * 100 as joblistedpercentage
from [portfolio project]..[dataAnalyst jobs 1]
where location is not null
group by experience
order by joblistedpercentage desc

select *
from [portfolio project]..[dataAnalyst jobs 1] DA
join [portfolio project]..[dataAnalyst ratings] DR
on DA.job_title = DR.job_title
and DA.S_N = DR.S_N


---looking at tital joblisted-days_ago vs reviews_count

select DA.job_title, DA.experience, DA.jobListed_days_ago, DR.reviews_count,
sum(DR.reviews_count) over (partition by DA.job_title, DA.experience order by DA.job_title, DA.experience)as totaljoblistedwithexperience
---(totaljoblistedwithexperience/DA.joblisted_days_ago) * 100
from [portfolio project]..[dataAnalyst jobs 1] DA
join [portfolio project]..[dataAnalyst ratings] DR
ON  DA.job_title = DR.job_title
AND DA.S_N = DR.S_N
where DA.job_title IS NOT NULL
order by 1,2


---use CTE

with joblistedreviews (job_title,experience,joblisted_days_ago,reviews_count,totaljoblistedwithexperience)
as
(
select DA.job_title, DA.experience, DA.jobListed_days_ago, DR.reviews_count,
sum(DR.reviews_count) over (partition by DA.job_title, DA.experience order by DA.job_title, DA.experience)as totaljoblistedwithexperience
---,(totaljoblistedwithexperience/DA.joblisted_days_ago) * 100
from [portfolio project]..[dataAnalyst jobs 1] DA
join [portfolio project]..[dataAnalyst ratings] DR
ON  DA.job_title = DR.job_title
AND DA.S_N = DR.S_N
where DA.job_title IS NOT NULL
---order by 1,2
)

select *
from joblistedreviews


--temp tables

create table  #TEMP_percentjoblistedreviews
(
job_title varchar (255),
experience  nvarchar (50),
joblisted_days_ago numeric,
reviews_count numeric,
totaljoblistedwithexperience numeric
)


insert into #TEMP_percentjoblistedreviews
select DA.job_title, DA.experience, DA.jobListed_days_ago, DR.reviews_count,
sum(DR.reviews_count) over (partition by DA.job_title, DA.experience order by DA.job_title, DA.experience)as totaljoblistedwithexperience
---,(totaljoblistedwithexperience/DA.joblisted_days_ago) * 100
from [portfolio project]..[dataAnalyst jobs 1] DA
join [portfolio project]..[dataAnalyst ratings] DR
ON  DA.job_title = DR.job_title
AND DA.S_N = DR.S_N
where DA.job_title IS NOT NULL
---order by 1,2

select *
from #TEMP_percentjoblistedreviews


--creating views to store data for later visualization

create view 
percentjoblistedviews
as 
select DA.job_title, DA.experience, DA.jobListed_days_ago, DR.reviews_count,
sum(DR.reviews_count) over (partition by DA.job_title, DA.experience order by DA.job_title, DA.experience)as totaljoblistedwithexperience
---,(totaljoblistedwithexperience/DA.joblisted_days_ago) * 100
from [portfolio project]..[dataAnalyst jobs 1] DA
join [portfolio project]..[dataAnalyst ratings] DR
ON  DA.job_title = DR.job_title
AND DA.S_N = DR.S_N
where DA.job_title IS NOT NULL
---order by 1,2


select *
from percentjoblistedviews
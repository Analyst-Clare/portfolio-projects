--select *
--from asthma_disease_causes

--select *
--from  asthma_disease_cure


--select data that we are going to be using

select age,PatientID,gender,bmi,pollutionexposure,pollenexposure,DustExposure
from [portfolio project]..asthma_disease_causes
order by 1,2


--looking at pollutionexposure vs dustexposure
--showing the number of people affected by gender

select PatientID,gender,bmi,pollutionexposure,DustExposure,(pollutionexposure/dustexposure)*100 as pollutionpercetage
from [portfolio project]..asthma_disease_causes
where Gender like '%female%'
order by 1,2


--looking at dustexposure vs bmi
--showing the percentage of people affected by bme

select PatientID,gender,bmi,DustExposure,(DustExposure/BMI)*100 as bmiaffectedpercentage
from [portfolio project]..asthma_disease_causes
--where Gender like '%female%'
order by 1,2

select *
from asthma_disease_causes


--looking at patients with highest lung infection compared to bmi

select bmi,LungFunctionFEV1,max(LungFunctionFEV1) as highestlungaffectedcount,max(BMI/LungFunctionFEV1)*100  as percentagelunginfected
from [portfolio project]..asthma_disease_causes
--where Gender like '%female%'
group by BMI,LungFunctionFEV1
order by percentagelunginfected desc


--looking at the number of patients with highest bmi

select bmi,PatientID,max(bmi) as highestbmiinfectedcount,max(BMI/patientid)*100  as highestpatientinfectedparcentage
from [portfolio project]..asthma_disease_causes
--where Gender like '%female%'
group by BMI,PatientID
order by highestpatientinfectedparcentage desc

select *
from asthma_disease_causes


--looking the age with highest lungfunctionfvc per bmi

select Age,LungFunctionFVC,BMI,max(LungFunctionFVC) as highestlunginfectedcount,max(BMI/Age)*100  as highestagepercentageinfected
from [portfolio project]..asthma_disease_causes
--where Gender like '%female%'
where Gender is not null
group by Age,BMI,LungFunctionFVC                            
order by highestagepercentageinfected asc


--let's break down by gender

select Gender,max(age) as highestage
from [portfolio project]..asthma_disease_causes
--where Gender like '%female%'
where Gender is not null
group by Gender                           
order by highestage


select *
from asthma_disease_causes


--showing the gender with the highest pollenexposure per bmi

select Gender,max(pollenexposure) as highestpollenexposureinfected
from [portfolio project]..asthma_disease_causes
--where Gender like '%female%'
where Gender is not null
group by Gender                           
order by highestpollenexposureinfected


--global numbers

select  PatientID,sum(lungfunctionfev1)as totaollungfunctionfev1,sum(lungfunctionfvc)as totallungfunctionfvc,sum(lungfunctionfev1)/sum(lungfunctionfvc)*100 as lungpercentage
from [portfolio project]..asthma_disease_causes
--where Gender like '%female%'
where Gender is not null
group by  PatientID                       
order by 1,2


select *
from asthma_disease_causes

select *
from  asthma_disease_cure



--global numbers

select  PatientID,sum(lungfunctionfev1)as totaollungfunctionfev1,sum(lungfunctionfvc)as totallungfunctionfvc,sum(lungfunctionfev1)/sum(lungfunctionfvc)*100 as lungpercentage
from [portfolio project]..asthma_disease_causes
--where Gender like '%female%'
where Gender is not null
group by  PatientID                       
order by 1,2

select *
from [portfolio project]..asthma_disease_causes cause
join [portfolio project]..asthma_disease_cure  cure
on cause.Age = cure.Age
and cause.Gender= cure.Gender


--looking at total BMI vs sleepquality

select cause.Gender, cause.age,cause.patientid, cause.bMi, cure.sleepquality,
sum (cure.sleepquality) over (partition by cause.gender,cause.Age order by cause.gender,cause.age)  as totalagecurebysleepquality
--( totalagecurebysleepquality/cause.BMI)*100
from [portfolio project]..asthma_disease_causes cause
join [portfolio project]..asthma_disease_cure cure
on cause.Gender=cure.Gender
and cause.Age=cure.Age
where cause.Gender is not null
order by 1,2


--using CTE;

with Bmivssleepquality (gender, age, patientid,  bmi, sleepquality, totalagecurebysleepquality)
as
(
select cause.Gender, cause.age, cause.patientid, cause.bMi, cure.sleepquality
, sum (cure.sleepquality) over (partition by cause.gender order by cause.gender,cause.age)  as totalagecurebysleepquality
--,( totalagecurebysleepquality/cause.BMI)*100
from [portfolio project]..asthma_disease_causes cause
join [portfolio project]..asthma_disease_cure cure
on cause.Gender=cure.Gender
and cause.Age=cure.Age
where cause.Gender is not null
--order by 1,2
)
select *
from Bmivssleepquality

--temp tables

CREATE table #TEMP_percentbmisleepquality
(
gender varchar( 255),
age numeric, 
patientid numeric,
bmi numeric,
sleepquality numeric,
totalagecurebysleepquality numeric
)


insert into  #TEMP_percentbmisleepquality
select cause.Gender, cause.age, cause.patientid, cause.bMi, cure.sleepquality
, sum (cure.sleepquality) over (partition by cause.gender order by cause.gender,cause.age)  as totalagecurebysleepquality
--,( totalagecurebysleepquality/cause.BMI)*100
from [portfolio project]..asthma_disease_causes cause
join [portfolio project]..asthma_disease_cure cure
on cause.Gender=cure.Gender
and cause.Age=cure.Age
where cause.Gender is not null
--order by 1,2


select *
from  #TEMP_percentbmisleepquality




--Creating view to store data later visualization


create view percentbmisleepquality as
select cause.Gender, cause.age, cause.patientid, cause.bMi, cure.sleepquality
, sum (cure.sleepquality) over (partition by cause.gender order by cause.gender,cause.age)  as totalagecurebysleepquality
--,( totalagecurebysleepquality/cause.BMI)*100
from [portfolio project]..asthma_disease_causes cause
join [portfolio project]..asthma_disease_cure cure
on cause.Gender=cure.Gender
and cause.Age=cure.Age
where cause.Gender is not null
--order by 1,2


select *
from percentbmisleepquality


















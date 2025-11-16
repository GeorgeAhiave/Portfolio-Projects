select *
from diabetes;

create table diabetes2
like diabetes;

insert diabetes2
select * from diabetes;

-- Making a gender column and assigning the respective genders
select Pregnancies, BloodPressure,'Male' as Gnder
from diabetes2
where Pregnancies = 0
union
select Pregnancies, BloodPressure,'Female' as Gnder
from diabetes2
where Pregnancies >= 1;

alter table diabetes2
add column Gender varchar(10);

update diabetes2 as d
join (
    select Pregnancies, 'Male' as Gender
    from diabetes2
    where Pregnancies = 0

    union

    select Pregnancies, 'Female' as Gender
    from diabetes2
    where Pregnancies >= 1
) as g
on d.Pregnancies = g.Pregnancies
set d.Gender = g.Gender;

select *
from diabetes2;

-- BMI Analysis
select BMI, Gender,
	case	
		when BMI <18.5 then 'Under Weight'
		when BMI between 18.5 and 24.9 then 'Normal Weight'
		when BMI between 25 and 29.9 then 'Overweight'
		when BMI between 30 and 34.9 then 'Obesity Class 1'
		when BMI between 35 and 30.9 then 'Obesity Class 2'
		else 'Obesity Class 3(Severe)'
	end as Weight_Class
from diabetes2;

alter table diabetes2
add column Weight_Class varchar(50);


update  diabetes2
set Weight_Class=
	case	
		when BMI <18.5 then 'Under Weight'
		when BMI between 18.5 and 24.9 then 'Normal Weight'
		when BMI between 25 and 29.9 then 'Overweight'
		when BMI between 30 and 34.9 then 'Obesity Class 1'
		when BMI between 35 and 30.9 then 'Obesity Class 2'
		else 'Obesity Class 3(Severe)'
	end;

select *
from diabetes2;    

-- Diabetes status
alter table diabetes2
add column Diabetes_Status varchar(20);

update diabetes2
set Diabetes_Status =
    case
        when Glucose >= 126
             or BMI >= 30
             or BloodPressure >= 140
             or Insulin > 25
             or SkinThickness > 25
             or DiabetesPedigreeFunction > 0.5
        then 'Diabetic'
        when (Glucose between 100 and 125)
             or (BMI between 25 and 29.9)
             or (BloodPressure between 130 AND 139)
             or (Insulin between 15 and 25)
             or (SkinThickness between 15 and 25)
             or (DiabetesPedigreeFunction between 0.2 and 0.5)
        then 'Prediabetic'
        else 'Normal'
    end;                                   	
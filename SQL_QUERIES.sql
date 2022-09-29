--1. Get list of Patients order by DateOfBirth descending order.
select "FirstName","LastName","DateOfBirth" from public."Patients" order by "DateOfBirth" desc;

--2.Display the firstname and lastname of patients who speaks English language.
select "FirstName","LastName" ,b."Language" from public."Patients" a join public."Language" b on a."Language_ID"= b."Language_ID" where b."Language"= 'English';

--3.Write a query to get list of patient ID's whose PrimaryDiagnosis is 'Flu'order by patient_ID.
select "Patient_ID","PrimaryDiagnosis" from public."PrimaryDiagnosis" a right join public."Discharges" b on a."Diagnosis_ID" = b."Diagnosis_ID" where a."PrimaryDiagnosis"='Flu' order by "Patient_ID";

--4.Write a query to find the Patient_ID and Admission_ID for the patients whose Primary diagnosis is 'Heart Failure'.
select "Patient_ID", "Admission_ID","PrimaryDiagnosis" from public."PrimaryDiagnosis" a right join public."Discharges" b on a."Diagnosis_ID" = b."Diagnosis_ID" where a."PrimaryDiagnosis"='Heart Failure';

--5.Write a query to get list of patient ID's whose pulse is below the normal Range.
select "Patient_ID" ,"Pulse" from public."AmbulatoryVisits" where "Pulse" < 60.000000;

--6.Write a query to find the list of patient_ID's discharged with Service in SID01, SID02, SID03;
select "Patient_ID" ,"Service_ID" from public."Discharges" where "Service_ID"  in ('SID01','SID02','SID03') order by "Service_ID" ;

--7. Write a query to get list of patients who were admitted because of Stomachache.
select public."Patients"."FirstName", public."Patients"."LastName",Public."ReasonForVisit"."ReasonForVisit" From
public."Patients",Public."ReasonForVisit",Public."EDVisits" where (Public."ReasonForVisit"."Rsv_ID"=Public."EDVisits"."Rsv_ID" and public."Patients"."Patient_ID"=public."EDVisits"."Patient_ID" and public."ReasonForVisit"."ReasonForVisit"= 'Stomach Ache' );

--8. Write a query to Update Service ID SID05 to Ortho.
 UPDATE public."Service"SET  "Service" = 'Ortho'WHERE "Service_ID" = 'SID05';
 

--9.Get list of Patient ID's whose visit type was 'Followup' and VisitdepartmentID is 5 or 6.
SELECT public."AmbulatoryVisits"."Patient_ID" , public."VisitTypes"."VisitType" , public."AmbulatoryVisits"."VisitDepartmentID"
FROM public."AmbulatoryVisits",public."VisitTypes" where(
public."AmbulatoryVisits"."AMVT_ID"=public."VisitTypes"."AMVT_ID"  AND public."VisitTypes"."VisitType"= 'Follow Up'  AND  (public."AmbulatoryVisits"."VisitDepartmentID" ='6' OR public."AmbulatoryVisits"."VisitDepartmentID"= '5'));


--10. Create index on ambulatory visit by selecting columns Visit_ID, AMVT_ID and VisitStatus_ID.
CREATE INDEX Visit_ID_Index ON public."AmbulatoryVisits" ("Visit_ID","AMVT_ID","VisitStatus_ID");


--11.Create a trigger to execute after inserting a record into Patients table.Insert value to display result.
create or Replace function Get_newPatient() 
returns trigger As $BODY$
BEGIN
Raise notice 'inserted a new patient with following column values Patient_ID "%",FirstName "%", LastName "%",DateOfBirth "%", ',NEW."Patient_ID",NEW."FirstName",NEW."LastName",NEW."DateOfBirth";
RETURN NEW;
END;
$BODY$
language 'plpgsql';

create trigger Newpatient_Trigger
after insert on public."Patients"
for each row
execute procedure Get_newPatient();

insert into public."Patients" ("Patient_ID","FirstName","LastName","DateOfBirth","Gender_ID","Race_ID","Language_ID") 
values(20575,'rajas','LN','1985-01-01','G001','R02','L_01')




--12.  Write a query to find the ProviderName and Provider Speciality for PS_ID = 'PSID02'
select  "Providers"."ProviderName", "ProviderSpeciality"."ProviderSpeciality", "ProviderSpeciality"."PS_ID"from "Providers"inner join "ProviderSpeciality"on "Providers"."PS_ID" = "ProviderSpeciality"."PS_ID"
WHERE "ProviderSpeciality"."PS_ID" = 'PSID02'


--13.Display the patient names and ages whose age is more than 50 years
select "FirstName", "LastName",  date_part('year', age("DateOfBirth")) as age_in_years
from "Patients"
where age("DateOfBirth") > interval '50 years' 

--14. Write a query to get list of patient ID'sand service whose are in service as ‘'Nuerology'
select "Patients"."Patient_ID","Service"."Service"
from "Patients"
inner join "ReAdmissionRegistry"
on "Patients"."Patient_ID" = "ReAdmissionRegistry"."Patient_ID"
inner join "Service"
on "ReAdmissionRegistry"."Service_ID" = "Service"."Service_ID"
where "Service"."Service" = 'Neurology' 

 
--15. Create view on table Provider table on columns ProviderName and Provider_ID
create view view_Provider as 
select "Providers"."ProviderName", "Providers"."Provider_ID"
from "Providers";
select * from view_Provider



--16.Write a query to Extract Year from ProviderDateOnStaff
select extract(year from "ProviderDateOnStaff") from public."Providers";



--17. Write a query to get unique Patient_ID,race and Language of patients whose race is White and also speak English.
Select Distinct "Patient_ID", "FirstName","LastName",public."Race"."Race",
public."Language"."Language"
from public."Patients", public."Race", public."Language"
where public."Patients"."Language_ID" = public."Language"."Language_ID"
AND public."Patients"."Race_ID" = public."Race"."Race_ID"
AND public."Language"."Language" = 'English'AND public."Race"."Race" = 'White';



--18.Get list of patient ID's whose service was 'Cardiology' and discharged to 'Home'.
select public."Discharges"."Patient_ID" , public."Patients"."FirstName",
public."Patients"."LastName",
public."Service"."Service" , public."DischargeDisposition"."DischargeDisposition"
from public."Discharges"
JOIN public."Service"
ON public. "Discharges"."Service_ID" = public."Service"."Service_ID"
AND public."Service"."Service" = 'Cardiology'
JOIN public."DischargeDisposition"
ON public."Discharges"."Discharge_ID" = public."DischargeDisposition"."Discharge_ID"
AND public."DischargeDisposition"."DischargeDisposition" ='Home'
JOIN public."Patients"
ON public."Discharges"."Patient_ID" = public."Patients"."Patient_ID";




--19. Write a query to get list of Provider names whose Providername is starting with letter T.
Select * from public."Providers"
where "ProviderName" Like 'T%' ;



--20. List female patients over the age of 40 who have undergone surgery from January-March 2019.
Select Public."Patients"."Patient_ID" , Public."Patients"."FirstName",
Public."Patients"."LastName" , Public."Gender"."Gender",
Age( '2022-08-21' , "DateOfBirth") as Patient_Age
from Public."Patients", Public."Gender", Public."AmbulatoryVisits", Public."Providers",
Public."ProviderSpeciality"
Where Public."Patients"."Patient_ID"=Public."AmbulatoryVisits"."Patient_ID"
AND Public."Patients"."Gender_ID"=Public."Gender"."Gender_ID"
AND Public."AmbulatoryVisits"."Provider_ID"=Public."Providers"."Provider_ID"
AND Public."Providers"."PS_ID" =Public."ProviderSpeciality"."PS_ID"
AND Public."AmbulatoryVisits"."Provider_ID" in(10,11,12,13,14,15,16)
AND Age( '2022-08-21' , "DateOfBirth") > '40 years 0 mons 0 days'
AND Public."Gender"."Gender" ='Female'
AND Public."AmbulatoryVisits"."DateScheduled" BETWEEN '2019-JAN-01' AND '2019-MAR-31';




--21. Write a Query to get list of Male patients.
select "FirstName","LastName", "Patient_ID" ,"Gender" from public."Patients" a join public."Gender" b on a."Gender_ID" = b."Gender_ID"  where "Gender"= 'Male';


--22. Write a query to get list of patient ID's who has discharged to home.
select "Patient_ID", b."DischargeDisposition" from public."Discharges" a join public."DischargeDisposition" b on a."Discharge_ID"=b."Discharge_ID" where b."DischargeDisposition"='Home'

                                                                                                                                                                                                                                                                                                                                                                                                                                     

--23. Find the category of illness(Stomach Ache or Migrane) that has maximum number of patients.
select max(r."ReasonForVisit"),count(r."ReasonForVisit") from public."Patients" p join public."EDVisits" ed on p."Patient_ID"= ed."Patient_ID" join public."ReasonForVisit" r on ed."Rsv_ID"=r."Rsv_ID" where r."ReasonForVisit" in ('Stomach Ache','Migraine') group by r."ReasonForVisit" order by ("ReasonForVisit") desc fetch first 1 rows only;


--24. Write a query to get list of New Patient ID's.
select * from public."VisitTypes";
select p."Patient_ID", vt."VisitType" from public."Patients" p 
join public."AmbulatoryVisits" a on p."Patient_ID"=a."Patient_ID"
join public."VisitTypes" vt on vt."AMVT_ID"= a."AMVT_ID" 
where vt."VisitType"='New';



--25. Create trigger on table Readmission registry
 create or Replace function Get_newReadmission_Registtry()
returns trigger As $BODY$
BEGIN
RETURN NEW;
END;
$BODY$
language 'plpgsql';
 
create trigger Readmission_AddNew_Trigger
after insert on public."ReAdmissionRegistry"
for each row
execute procedure Get_newReadmission_Registtry();



--26. Select all providers with a name starting 'h' followed by any character ,followed by 'r', followed by any character,followed by 'y'.
select lower(public."Providers"."ProviderName") AS Provider_name from public."Providers" WHERE lower(public."Providers"."ProviderName") LIKE 'h_r_y%';


--27. Show the list of the patients who have cancelled their appointment.
 select public."Patients"."Patient_ID", public."Patients"."FirstName",public."Patients"."LastName",public."VisitStatus"."VisitStatus" from public."Patients",public."AmbulatoryVisits",public."VisitStatus"
Where (public."VisitStatus"."VisitStatus_ID"=public."AmbulatoryVisits"."VisitStatus_ID" AND public."AmbulatoryVisits"."Patient_ID"=public."Patients"."Patient_ID" AND public."VisitStatus"."VisitStatus"= 'Canceled'); 


 --28. Write a query to get list of ProviderName's with a name starting 'ted'
  select lower(public."Providers"."ProviderName") AS provider_name from public."Providers" where lower( public."Providers"."ProviderName") LIKE 'ted%';


--29. Create a view without using any schema or table and check the created view using select statement.
Create View Public."Customers" As Select 'Happy Customers';
                     select * From Public."Customers";



--30.Write a query to get unique list of Patient Id's whose reason for visit is car Accident.
select DISTINCT public."Patients"."Patient_ID",public."ReasonForVisit"."ReasonForVisit" from
public."Patients",public."ReasonForVisit",public."EDVisits" where(public."EDVisits"."Rsv_ID"=public."ReasonForVisit"."Rsv_ID"
 AND public."Patients"."Patient_ID"=public."EDVisits"."Patient_ID" AND public."ReasonForVisit"."ReasonForVisit"= 'Car Accident');



--31.Find which Visit type of patients are maximum in canceling their Appointment
select "VisitTypes"."VisitType"
from "VisitTypes"
inner join "AmbulatoryVisits"
on "VisitTypes"."AMVT_ID" = "AmbulatoryVisits"."AMVT_ID" 
inner join "VisitStatus"
on "AmbulatoryVisits"."VisitStatus_ID" = "VisitStatus"."VisitStatus_ID"
where "VisitStatus"."VisitStatus" = 'Canceled'
group by "VisitTypes"."VisitType"
order by count(*) desc
limit 1


--32. Write a query to Count number of patients by VisitdepartmentID where
count greater than 50
select COUNT("Patient_ID"), "VisitDepartmentID" 
from "AmbulatoryVisits"
GROUP BY "VisitDepartmentID"
having COUNT("Patient_ID")>50
order by "VisitDepartmentID"


--33. Write a query to get list of patient names whose visit type is new and visitdepartmentId is 2.
SELECT "Patients"."FirstName", "Patients"."LastName", "VisitTypes"."VisitType", "AmbulatoryVisits"."VisitDepartmentID" 
from "Patients"
inner join "AmbulatoryVisits"
on "Patients"."Patient_ID" = "AmbulatoryVisits"."Patient_ID"
inner join "VisitTypes"
on "AmbulatoryVisits"."AMVT_ID" = "VisitTypes"."AMVT_ID"
where "VisitTypes"."VisitType" = 'New' and "AmbulatoryVisits"."VisitDepartmentID" = 2



--34. Write a query to find the most common reasons for hospital visit for patients between 50 and 60 years.
select "ReasonForVisit"."ReasonForVisit"
from "ReasonForVisit"
inner join "EDVisits"
on "ReasonForVisit"."Rsv_ID" = "EDVisits"."Rsv_ID"
inner join "Patients"
on "EDVisits"."Patient_ID" = "Patients"."Patient_ID"
where age("DateOfBirth") between interval '50 years' and interval '60 years' 
group by "ReasonForVisit"."ReasonForVisit"
order by count("ReasonForVisit"."ReasonForVisit") desc
limit 1


--35. Get list of Patients whose gender is Male and who speak English and whose race is White.
select "Patients"."FirstName", "Patients"."LastName", "Gender"."Gender", "Language"."Language", "Race"."Race"
from "Patients"
inner join "Gender"
on "Patients"."Gender_ID" = "Gender"."Gender_ID"
inner join "Language"
on "Patients"."Language_ID" = "Language"."Language_ID"
inner join "Race"
on "Patients"."Race_ID" = "Race"."Race_ID"
where "Gender"."Gender" = 'Male' and "Language"."Language"= 'English' and "Race"."Race" = 'White'


--36 . Create index on Patient table.
Create Index "Index_FirstName" on public."Patients"("FirstName");


--37. Write a query to get list of Provider ID's where ProviderDateOnStaff year is 2013 and 2010.
    select "Provider_ID","ProviderName","ProviderDateOnStaff”
     FROM public."Providers"
     where public."Providers"."ProviderDateOnStaff" between '2010-01-01' and '2013-12-31'
     order by "ProviderDateOnStaff" desc ;
     
     

--38. Write a query to find out percentage of Ambulatory visits by visit type
select public."AmbulatoryVisits"."AMVT_ID", public."VisitTypes"."VisitType",
count(*)*100/ sum(count(*)) over() as Visit_Percent
from public."AmbulatoryVisits" , public."VisitTypes"
where public."AmbulatoryVisits"."AMVT_ID" = public."VisitTypes"."AMVT_ID"
group by public."AmbulatoryVisits"."AMVT_ID" , public."VisitTypes"."VisitType";


--39.Write a query to get list of patient names who has discharged.
    Select "FirstName" ,"LastName", "EDDisposition"
      From public."Patients",public."EDDisposition",public."EDVisits"
             Where public."Patients"."Patient_ID"=public."EDVisits"."Patient_ID"
             AND public."EDVisits"."EDD_ID"=public."EDDisposition"."EDD_ID"
                   AND public."EDDisposition"."EDDisposition"='Discharged';




--40. Create view on table EdVisit by selecting some columns and filter data using Where condition
create view Acuity_View as
select "Acuity" from public."EDVisits"
where "Acuity">3;
 Select * from Acuity_View;
 

--41.Get list of patient names whose primary diagnosis as 'Spinal Cord injury' having Expected LOS is greater than 15.
select "FirstName","LastName","PrimaryDiagnosis" ,"ExpectedLOS" from public."Patients" pat join public."ReAdmissionRegistry" re on pat."Patient_ID"=re."Patient_ID" join public."PrimaryDiagnosis" pri on pri."Diagnosis_ID"=re."Diagnosis_ID" where pri."PrimaryDiagnosis"='Spinal Cord Injury' and re."ExpectedLOS" >'15';


--42. Write a query to get list of Patient names who haven't discharged
select "Patient_ID","FirstName","LastName" from public."Patients" where "Patient_ID" in (select "Patient_ID" from public."Patients" except ((select "Patient_ID" from public."Discharges") union (select "Patient_ID" from public."AmbulatoryVisits")));
Explanation: Taking all the Ambulatory visits as outpatients and In patients from EDVisits and ReadmissionRegistry. All the discharges patients will be in the discharges tables. All the patients( Outpatients and in patients) will be in Patients table.
In order to get people not discharges from Patients table remove Patient_Id from abulatoryvisits  table and discharges table the result is People who are not discharged


--43. Write a query to get list of Provider names whose Provider Specialty is
Pediatrics.
select "ProviderName","ProviderSpeciality" from public."Providers" Pro join public."ProviderSpeciality" PrSp on Pro."PS_ID"=PrSp. "PS_ID" where Prsp."ProviderSpeciality"='Pediatrics';


--44. Write a query to get list of patient ID's who has admitted on 1/7/2018 and discharged on 1/15/2018.
select "Patient_ID","AdmissionDate","DischargeDate" from public."Discharges" where "AdmissionDate"= '2018-01-07' and date("DischargeDate")= '2018-01-15';


--45. Write a query to find outpatients vs inpatients by monthwise (hint: consider readmission/discharges and ambulatory visits table for inpatients and outpatients)

--Outpatients:
select DATE_TRUNC ('month',"DateofVisit"),TO_CHAR("DateofVisit", 'Month') as Month_name, 
    COUNT (1) As OP_Visitscount 
from public."AmbulatoryVisits" 
where "VisitStatus_ID"='VS002' 
Group BY DATE_TRUNC ('month',"DateofVisit"),TO_CHAR("DateofVisit", 'Month') 
order by DATE_TRUNC ('month',"DateofVisit"),TO_CHAR("DateofVisit", 'Month') 
    desc;
--Inpatient Query:
Select DATE_TRUNC ('month',"AdmissionDate"),TO_CHAR("AdmissionDate", 'Month') as Month_name, 
    COUNT (1) As INP_Visitscount 
from public."ReAdmissionRegistry" where abs("DischargeDate" :: date - "AdmissionDate" :: date)  > 1 
Group BY DATE_TRUNC ('month',"AdmissionDate"),TO_CHAR("AdmissionDate", 'Month') 
order by DATE_TRUNC ('month',"AdmissionDate"),TO_CHAR("AdmissionDate", 'Month') 
    Desc;



--46. Write a query to get list of Number of Ambulatory Visits by Provider Speciality per month.
SELECT public."ProviderSpeciality"."ProviderSpeciality",TO_CHAR(public."AmbulatoryVisits"."DateofVisit", 'month') AS "month" , count (public."AmbulatoryVisits"."AMVT_ID") from public."AmbulatoryVisits", public.
"ProviderSpeciality",public."Providers"  
where (public."ProviderSpeciality"."PS_ID"=public."Providers"."PS_ID" AND public."AmbulatoryVisits"."Provider_ID"=public."Providers"."Provider_ID") 
       GROUP BY "ProviderSpeciality", "month" ORDER BY "ProviderSpeciality", "month" ;
       



--47. Write a query to find Average age for admission by service
select  AVG(AGE(public."Patients"."DateOfBirth")), public."Service"."Service" from
   public."Patients",public."Service",public."ReAdmissionRegistry"
   where(public."Service"."Service_ID" = public."ReAdmissionRegistry"."Service_ID" AND
   public."Patients"."Patient_ID"=public."ReAdmissionRegistry"."Patient_ID") GROUP BY public."Service"."Service" ORDER BY public."Service"."Service"  ;



-- 48.Write a query to get list of patient with their full names whose names contains "Ma"
 select public."Patients"."FirstName",public."Patients"."LastName", CONCAT(public."Patients"."FirstName", ' ' ,public."Patients"."LastName") as "FullName" from public."Patients"  WHERE public."Patients"."FirstName" LIKE '%Ma%' OR public."Patients". "LastName" LIKE '%Ma%';


--49:Update Visit Timestamp column in EDVisits table by selecting data type as timestamp with timezone.
ALTER TABLE public."EDVisits"
ALTER COLUMN "VisitTimestamp"  SET DATA TYPE  timestamptz ;

--50. Write a create a trigger function on AmbulatoryVisits by selecting any two Columns.
CREATE  FUNCTION rec_insert_AmbulatoryVisit()
  RETURNS trigger AS
$$
BEGIN

        Select "Visit_ID","Patient_ID" where "Visit_ID"= NEW."Visit_ID";
        
    RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';


CREATE TRIGGER Select_rec_AmbulatoryVisit
  AFTER INSERT
  ON public."AmbulatoryVisits"
  FOR EACH ROW
  EXECUTE PROCEDURE rec_insert_AmbulatoryVisit();
  

--51. Insert number of days for Readmission in DaysToReadmission Column for patient ID's from 737 to 742 (use any random value -16).
select * from "ReAdmissionRegistry"
where "Patient_ID" between 737 and 742
update "ReAdmissionRegistry"
set "DaysToReadmission" = 16
where "Patient_ID"  between 737 and 742


--52. Get list of Provider names whose name is starting with K and ending with y (Hint:K-Upper, Y-Lower).
select "Providers"."ProviderName"
from "Providers"
where "ProviderName" like 'K%y'

 
--53. Write a query to Split provider First name and Last name into different column
SELECT 
  "ProviderName",
  split_part("ProviderName", ' ', 1) AS "firstName", 
  split_part("ProviderName", ' ', 2)  AS "lastName"
FROM "Providers";



--54. Get list of Patient ID's order by Discharge date
select "Patients"."Patient_ID", "Discharges"."DischargeDate"
from "Patients"
inner join "Discharges"
on "Patients"."Patient_ID" = "Discharges"."Patient_ID"        
order by "DischargeDate"  


--55. Write a query to drop View by creating view on table Discharge by selecting columns.
create or replace view discharge_view as
select *
from "Discharges"

select * from discharge_view


--56.Write a query to get list of Patient ID's where Visitdepartment ID is 1 and BloodPressureSystolic is between 123 to 133
select public."Patients"."Patient_ID", "FirstName" ,"LastName",
"VisitDepartmentID","BloodPressureSystolic"
from public."Patients",public."AmbulatoryVisits”
where public."Patients"."Patient_ID"=public."AmbulatoryVisits"."Patient_ID"
And "VisitDepartmentID" = 1
And "BloodPressureSystolic" between 123 and 133;



--57.    Write the query to create Index on table ReasonForVisit by selecting a column and also write the query drop same index
Create Index Index_Rsv_ID On public."ReasonForVisit"("Rsv_ID");
DROP Index Index_Rsv_ID;

--58. Write a query to Count number of unique patients EDDisposition wise.
select public."EDDisposition"."EDDisposition", count( Distinct public."EDVisits"."Patient_ID" )
  from public."EDVisits",public."EDDisposition"
   where  public."EDVisits"."EDD_ID"= public."EDDisposition"."EDD_ID"
   and  public."EDVisits"."EDD_ID" = 'EDD01'
	Group by public."EDDisposition"."EDDisposition" 	
  UNION
   select public."EDDisposition"."EDDisposition", count( Distinct public."EDVisits"."Patient_ID" )
   from public."EDVisits",public."EDDisposition"
   where  public."EDVisits"."EDD_ID"= public."EDDisposition"."EDD_ID"
   and  public."EDVisits"."EDD_ID" = 'EDD02'
   Group by public."EDDisposition"."EDDisposition";
   

--59. Write a query to get list of Patient ID's where Visitdepartment ID is 5 or BloodPressureSystolic is NOT NULL
select  "Patient_ID"
               FROM public."AmbulatoryVisits"
	where "BloodPressureSystolic" IS NOT NULL
	or  "VisitDepartmentID"=5;
    

--60.  Query to find the number of patients readmitted by Service
 Select Count("Patient_ID") AS Patient_Count,"Service"
 from public."ReAdmissionRegistry",public."Service"
 Where public."ReAdmissionRegistry". "Service_ID"=public."Service"."Service_ID"
 And public."ReAdmissionRegistry"."ReadmissionFlag"=1
 group by("Service");
 

--61. Write a query to list male patient ids and their names who are above 40years of age and less than 60 years and have BloodPressureSystolic above 120 and BloodPressureDiastolic above 80
Select P."FirstName",P."LastName", P."Patient_ID" ,"Gender", (SELECT date_part('year',AGE(CURRENT_DATE,date(P."DateOfBirth"))) as Patient_age ), A."BloodPressureSystolic", A."BloodPressureDiastolic"
from public."Patients" P join public."Gender" G on P."Gender_ID" = G."Gender_ID"
join public."AmbulatoryVisits" A on P."Patient_ID"= A."Patient_ID"
where G."Gender"= 'Male' and A."BloodPressureSystolic" > 120 and A."BloodPressureDiastolic" >80  and ((SELECT date_part('year',AGE(CURRENT_DATE,date(P."DateOfBirth"))))between 40 and 60 );
 


--62. Query to find the number of out patients who have visited month wise(use month names)
select TO_CHAR("DateofVisit", 'Month') as Month_name, COUNT (1) As OP_Visitscount from public."AmbulatoryVisits"
where "VisitStatus_ID"='VS002' Group BY Month_name 
order by Month_name 
desc;


--63. Write a query to get list of patient ID's whose BloodPressureSystolic is 131,137,138.
select P."Patient_ID",A."BloodPressureSystolic" from public."Patients" P join public."AmbulatoryVisits" A on P."Patient_ID"= A."Patient_ID"
where A."BloodPressureSystolic" in (131,137,138)


--64. Query to classify expected LOS into 3 categories as per the duration. (Hint:Use of CASE statement)
select  "Patient_ID","ExpectedLOS",
        CASE 
       when "ExpectedLOS" <= 5.0 Then 'category-1' 
        when "ExpectedLOS" <= 10.0 Then 'category-2' 
        else 'category-3'
        END 
        AS LOS_Category_Description 
    from public."ReAdmissionRegistry" order by LOS_Category_Description



--65. Write a query to create a table to list the names of patients whose date of birth is later than 1st jan 1960.Name the table as “Persons”.
DROP TABLE IF EXISTS public."Persons";
    CREATE TABLE public."Persons" AS select P."FirstName",P."LastName", P."Patient_ID", P."DateOfBirth" from public."Patients" P
	where P."DateOfBirth" > '1/1/1960'




-- 66. Write a query to Count number of patients who has discharged after march3rd 2018
SELECT  count(public."Discharges"."Patient_ID") 
from public."Discharges" WHERE "DischargeDate" > '2018-03-04' ;


--67. Replace ICU with emergency (Hint: Do not update or alter the table)
SELECT   REPLACE ( 'emergency', 'emergency', 'ICU' );


--68:. Write a query to get Sum of ExpectedLOS for Service_ID 'SID01'
select SUM(public."ReAdmissionRegistry"."ExpectedLOS") from public."ReAdmissionRegistry" where public."ReAdmissionRegistry"."Service_ID" = 'SID01';


--69:Create index on table Provider by selecting a column and filter by using WHERE condition.
CREATE  INDEX Provider_index
ON public."Providers" ("PS_ID")
WHERE "PS_ID" = 'PSID01';



--70. List down all triggers in our HealthDB database
SELECT  event_object_table AS table_name ,trigger_name                          
FROM information_schema.triggers  
GROUP BY table_name , trigger_name 
ORDER BY table_name ,trigger_name 


--71. Partition the table according to Service_ID and use windows function to calculate percent rank. Order by ExpectedLOS.
SELECT
    "Patient_ID",
	"Service_ID",
	"ExpectedLOS",
	RANK () OVER ( 
		PARTITION BY "Service_ID"
		ORDER BY "ExpectedLOS" DESC
	) ExpectedLOS_rank 
FROM
	"ReAdmissionRegistry"



--72. Write a query by using common table expressions and case statements to display birthyear ranges.
create view year_view as
select "Patient_ID", "DateOfBirth", date_part('year', age("DateOfBirth")) as age_in_years
from "Patients"

select * from year_view

WITH cte_birthyear AS (
    SELECT 
        "Patient_ID",
        "DateOfBirth",
        (CASE 
            WHEN age_in_years < 42.0 THEN '1980s born'
            WHEN age_in_years < 52.0 THEN '1970s born'
            WHEN age_in_years < 63.0 THEN '1960s born'
            ELSE 'not in range'
        END) age_in_years
    
    FROM
        year_view
)
SELECT
    "Patient_ID",
    "DateOfBirth",
     age_in_years
FROM 
    cte_birthyear
WHERE
    age_in_years = '1970s born'
ORDER BY 
    "Patient_ID"; 
    


--73. Get list of Provider names whose ProviderSpeciality is Surgery 
select "Providers"."ProviderName", "ProviderSpeciality"."ProviderSpeciality"
from "Providers"
inner join "ProviderSpeciality"
on "Providers"."PS_ID" = "ProviderSpeciality"."PS_ID"
WHERE "ProviderSpeciality"."ProviderSpeciality" = 'Surgery'


--74. List of patient from rows 11-20 without using where condition. 
select "FirstName", "LastName", "Patient_ID"
from "Patients"
OFFSET 10 ROWS 
FETCH FIRST 10 ROW ONLY;  


--75. Give a query how to find triggers from table AmbulatoryVisits
SELECT  event_object_table AS table_name ,trigger_name         
FROM information_schema.triggers  
WHERE event_object_table = 'AmbulatoryVisits' 
GROUP BY table_name , trigger_name 
ORDER BY table_name ,trigger_name


--76. Recreate the below expected output using Substring.
 SELECT  "Gender" , SUBSTRING("Gender" ,1,1) FROM public."Gender";


--77. Obtain the below output by grouping the Patients.
SELECT "FirstName"  , SUBSTRING("FirstName" , 1, 1) patient_group
            	FROM public."Patients"
 WHERE SUBSTRING("FirstName" , 1, 1) = 'L';


--78.Please go through the below screenshot and create the exact output.
SELECT   "FirstName" , char_length("FirstName") as unknown
	FROM public."Patients";
    

--79.   Please go through the below screenshot and create the exact output
     Select "BloodPressureDiastolic", "Pulse", ROUND("BloodPressureDiastolic")  As bpd,
 TRUNC("Pulse") as heatrate
            	FROM public."AmbulatoryVisits";
 


--80.Please go through the below screenshot and create the exact output
SELECT  "BloodPressureSystolic" ,
CONCAT('The Systolic Blood Pressure is ' , "BloodPressureSystolic" , '.00')
            	FROM public."AmbulatoryVisits";




















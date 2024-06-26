-----------------------SQL : Insurance Claim Analysis: Mini Case study--

--Insurance Claim Analysis: Demographic and Health Factors- Impact on Risk and Severity of Insurance Claim¶ 

--Column name Description--

Diabetic Whether the insured person is diabetic or not. (Boolean)

Children Number of children of the insured person. (Integer)

Smoker Whether the insured person is a smoker or not. (Boolean)

Claim Amount of the insurance claim. (Float)


SELECT * FROM [Excercise].[dbo].[insurance_data]




-- 1.Show records of 'male' patient from 'southwest' region.

SELECT * 
FROM insurance_data
WHERE gender= 'male' AND region ='southwest'




-- 2.Show all records having bmi in range 30 to 45 both inclusive.

SELECT * FROM insurance_data
WHERE bmi BETWEEN 30 AND 45



--3.Show minimum and maximum bloodpressure of diabetic patient who smokes. Make column names as MinBP and MaxBP respectively.


SELECT MIN(bloodpressure) AS MinBP, MAX(bloodpressure) AS MaxBP  
FROM insurance_data
WHERE diabetic=1 AND smoker='Yes';



-- 4.Find no of unique patients who are not from southwest region. - 

SELECT COUNT(DISTINCT PatientID) 
FROM insurance_data
WHERE region <> 'southwest'

-------------OR-------------------
SELECT COUNT(DISTINCT(PatientID)) 
FROM insurance_data 
WHERE region NOT IN ('southwest');

-------------OR-------------------
SELECT COUNT(DISTINCT(PatientID)) 
FROM insurance_data 
WHERE region != 'southwest';


-- 5.Total claim amount from male smoker.  

SELECT ROUND(SUM(claim),2) AS 'Total_Claim_Amount-Male_Smoker' 
FROM insurance_data
WHERE smoker= 'Yes' AND gender = 'male'

--OR---
SELECT SUM(claim) FROM insurance_data WHERE gender = 'male' AND smoker ='Yes';




-- 6.Select all records of south region.

SELECT * FROM insurance_data
WHERE region LIKE '%south%'
------------OR----------------
SELECT * FROM insurance_data
WHERE region IN ('southeast', 'southwest')

------------OR----------------
SELECT * FROM insurance_data
WHERE region LIKE 'South%'

-- 7.No of patient having normal blood pressure. 

SELECT COUNT(*) AS num_patient FROM insurance_data
WHERE bloodpressure BETWEEN 90 AND 120;



-- 8.No of pateint below 17 years of age having normal blood pressure as per below formula - 5 -- BP normal range = 80+(age in years × 2) to 100 + (age in years × 2) -- 
--------------Note: Formula taken just for practice, don't take in real sense.-----------------------

SELECT COUNT(*) FROM insurance_data WHERE age < 17 AND bloodpressure BETWEEN 80+(age*2) AND 100 +(age*2);



-- 9.What is the average claim amount for non-smoking female patients who are diabetic? 

SELECT AVG(claim) 
FROM insurance_data
WHERE gender= 'female' AND smoker ='No' AND diabetic= 'False'






-- 10.Write a SQL query to update the claim amount for the patient with PatientID = 1234 to 5000.

 

 UPDATE insurance_data
 SET claim=5000
 WHERE PatientID= (SELECT PatientID FROM insurance_data
WHERE PatientID = 1234)




-- 11.Write a SQL query to delete all records for patients who are smokers and have no children.

SELECT * FROM insurance_data 

--Sub Query Problem 

--How many patients have claimed more than the average claim amount for patients who are smokers and have at least one child, and belong to the southeast region?

SELECT COUNT(*) No_Patients FROM insurance_data
WHERE smoker ='Yes' AND children= 1 AND region= 'southeast' AND claim > (SELECT AVG(claim) FROM insurance_data) 
 



--Problem 12
--How many patients have claimed more than the average claim amount for patients who are not smokers and have a BMI greater than the average BMI for patients who have at least one child?


SELECT COUNT(DISTINCT PatientID) AS num_patients
FROM insurance_data
WHERE smoker = 'No' AND children > 0
  AND bmi > (SELECT AVG(bmi) FROM insurance_data WHERE children > 0 AND smoker = 'No')
  AND claim > (SELECT AVG(claim) FROM insurance_data WHERE children > 0 AND smoker = 'No')


 



--Problem 13
--How many patients have claimed more than the average claim amount for patients who have a BMI greater than the average BMI for patients who are diabetic, have at least one child, and are from the southwest region?

SELECT COUNT(DISTINCT PatientID)  AS num_patients FROM insurance_data
WHERE children >0 AND region = 'southwest'
AND claim > (SELECT AVG(claim) FROM insurance_data WHERE children >0 AND region = 'southwest')
AND bmi > (SELECT AVG(bmi) FROM insurance_data WHERE  children >0 AND region = 'southwest')

--Problem 14:
--What is the difference in the average claim amount between patients who are smokers and patients who are non-smokers, and have the same BMI and number of children?


 SELECT
    AVG(CASE WHEN Smoker = 'yes' THEN Claim ELSE 0 END) AS avg_claim_amount_smokers,
    AVG(CASE WHEN Smoker = 'no' THEN Claim ELSE 0 END) AS avg_claim_amount_non_smokers,
    AVG(CASE WHEN Smoker = 'yes' THEN Claim ELSE 0 END) - AVG(CASE WHEN Smoker = 'no' THEN Claim ELSE 0 END) AS difference_in_average_claim_amount
FROM insurance_data
GROUP BY bmi, Children;
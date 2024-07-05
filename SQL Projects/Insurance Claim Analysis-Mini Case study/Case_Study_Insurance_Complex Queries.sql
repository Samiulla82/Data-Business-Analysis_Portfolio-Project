

----Note: Try to avoid GROUP BY clause to solve the problems

--Problem 1: What are the top 5 patients who claimed the highest insurance amounts?

WITH RankedClaim AS (
SELECT PatientID, claim,
       RANK() OVER( ORDER BY claim DESC ) Highest_Claimer
FROM insurance_data
)
SELECT 
	PatientID, claim FROM RankedClaim
WHERE 
	Highest_Claimer <= 5;


--Problem 2: What is the average insurance claimed by patients based on the number of children they have?

SELECT 
    children, 
    claim,
    AVG(claim) OVER (PARTITION BY children) AS Average_Claim
FROM 
    insurance_data
ORDER BY 
    children;

--Problem 3: What is the highest and lowest claimed amount by patients in each region?


SELECT  *,
	MIN(claim) OVER(PARTITION BY region) AS Min_Claim_Reg,
	MAX(claim) OVER(PARTITION BY region) AS MAX_Claim_Reg 
FROM 
	insurance_data
WHERE	
	region IS NOT NULL


-----------------OR-------------------

SELECT DISTINCT(region),
MIN(claim) OVER(PARTITION BY region) AS Min_Claim_Reg,
MAX(claim) OVER(PARTITION BY region) AS MAX_Claim_Reg FROM insurance_data
WHERE region IS NOT NULL



--Problem 4: What is the percentage of smokers in each age group?

SELECT *,
COUNT(PatientID) OVER (ORDER BY smoker DESC) AS Total_claimant,
COUNT(PatientID) OVER (PARTITION BY smoker) AS 'Count_of_claiment',
(CAST((COUNT(PatientID) OVER (PARTITION BY smoker))AS FLOAT)/COUNT(PatientID) OVER (ORDER BY smoker DESC))*100
FROM insurance_data 





--Problem 5: What is the difference between the claimed amount of each patient and the first claimed amount of that patient?

SELECT 
    PatientID,
    claim,
    FIRST_VALUE(claim) OVER (PARTITION BY PatientID ORDER BY PatientID) AS First_Claim,
    claim - FIRST_VALUE(claim) OVER (PARTITION BY PatientID ORDER BY PatientID ) AS Difference_From_First_Claim
FROM 
    insurance_data
ORDER BY 
    PatientID


--Problem 6: For each patient, calculate the difference between their claimed amount and the average claimed amount of patients with the same number of children.

WITH AverageClaimed AS(
SELECT *,
AVG(claim) OVER(PARTITION BY  children ORDER BY children ) AS Avg_claim_amount
FROM insurance_data
)
SELECT i.PatientID, i.claim, i.children, a.Avg_claim_amount
FROM insurance_data i
JOIN AverageClaimed AS a ON i.children=a.children
ORDER BY
i.PatientID




--Problem 7: Show the patient with the highest BMI in each region and their respective rank.

WITH RankedPatientsBMIs AS (
SELECT  PatientID, bmi, region,
		ROW_NUMBER() OVER(PARTITION BY region ORDER BY bmi DESC ) AS RankedPatientsBMI
FROM insurance_data 
)

SELECT 
PatientID, bmi, region, RankedPatientsBMI
FROM 
RankedPatientsBMIs
WHERE RankedPatientsBMI=1
ORDER BY region






--Problem 8: Calculate the difference between the claimed amount of each patient and the claimed amount of the patient who has the highest BMI in their region.


WITH MaxBmiPatients AS (
    SELECT 
        region,
        PatientID,
        bmi,
        claim AS MaxBmiClaim,
        RANK() OVER (PARTITION BY region ORDER BY bmi DESC) AS Highest_BMI
    FROM 
        insurance_data
)
SELECT 
    i.PatientID,
    i.region,
    i.claim,
    m.MaxBmiClaim,
    i.claim - m.MaxBmiClaim AS Difference_From_MaxBmiClaim
FROM 
    insurance_data i
JOIN 
    (SELECT region, MaxBmiClaim FROM MaxBmiPatients WHERE Highest_BMI = 1) m
ON 
    i.region = m.region
ORDER BY 
    i.PatientID;

--Problem 9: For each patient, calculate the difference in claim amount between the patient and the patient with the highest claim amount among patients with the same bmi and smoker status, within the same region. Return the result in descending order difference.

SELECT *,
FIRST_VALUE(claim) OVER(PARTITION BY region, smoker,bmi ORDER BY claim DESC) as Highest_Claim_Region,
ROUND((FIRST_VALUE(claim) OVER(PARTITION BY region, smoker,bmi ORDER BY bmi ASC ))-claim,1)
FROM insurance_data






--Problem 10: For each patient, find the maximum BMI value among their next three records (ordered by age).


SELECT 
    PatientID,
    age,
    bmi,
    MAX(bmi) OVER(PARTITION BY PatientID ORDER BY age ASC ROWS BETWEEN 1 FOLLOWING AND 3 FOLLOWING) AS Max_BMI_Next_3_Records
FROM 
    insurance_data;



--Problem 11: For each patient, find the rolling average of the last 2 claims.

SELECT *,
AVG(claim) OVER()
FROM insurance_data

SELECT 
    PatientID, 
    claim,
    AVG(claim) OVER(PARTITION BY PatientID ORDER BY age ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS Rolling_Avg_Last_2_Claims
FROM 
    insurance_data;




--Problem 12: Find the first claimed insurance value for male and female patients, within each region order the data by patient age in ascending order, and only include patients who are non-diabetic and have a bmi value between 25 and 30.

WITH First_claims AS (
SELECT region, gender, age,claim,
FIRST_VALUE(claim) OVER(PARTITION BY region, gender  ORDER BY age ASC) As First_claim
FROM insurance_data
WHERE diabetic = 0 AND bmi BETWEEN 25 AND 30 AND region IS NOT NULL
)

SELECT DISTINCT region, gender, First_claim 
FROM First_claims
WHERE claim=First_claim
ORDER BY region, gender;




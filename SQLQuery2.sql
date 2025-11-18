--Step1:Creating database in SQL Server.
CREATE  DATABASE HealthCareClaims;
GO
USE HealthCareClaims;
GO
--Step2:Creating Claims Table
-- CREATE TABLE claims (
--   claim_id VARCHAR(10),
--   member_id VARCHAR(10),
--   claim_date DATE,
--   provider_type VARCHAR(50),
--   diagnosis_group VARCHAR(50),
--   procedure_category VARCHAR(50),
--   place_of_service VARCHAR(50),
--   paid_amount DECIMAL(10,2),
--   copay_amount DECIMAL(10,2),
--   state VARCHAR(10),
--   age_group VARCHAR(10),
--   gender VARCHAR(10)
-- );

-- Step3 Insert your sample data.
INSERT INTO claims VALUES ('C001','M101','2024-01-05','Hospital','Diabetes','Lab Test','Inpatient',1200,30,'NY','35-49','F');
INSERT INTO claims VALUES ('C002','M102','2024-01-10','Clinic','Hypertension','Consultation','Outpatient',250,20,'NJ','50-64','M');
INSERT INTO claims VALUES ('C003','M103','2024-01-12','Pharmacy','General','Medication','Outpatient',45,10,'NY','18-34','F');
INSERT INTO claims VALUES ('C004','M104','2024-01-15','Hospital','Cancer','Surgery','Inpatient',8200,100,'PA','65+','F');
INSERT INTO claims VALUES ('C005','M105','2024-01-18','ER','General','Consultation','ER',1500,50,'NY','35-49','M');
INSERT INTO claims VALUES ('C006','M106','2024-01-22','Lab','Diabetes','Lab Test','Outpatient',300,15,'NJ','18-34','F');
INSERT INTO claims VALUES ('C007','M107','2024-01-30','Hospital','Hypertension','Consultation','Inpatient',1800,25,'NY','50-64','M');
INSERT INTO claims VALUES ('C008','M108','2024-02-02','Clinic','General','Consultation','Outpatient',200,20,'PA','35-49','F');
INSERT INTO claims VALUES ('C009','M109','2024-02-05','Pharmacy','Hypertension','Medication','Outpatient',75,5,'NJ','35-49','M');
INSERT INTO claims VALUES ('C010','M110','2024-02-07','ER','Cancer','Consultation','ER',2400,60,'NY','65+','F');
--Step4 Run the SQL queries
--1️ Total Paid & Copay:
SELECT SUM(paid_amount) AS total_paid,
       SUM(copay_amount) AS total_copay
FROM claims;
--2️ Total Claims:
SELECT COUNT(*) AS total_claims FROM claims;
--3  Average Cost
SELECT AVG(paid_amount) AS avg_cost_per_claim FROM claims;
--5.1 — SQL Query: Cost by Diagnosis Group
--Following code identify which desease cost the most 
SELECT 
    diagnosis_group,
    COUNT(*) AS total_claims,
    SUM(paid_amount) AS total_paid_amount,
    AVG(paid_amount) AS avg_cost_per_claim
FROM claims
GROUP BY diagnosis_group
ORDER BY total_paid_amount DESC;

--5.2 — SQL Query: Cost by Provider Type
SELECT 
    provider_type,
    COUNT(*) AS total_claims,
    SUM(paid_amount) AS total_paid_amount,
    AVG(paid_amount) AS avg_cost_per_claim
FROM claims
GROUP BY provider_type
ORDER BY total_paid_amount DESC;
--5.3 — SQL Query: Place of Service Cost (ER vs Inpatient vs Outpatient)
SELECT 
    place_of_service,
    COUNT(*) AS total_visits,
    SUM(paid_amount) AS total_cost,
    AVG(paid_amount) AS avg_cost
FROM claims
GROUP BY place_of_service
ORDER BY total_cost DESC;
--STEP 6 — ADVANCED SQL ANALYSIS
-- 6.1 — Identify High-Cost Claims (Top Expensive Claims)
--This is used by Utilization Management, Cost Containment, and Claims Operations.
-- Below code result shows Meaning: Shows the 5 highest-cost claims.
SELECT TOP 5
    claim_id,
    member_id,
    diagnosis_group,
    place_of_service,
    paid_amount
FROM claims
ORDER BY paid_amount DESC;
--✅ 6.2 — High-Cost Members (Members Driving Cost)
--This analysis is used by Population Health, Case Management, and Chronic Disease Teams.
--Meaning: Finds members who cost the health plan the most.
SELECT
    member_id,
    COUNT(*) AS total_claims,
    SUM(paid_amount) AS total_cost,
    AVG(paid_amount) AS avg_cost_per_claim
FROM claims
GROUP BY member_id
ORDER BY total_cost DESC;
--✅ 6.3 — Cost by Age Group & Gender
--This is used a LOT in public health, Medicare/Medicaid analysis.
--Meaning: Shows which age groups or genders have higher costs.
SELECT
    age_group,
    gender,
    SUM(paid_amount) AS total_cost,
    AVG(paid_amount) AS avg_cost_per_claim,
    COUNT(*) AS claim_count
FROM claims
GROUP BY age_group, gender
ORDER BY total_cost DESC;
--✅ 6.4 — Identify Repeated Diagnoses for a Member
--Used for clinical review + potential fraud/waste.
--Meaning: Shows repeated visits for the same condition.
SELECT
    member_id,
    diagnosis_group,
    COUNT(*) AS visit_count,
    SUM(paid_amount) AS total_paid
FROM claims
GROUP BY member_id, diagnosis_group
HAVING COUNT(*) > 1
ORDER BY total_paid DESC;
--OPTIONAL BUT IMPRESSIVE
--Healthcare analysts often run threshold checks.
--6.5 — Claims Above $2,000 (High-Risk Claims)
--This is useful for cost containment.
SELECT *
FROM claims
WHERE paid_amount > 2000
ORDER BY paid_amount DESC;










--  Snowflake for Healthcare Analytics: Leveraging Clinical and Patient Data for Insights and Decision-making

"Patient Demographics" table and the "Clinical Data" table needs to be created:

CREATE TABLE patient_demographics (
    patient_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_date DATE,
    gender VARCHAR(10),
    address VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(20),
    zip_code VARCHAR(10)
);


CREATE TABLE clinical_data (
    patient_id INT,
    encounter_date DATE,
    diagnosis_code VARCHAR(20),
    procedure_code VARCHAR(20),
    medication_code VARCHAR(20),
    physician_id INT
);


INSERT INTO patient_demographics (patient_id, first_name, last_name, birth_date, gender, address, city, state, zip_code)
VALUES
    (1, 'John', 'Doe', '1980-05-25', 'Male', '123 Main St', 'Anytown', 'NY', '12345'),
    (2, 'Jane', 'Smith', '1975-08-12', 'Female', '456 Elm St', 'Anycity', 'CA', '67890'),
    (3, 'Michael', 'Johnson', '1990-03-15', 'Male', '789 Maple Ave', 'Anothercity', 'TX', '56789'),
    (4, 'Emily', 'Brown', '1985-11-20', 'Female', '321 Oak St', 'Yetanothercity', 'FL', '98765'),
    -- Add more sample data rows here...
    (97, 'William', 'Martinez', '1978-09-08', 'Male', '555 Cedar St', 'Newcity', 'WA', '45678'),
    (98, 'Sophia', 'Garcia', '1987-06-17', 'Female', '888 Pine St', 'Nextcity', 'GA', '34567'),
    (99, 'Daniel', 'Lopez', '1995-02-14', 'Male', '999 Birch St', 'Lastcity', 'MI', '23456'),
    (100, 'Olivia', 'Rodriguez', '1983-07-23', 'Female', '111 Walnut St', 'Finalcity', 'PA', '12345');



INSERT INTO clinical_data (patient_id, encounter_date, diagnosis_code, procedure_code, medication_code, physician_id)
VALUES
    (1, '2023-01-01', '12345', '67890', 'ABC123', 101),
    (2, '2023-01-02', '67890', '23456', 'XYZ456', 202),
    (3, '2023-01-03', '54321', '09876', 'ZYX321', 303),
    (4, '2023-01-04', '98765', '65432', 'CBA987', 404),
    -- Add more sample data rows here...
    (97, '2023-04-15', '12345', '67890', 'ABC123', 101),
    (98, '2023-04-16', '67890', '23456', 'XYZ456', 202),
    (99, '2023-04-17', '54321', '09876', 'ZYX321', 303),
    (100, '2023-04-18', '98765', '65432', 'CBA987', 404);


-- Query to calculate average patient age:

SELECT AVG(DATEDIFF(YEAR, birth_date, CURRENT_DATE())) AS avg_patient_age
FROM patient_demographics;



--This query calculates the average age of patients grouped by gender. It uses the DATEDIFF function to calculate the age based on the birth date and the current date.

SELECT
    gender,
    AVG(DATEDIFF(YEAR, birth_date, CURRENT_DATE())) AS avg_age
FROM
    patient_demographics
GROUP BY
    gender;
	
	
	
--This query counts the number of encounters (appointments, visits) grouped by diagnosis code. It provides insights into the frequency of different medical conditions seen in clinical encounters.


SELECT
    diagnosis_code,
    COUNT(*) AS encounter_count
FROM
    clinical_data
GROUP BY
    diagnosis_code
ORDER BY
    encounter_count DESC;


--Analyze Patient Demographics and Clinical Encounters

This query joins the "patient_demographics" table with the "clinical_data" table based on the common "patient_id" column. It selects relevant columns from both tables, including patient demographics (such as first name, last name, gender, and birth date) and clinical encounter details (such as encounter date, diagnosis code, procedure code, and medication code). The results are ordered by patient ID and encounter date.

By running this query, you can gain insights into the relationships between patient demographics and their corresponding clinical encounters, which can be valuable for understanding patient health profiles and treatment patterns.


SELECT
    pd.patient_id,
    pd.first_name,
    pd.last_name,
    pd.gender,
    pd.birth_date,
    cd.encounter_date,
    cd.diagnosis_code,
    cd.procedure_code,
    cd.medication_code
FROM
    patient_demographics pd
JOIN
    clinical_data cd ON pd.patient_id = cd.patient_id
ORDER BY
    pd.patient_id, cd.encounter_date;
	
##############################################################

Below is a complex query that combines patient demographics and clinical data to analyze patient health profiles and identify patterns in clinical encounters:


WITH patient_encounter_stats AS (
    SELECT
        pd.patient_id,
        pd.first_name,
        pd.last_name,
        pd.gender,
        COUNT(*) AS total_encounters,
        MAX(cd.encounter_date) AS latest_encounter_date,
        MIN(cd.encounter_date) AS earliest_encounter_date,
        AVG(DATEDIFF('day', cd.encounter_date, CURRENT_DATE())) AS avg_days_since_last_encounter
    FROM
        patient_demographics pd
    JOIN
        clinical_data cd ON pd.patient_id = cd.patient_id
    GROUP BY
        pd.patient_id, pd.first_name, pd.last_name, pd.gender
)
SELECT
    patient_id,
    first_name,
    last_name,
    gender,
    total_encounters,
    earliest_encounter_date,
    latest_encounter_date,
    avg_days_since_last_encounter
FROM
    patient_encounter_stats
ORDER BY
    total_encounters DESC;


In this query:
- We first join the "patient_demographics" table with the "clinical_data" table based on the common "patient_id" column.
- We calculate statistics such as the total number of encounters, the earliest and latest encounter dates, and the average days since the last encounter for each patient.
- We use a common table expression (CTE) named "patient_encounter_stats" to calculate these statistics efficiently.
- Finally, we select and order the results to provide insights into patient demographics and their clinical encounters, ordered by the total number of encounters in descending order.

This query provides valuable insights into patient health profiles, including their engagement with clinical services over time. Adjust the query as needed based on your specific healthcare analytics requirements and data schema.
-- Create medication_stock table

CREATE TABLE medication_stock (
    medication_id SERIAL PRIMARY KEY,
    medication_name VARCHAR(100) NOT NULL,
    quantity INTEGER NOT NULL
);

-- Insert sample values into medication_stock
INSERT INTO medication_stock (medication_name, quantity) VALUES
('Aspirin', 100),
('Insulin', 50),
('Metformin', 75),
('Lisinopril', 120),
('Warfarin', 60),
('Atorvastatin', 200),
('Levothyroxine', 85),
('Amlodipine', 95);



-- Q1: List all patients name and ages
SELECT name, age FROM patients;

-- Q2: List all doctors specializing in 'Cardiology'
SELECT name FROM doctors WHERE specialization = 'Cardiology';

-- Q3: Find all patients that are older than 80
SELECT * FROM patients WHERE age > 80;

-- Q4: List all the patients ordered by their age (youngest first)
SELECT * FROM patients ORDER BY age ASC;

-- Q5: Count the number of doctors in each specialization
SELECT specialization, COUNT(*) AS doctor_count 
FROM doctors 
GROUP BY specialization;

-- Q6: List patients and their doctors' names
SELECT p.name AS patient_name, d.name AS doctor_name
FROM patients p
JOIN doctors d ON p.doctor_id = d.doctor_id;

-- Q7: Show treatments along with patient names and doctor names
SELECT t.treatment_type, p.name AS patient_name, d.name AS doctor_name
FROM treatments t
JOIN patients p ON t.patient_id = p.patient_id
JOIN doctors d ON p.doctor_id = d.doctor_id;

-- Q8: Count how many patients each doctor supervises
SELECT d.name, COUNT(p.patient_id) AS patient_count
FROM doctors d
LEFT JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.name;

-- Q9: List the average age of patients and display it as average_age
SELECT AVG(age) AS average_age FROM patients;

-- Q10: Find the most common treatment type, and display only that
SELECT treatment_type, COUNT(*) AS count
FROM treatments
GROUP BY treatment_type
ORDER BY count DESC
LIMIT 1;

-- Q11: List patients who are older than the average age of all patients
SELECT * FROM patients 
WHERE age > (SELECT AVG(age) FROM patients);

-- Q12: List all the doctors who have more than 5 patients
SELECT d.name, COUNT(p.patient_id) AS patient_count
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.name
HAVING COUNT(p.patient_id) > 5;

-- Q13: List all the treatments that are provided by nurses that work in the morning shift
SELECT t.treatment_type, p.name AS patient_name
FROM treatments t
JOIN nurses n ON t.nurse_id = n.nurse_id
JOIN patients p ON t.patient_id = p.patient_id
WHERE n.shift = 'Morning';

-- Q14: Find the latest treatment for each patient
SELECT p.name, MAX(t.treatment_time) AS latest_treatment
FROM patients p
LEFT JOIN treatments t ON p.patient_id = t.patient_id
GROUP BY p.name;

-- Q15: List all the doctors and average age of their patients
SELECT d.name, AVG(p.age) AS average_age
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.name;

-- Q16: List the names of the doctors who supervise more than 3 patients
SELECT d.name
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.name
HAVING COUNT(p.patient_id) > 3;

-- Q17: List all the patients who have not received any treatments
SELECT * FROM patients 
WHERE patient_id NOT IN (SELECT patient_id FROM treatments);

-- Q18: First create and populate medication_stock table
CREATE TABLE medication_stock (
    medication_id SERIAL PRIMARY KEY,
    medication_name VARCHAR NOT NULL,
    quantity INT NOT NULL
);

INSERT INTO medication_stock (medication_name, quantity) VALUES
('Aspirin', 100),
('Insulin', 50),
('Metformin', 75),
('Lisinopril', 120);

-- Then list medicines with stock less than average
SELECT * FROM medication_stock 
WHERE quantity < (SELECT AVG(quantity) FROM medication_stock);

-- Q19: For each doctor, rank their patients by age
SELECT d.name AS doctor_name, 
       p.name AS patient_name, 
       p.age,
       RANK() OVER (PARTITION BY d.doctor_id ORDER BY p.age DESC) AS age_rank
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id;

-- Q20: For each specialization, find the doctor with the oldest patient
WITH RankedPatients AS (
    SELECT d.specialization,
           d.name AS doctor_name,
           p.name AS patient_name,
           p.age,
           RANK() OVER (PARTITION BY d.specialization ORDER BY p.age DESC) AS rank
    FROM doctors d
    JOIN patients p ON d.doctor_id = p.doctor_id
)
SELECT specialization, doctor_name, patient_name, age
FROM RankedPatients
WHERE rank = 1;







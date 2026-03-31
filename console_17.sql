CREATE TABLE patients (
                          patient_id SERIAL PRIMARY KEY,
                          full_name VARCHAR(100),
                          phone VARCHAR(20),
                          city VARCHAR(50),
                          symptoms TEXT[]
);

CREATE TABLE doctors (
                         doctor_id SERIAL PRIMARY KEY,
                         full_name VARCHAR(100),
                         department VARCHAR(50)
);

CREATE TABLE appointments (
                              appointment_id SERIAL PRIMARY KEY,
                              patient_id INT REFERENCES patients(patient_id),
                              doctor_id INT REFERENCES doctors(doctor_id),
                              appointment_date DATE,
                              diagnosis VARCHAR(200),
                              fee NUMERIC(10,2)
);

INSERT INTO patients (full_name, phone, city, symptoms) VALUES
                                                            ('Nguyen Van A', '0901111111', 'Hanoi', ARRAY['fever', 'cough']),
                                                            ('Tran Thi B', '0902222222', 'HCM', ARRAY['headache']),
                                                            ('Le Van C', '0903333333', 'Danang', ARRAY['fever']),
                                                            ('Pham Thi D', '0904444444', 'Hanoi', ARRAY['stomachache']),
                                                            ('Hoang Van E', '0905555555', 'HCM', ARRAY['cough', 'sore throat']);

INSERT INTO doctors (full_name, department) VALUES
                                                ('Dr. Minh', 'Cardiology'),
                                                ('Dr. Lan', 'Neurology'),
                                                ('Dr. Hung', 'General'),
                                                ('Dr. Hoa', 'Pediatrics'),
                                                ('Dr. Nam', 'Orthopedics');

INSERT INTO appointments (patient_id, doctor_id, appointment_date, diagnosis, fee) VALUES
                                                                                       (1, 1, '2025-03-01', 'Flu', 200),
                                                                                       (2, 2, '2025-03-02', 'Migraine', 300),
                                                                                       (3, 3, '2025-03-03', 'Fever', 150),
                                                                                       (4, 4, '2025-03-04', 'Stomach Pain', 250),
                                                                                       (5, 5, '2025-03-05', 'Cold', 180),
                                                                                       (1, 2, '2025-03-06', 'Checkup', 220),
                                                                                       (2, 3, '2025-03-07', 'Flu', 210),
                                                                                       (3, 1, '2025-03-08', 'Heart Issue', 500),
                                                                                       (4, 5, '2025-03-09', 'Bone Pain', 350),
                                                                                       (5, 4, '2025-03-10', 'Child Care', 270);

CREATE INDEX idx_patients_phone
    ON patients(phone);

CREATE INDEX idx_patients_city
    ON patients USING HASH (city);

CREATE INDEX idx_patients_symptoms
    ON patients USING GIN (symptoms);
SELECT * FROM patients p
WHERE p.symptoms && ARRAY['fever'];

CREATE EXTENSION btree_gist;
CREATE INDEX idx_fee
    ON appointments USING GIST (fee);

CREATE INDEX idx_appointments_date
    ON appointments (appointment_date);
CLUSTER appointments USING idx_appointments_date;

CREATE VIEW vw_patient_top3 AS
SELECT p.patient_id, p.full_name, p.phone, SUM(a.fee) AS "Total_Fee"
FROM patients p
         JOIN appointments a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.full_name, p.phone
LIMIT 3;
SELECT * FROM vw_patient_top3;

CREATE VIEW vw_doctors AS
SELECT d.doctor_id, d.full_name, COUNT(a.appointment_id) As "cnt_appointment"
FROM doctors d
         LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.full_name;

CREATE VIEW vw_patient_city AS
SELECT p.patient_id, p.full_name, p.city
FROM patients p
WHERE p.city IN ('Hanoi', 'Danang')
        WITH CHECK OPTION;

SELECT * FROM vw_patient_city;

update vw_patient_city
SET city ='danang'
where patient_id = 1;
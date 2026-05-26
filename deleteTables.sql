-- Delete Tables for Hospital Database System (Oracle Compatible)
-- Drop tables using CASCADE CONSTRAINTS to handle foreign key dependencies

BEGIN
   -- 1. Drop Many-to-Many (M:N) Relationship Junction Tables
   FOR t IN (SELECT table_name FROM user_tables WHERE table_name IN (
       'DOCTOR_SCHEDULE', 'PATIENT_EMERGENCY_PERSON', 'PATIENT_ALLERGY', 'DOCTOR_SPECIALIZATION'
   )) LOOP
      EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
   END LOOP;

   -- 2. Drop Dependent Tables
   FOR t IN (SELECT table_name FROM user_tables WHERE table_name IN (
       'BILL', 'TREATMENT', 'APPOINTMENT', 'PATIENT', 'DEPARTMENT', 'DOCTOR', 'ALLERGY'
   )) LOOP
      EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
   END LOOP;

   -- 3. Drop Independent Tables
   FOR t IN (SELECT table_name FROM user_tables WHERE table_name IN (
       'EMERGENCY_PERSON', 'SCHEDULE', 'PAYMENT_METHOD', 'SPECIALIZATION', 'JOB_STATUS', 'ICD10', 'BLOOD_TYPE'
   )) LOOP
      EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
   END LOOP;

   -- 4. Drop Location Hierarchy Tables
   FOR t IN (SELECT table_name FROM user_tables WHERE table_name IN (
       'ADDRESS', 'NEIGHBOURHOOD', 'DISTRICT', 'PROVINCE', 'COUNTRY'
   )) LOOP
      EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
   END LOOP;
END;
/

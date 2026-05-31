-- Select emergency contact persons and their patient's active appointment counts.
-- Filters for emergency persons linked to patients with 'A+' blood type using a subquery.

SELECT ep.*,
       COUNT(a.APPOINTMENT_ID) AS active_appointment_count
FROM EMERGENCY_PERSON ep
JOIN PATIENT_EMERGENCY_PERSON pep ON ep.EMERGENCY_ID = pep.EMERGENCY_ID
JOIN APPOINTMENT a ON pep.PATIENT_ID = a.PATIENT_ID
WHERE a.IS_ACTIVE = 1
  AND ep.EMERGENCY_ID IN (
      SELECT sub_pep.EMERGENCY_ID
      FROM PATIENT_EMERGENCY_PERSON sub_pep
      JOIN PATIENT p ON sub_pep.PATIENT_ID = p.PATIENT_ID
      WHERE p.BLOOD_ID = (
        SELECT blood_id FROM BLOOD_TYPE
        WHERE type_name = 'A+'
      )
  )
GROUP BY ep.EMERGENCY_ID, ep.EMG_FIRST_NAME, ep.EMG_LAST_NAME, ep.EMG_PHONE_NO, ep.EMG_GENDER
HAVING COUNT(a.APPOINTMENT_ID) > 0
ORDER BY ep.EMERGENCY_ID ASC;

-- Select patients and their financial impact analysis based on treatment costs.
-- Filters for patients with registered allergies and identifies those whose average spending exceeds the hospital-wide average.

SELECT p.PAT_FIRST_NAME, p.PAT_LAST_NAME, p.PAT_EMAIL,
       COUNT(t.TREATMENT_ID) AS treatment_count,
       SUM(b.TOTAL_AMOUNT) AS total_spending
FROM PATIENT p
JOIN APPOINTMENT a ON p.PATIENT_ID = a.PATIENT_ID
JOIN TREATMENT t ON a.APPOINTMENT_ID = t.APPOINTMENT_ID
JOIN BILL b ON t.TREATMENT_ID = b.TREATMENT_ID
WHERE b.IS_PAID = 1
  AND p.PATIENT_ID IN (
      SELECT sub_pa.PATIENT_ID
      FROM PATIENT_ALLERGY sub_pa
  )
GROUP BY p.PATIENT_ID, p.PAT_FIRST_NAME, p.PAT_LAST_NAME, p.PAT_EMAIL
HAVING AVG(b.TOTAL_AMOUNT) > (
    SELECT AVG(total_amount) FROM BILL
)
ORDER BY total_spending DESC;


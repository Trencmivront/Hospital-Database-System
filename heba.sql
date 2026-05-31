--GET Count active doctors are located in each district where count is bigger than zero.

SELECT d.district_name, 
       COUNT(doc.doctor_id) AS active_doctor_count
FROM District d
JOIN Neighbourhood n ON d.district_id = n.district_id
JOIN Address a ON n.neighbourhood_id = a.neighbourhood_id
JOIN Doctor doc ON a.address_id = doc.address_id
WHERE doc.job_status_id = (
    SELECT job_status_id 
    FROM Job_Status 
    WHERE status_name = 'ACTIVE'
)
GROUP BY d.district_name
HAVING COUNT(doc.doctor_id) > 0
ORDER BY active_doctor_count DESC;






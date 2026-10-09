--Query 1: available houses that fit each young tenant's maximum affordable rent
SELECT
    p.first_name,
    p.last_name,
    TIMESTAMPDIFF(YEAR, t.date_of_birth, CURDATE()) AS age,
    ep.annual_income,
    ep.max_affordable_rent,
    c.city_name,
    h.house_id,
    h.property_type,
    h.number_of_rooms,
    h.monthly_rent,
    ep.max_affordable_rent - h.monthly_rent AS rent_margin
FROM Tenant AS t
JOIN Person AS p
    ON p.person_id = t.person_id
JOIN Eligibility_Profile AS ep
    ON ep.tenant_id = t.person_id
   AND ep.assessment_date = (
        SELECT MAX(ep2.assessment_date)
        FROM Eligibility_Profile AS ep2
        WHERE ep2.tenant_id = t.person_id
   )
JOIN House AS h
    ON h.availability_status = 'available'
   AND h.monthly_rent <= ep.max_affordable_rent
JOIN City AS c
    ON c.city_id = h.city_id
WHERE TIMESTAMPDIFF(YEAR, t.date_of_birth, CURDATE()) BETWEEN 18 AND 30
ORDER BY p.last_name, p.first_name, h.monthly_rent;


--Query 2: rent burden of tenants with an active contract (contract rent vs. income)
SELECT
    p.first_name,
    p.last_name,
    ep.employment_status,
    ep.annual_income,
    ct.monthly_rent AS contract_monthly_rent,
    h.monthly_rent AS advertised_monthly_rent,
    ct.monthly_rent - h.monthly_rent AS contract_vs_advertised_diff,
    ROUND(100 * ct.monthly_rent * 12 / NULLIF(ep.annual_income, 0), 1) AS rent_to_income_pct,
    CASE
        WHEN ct.monthly_rent * 12 > 0.30 * ep.annual_income THEN 'Cost burdened'
        ELSE 'Not burdened'
    END AS burden_status
FROM Contract AS ct
JOIN Tenant AS t
    ON t.person_id = ct.tenant_id
JOIN Person AS p
    ON p.person_id = t.person_id
JOIN House AS h
    ON h.house_id = ct.house_id
JOIN Eligibility_Profile AS ep
    ON ep.tenant_id = t.person_id
   AND ep.assessment_date = (
        SELECT MAX(ep2.assessment_date)
        FROM Eligibility_Profile AS ep2
        WHERE ep2.tenant_id = t.person_id
   )
WHERE ct.contract_status = 'active'
ORDER BY rent_to_income_pct DESC;
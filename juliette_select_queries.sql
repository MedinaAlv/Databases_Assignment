-- Two additional SELECT queries by Juliette Drugmand.
-- Questions and societal relevance are documented in select_queries.md.
-- Query 1 uses the mock tables from housing_poverty.sql.
-- Query 2 requires the CBS tables defined in cbs_observations.sql and loaded by import_cbs.py.

-- Query 1: Which available houses are affordable for each young tenant (aged 18-30),
-- based on their most recent eligibility profile?
SELECT
    p.first_name,
    p.last_name,
    e.employment_status,
    e.annual_income,
    e.max_affordable_rent,
    h.house_id,
    c.city_name,
    h.monthly_rent,
    e.max_affordable_rent - h.monthly_rent AS margin_eur
FROM Eligibility_Profile AS e
JOIN Tenant AS t ON t.person_id = e.tenant_id
JOIN Person AS p ON p.person_id = t.person_id
JOIN House AS h ON h.monthly_rent <= e.max_affordable_rent
JOIN City AS c ON c.city_id = h.city_id
WHERE h.availability_status = 'available'
  AND TIMESTAMPDIFF(YEAR, t.date_of_birth, CURDATE()) BETWEEN 18 AND 30
  AND e.assessment_date = (
      SELECT MAX(e2.assessment_date)
      FROM Eligibility_Profile AS e2
      WHERE e2.tenant_id = e.tenant_id
  )
ORDER BY p.last_name, h.monthly_rent;

-- Query 2: In the years covered by both CBS datasets, how does poverty among
-- 15-24 year olds compare with the national housing cost burden of tenants?
SELECT
    f.report_year,
    f.sex,
    f.in_poverty_pct AS poverty_15_to_24_pct,
    f.economically_independent_pct AS independent_15_to_24_pct,
    h.mean_monthly_total_housing_cost_eur AS national_tenant_cost_eur,
    h.housing_cost_ratio_pct AS national_tenant_cost_ratio_pct
FROM CBS_Financial_Observation AS f
JOIN CBS_Housing_Cost_Observation AS h ON h.report_year = f.report_year
JOIN CBS_Region AS r ON r.region_name = h.region_name
WHERE f.age_group = 'Age: 15 to 24 years'
  AND r.region_type = 'country'
  AND h.tenure = 'Tenant'
  AND h.dwelling_characteristic = 'Total dwellings'
  AND h.accuracy = 'Value'
ORDER BY f.report_year, f.sex;

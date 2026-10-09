-- Two additional SELECT queries by Federico Leongito.
-- Questions and societal relevance are documented in select_queries.md.
-- Requires the CBS tables defined in cbs_observations.sql and loaded by import_cbs.py.

-- Query 1: Change in tenant housing cost burden by province, 2012 to 2021.
SELECT
    h.region_name,
    MAX(CASE WHEN h.report_year = 2012 THEN h.housing_cost_ratio_pct END) AS tenant_cost_ratio_2012_pct,
    MAX(CASE WHEN h.report_year = 2021 THEN h.housing_cost_ratio_pct END) AS tenant_cost_ratio_2021_pct,
    MAX(CASE WHEN h.report_year = 2021 THEN h.housing_cost_ratio_pct END)
      - MAX(CASE WHEN h.report_year = 2012 THEN h.housing_cost_ratio_pct END) AS change_percentage_points
FROM CBS_Housing_Cost_Observation AS h
JOIN CBS_Region AS r ON r.region_name = h.region_name
WHERE r.region_type = 'province'
  AND h.tenure = 'Tenant'
  AND h.dwelling_characteristic = 'Total dwellings'
  AND h.accuracy = 'Value'
  AND h.report_year IN (2012, 2021)
GROUP BY h.region_name
HAVING tenant_cost_ratio_2012_pct IS NOT NULL
   AND tenant_cost_ratio_2021_pct IS NOT NULL
ORDER BY change_percentage_points DESC, h.region_name;

-- Query 2: Poverty gap between available age groups, by sex and year.
SELECT
    f.report_year,
    f.sex,
    MAX(CASE WHEN f.age_group = 'Age: 15 to 24 years' THEN f.in_poverty_pct END) AS poverty_15_to_24_pct,
    MAX(CASE WHEN f.age_group = 'Age: 25 to 44 years' THEN f.in_poverty_pct END) AS poverty_25_to_44_pct,
    MAX(CASE WHEN f.age_group = 'Age: 15 to 24 years' THEN f.in_poverty_pct END)
      - MAX(CASE WHEN f.age_group = 'Age: 25 to 44 years' THEN f.in_poverty_pct END) AS youth_gap_percentage_points
FROM CBS_Financial_Observation AS f
WHERE f.report_year BETWEEN 2018 AND 2023
  AND f.age_group IN ('Age: 15 to 24 years', 'Age: 25 to 44 years')
GROUP BY f.report_year, f.sex
HAVING poverty_15_to_24_pct IS NOT NULL
   AND poverty_25_to_44_pct IS NOT NULL
ORDER BY f.report_year, f.sex;

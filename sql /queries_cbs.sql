-- Task 3, query 1: compare tenant and owner housing costs by province in 2021.
-- These are average total housing costs, including utilities and other costs, not advertised rents.
SELECT
    h.region_name,
    MAX(CASE WHEN h.tenure = 'Tenant' THEN h.mean_monthly_total_housing_cost_eur END) AS tenant_monthly_cost_eur,
    MAX(CASE WHEN h.tenure = 'Owner' THEN h.mean_monthly_total_housing_cost_eur END) AS owner_monthly_cost_eur,
    MAX(CASE WHEN h.tenure = 'Tenant' THEN h.housing_cost_ratio_pct END) AS tenant_housing_cost_ratio_pct,
    MAX(CASE WHEN h.tenure = 'Owner' THEN h.housing_cost_ratio_pct END) AS owner_housing_cost_ratio_pct,
    MAX(CASE WHEN h.tenure = 'Tenant' THEN h.housing_cost_ratio_pct END)
      - MAX(CASE WHEN h.tenure = 'Owner' THEN h.housing_cost_ratio_pct END) AS ratio_gap_percentage_points
FROM CBS_Housing_Cost_Observation AS h
JOIN CBS_Region AS r ON r.region_name = h.region_name
WHERE r.region_type = 'province'
  AND h.report_year = 2021
  AND h.tenure IN ('Tenant', 'Owner')
  AND h.dwelling_characteristic = 'Total dwellings'
  AND h.accuracy = 'Value'
GROUP BY h.region_name
ORDER BY ratio_gap_percentage_points DESC, h.region_name;

-- Task 3, query 2: financial position and poverty by age and sex, 2018-2024.
-- 2024 is preliminary; income is mean personal income in thousands of euros per year.
SELECT
    f.report_year,
    p.is_preliminary,
    f.age_group,
    f.sex,
    f.mean_personal_income_thousand_eur,
    f.economically_independent_pct,
    f.in_poverty_pct
FROM CBS_Financial_Observation AS f
JOIN CBS_Financial_Period AS p ON p.report_year = f.report_year
WHERE f.report_year BETWEEN 2018 AND 2024
ORDER BY f.report_year, f.age_group, f.sex;

-- Task 3, query 3: place national tenant housing costs beside age-group financial indicators.
-- The rows share a reporting year only. They do not describe the same people or prove affordability.
SELECT
    f.report_year,
    f.age_group,
    f.sex,
    h.mean_monthly_total_housing_cost_eur AS tenant_monthly_total_housing_cost_eur,
    h.housing_cost_ratio_pct AS tenant_housing_cost_ratio_pct,
    f.mean_personal_income_thousand_eur,
    f.in_poverty_pct
FROM CBS_Financial_Observation AS f
JOIN CBS_Housing_Cost_Observation AS h
  ON h.report_year = f.report_year
 AND h.region_name = 'The Netherlands'
 AND h.tenure = 'Tenant'
 AND h.dwelling_characteristic = 'Total dwellings'
 AND h.accuracy = 'Value'
ORDER BY f.report_year, f.age_group, f.sex;

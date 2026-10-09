# Group SELECT queries

## Federico Leongito (`FedericoLeongito`)

### Query 1: Change in tenant housing costs by province

**Question:** Which provinces had the biggest change in tenants' housing cost ratio from 2012 to 2021?

**Relevance:** It shows where housing became a larger share of tenants' budgets. The data covers tenants of all ages.

```sql
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
```

**Finding:** Among the 12 provinces, Zeeland had the largest increase (+1.6 percentage points), while Drenthe had the largest decrease (−2.3 points). Seven provinces increased and five decreased.

### Query 2: Poverty rates by age group

**Question:** How did poverty rates differ between people aged 15–24 and 25–44, by sex and year?

**Relevance:** It helps show whether the younger age group faced more poverty. These age groups do not exactly match our 18–30 focus.

```sql
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
```

**Finding:** The 15–24 group had a higher poverty percentage than the 25–44 group for both sexes in every year shown. In 2023, the rates were 4.4% versus 3.3% for women and 4.2% versus 3.6% for men.

## Juliette Drugmand

### Query 1: Affordable available houses for young tenants

**Question:** Which available houses have a monthly rent at or below the maximum affordable rent of each tenant aged 18-30, based on their most recent eligibility profile?

**Relevance:** It tests our core problem directly: whether available housing is within reach for young people given their income and employment. Tenants with few or no matches show where supply fails young adults, and the margin shows how little room is left. The data are mock records, not real listings.

```sql
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
```

### Query 2: Youth poverty and tenant housing costs in shared years

**Question:** In the years covered by both CBS datasets, how does poverty among 15-24 year olds compare with the national housing cost and cost burden of tenants?

**Relevance:** It is the only query that links the two CBS datasets, bringing together housing costs and youth poverty. The data are aggregates, so it shows co-movement, not causation.

```sql
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
```

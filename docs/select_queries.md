# Group SELECT queries

## Federico Leongito

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


## Álvaro Medina (`alvaro_select_queries`)

### Query 1: Affordable available houses for young tenants

**Question:** Which available houses have a monthly rent at or below the maximum affordable rent of each young tenant aged 18–30, based on their most recent eligibility profile?

**Relevance:** This query directly addresses our societal problem of housing costs and the risk of poverty among young people. It compares tenants' financial circumstances with the rent of available properties. The rent margin shows how much a property's rent is below the tenant's maximum affordable rent. This can help identify which tenants have affordable housing options in our database.

**Data limitation:** The query uses fictional tenant and housing records. It demonstrates how affordability could be analysed but does not identify real available rental properties.

```sql
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
```

### Query 2: Rent burden of tenants with active contracts

**Question:** How does the monthly rent paid by tenants with active rental contracts compare with the advertised rent of their properties, and what percentage of their annual income goes towards rent?

**Relevance:** Housing costs can place pressure on a tenant's financial situation and increase the risk of poverty. This query calculates the percentage of annual income spent on rent and classifies tenants as cost burdened when their annual contract rent exceeds 30% of their annual income. It also compares the contractual rent with the advertised rent, which can reveal differences between the two amounts.

**Data limitation:** The query uses fictional tenants, contracts, and housing records. It currently includes tenants of all ages rather than specifically restricting the results to people aged 18–30. Its findings therefore describe the tenants with active contracts in our mock database, not necessarily young people in the Netherlands.

```sql
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
```


## Lilly Schulze (`lilly_select_queries`)

### Query 1: Rental property ownership and availability by landlord

**Question:** Which landlords own the most properties in our database, and how many of their properties are currently available to rent?

**Relevance:** The number of properties owned by each landlord and the availability of those properties can help us understand how rental housing is distributed in our database. Comparing the number of available properties can also provide insight into the supply of housing represented in the dataset. This is relevant to our societal problem because limited housing availability can make it harder for young people to find suitable accommodation.

**Data limitation:** The query uses fictional landlord and housing records. It describes the distribution of properties in our database and should not be interpreted as evidence about actual landlords or housing supply in the Netherlands.

```sql
SELECT
    landlord.person_id AS landlord_id,
    COUNT(h.house_id) AS total_properties,
    COUNT(
        CASE
            WHEN h.availability_status = 'available'
            THEN h.house_id
        END
    ) AS available_properties
FROM landlord
LEFT JOIN house h
    ON landlord.person_id = h.landlord_id
GROUP BY landlord.person_id
ORDER BY total_properties DESC;
```

### Query 2: Average rental prices of available properties by city

**Question:** How does the average monthly rent of currently available properties differ between cities in our database, and which cities have the highest average rents?

**Relevance:** Rental prices can vary between locations, making housing more difficult to afford in some cities than in others. By comparing the average rents of currently available properties, this query helps us explore where young people might face higher rental costs when searching for housing. Counting the available properties in each city also provides context for interpreting the averages, since cities with few available properties may have less representative averages.

**Data limitation:** The query uses fictional property records and does not represent actual rental prices or housing availability in Dutch cities. It includes only properties marked as currently available in our database, so the results describe the rental options represented in our mock dataset rather than the entire housing market.

```sql
SELECT
    c.city_id,
    c.city_name,
    COUNT(h.house_id) AS available_property_count,
    AVG(h.monthly_rent) AS average_monthly_rent
FROM city c
LEFT JOIN house h
    ON c.city_id = h.city_id
    AND h.availability_status = 'available'
GROUP BY c.city_id, c.city_name
ORDER BY average_monthly_rent DESC;
```

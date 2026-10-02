## Normalization check with real-world data (update to the week 2 report)

After adding the real data from CBS, we checked if our database is still in 3NF. The four new CBS tables (CBS_Region, CBS_Financial_Period, CBS_Financial_Observation and CBS_Housing_Cost_Observation) are in 3NF. In every table, each column depends on the whole key and on nothing else. For example, the region type only depends on the region name, so we put it in its own table. The same happens with the preliminary status, which only depends on the year.

The original CBS files were not normalized. These are the problems we found and how our import script (import_cbs.py) solves them:

| Normal form | Problem | Solution |
| --- | --- | --- |
| 1NF | The period "2024*" has a year and a preliminary mark in the same value | We split it into report_year and is_preliminary |
| 1NF | Missing values are written as "." and numbers have thousands separators (for example "1,010.6") | We store them as NULL and as DECIMAL numbers |
| 1NF | Units are inside the column names and the last row ("Source: CBS.") is not data | We rename the columns and skip the last row |
| 2NF | is_preliminary only depends on the year, which is just a part of the key | We moved it to CBS_Financial_Period |
| 3NF | The region type depends on the region name (provinces end with "(PV)") | We moved it to CBS_Region |

We also checked our original tables and found two more problems with 3NF:

| Normal form | Problem | Possible solution |
| --- | --- | --- |
| 3NF | Application.tenant_id depends on eligibility_id, because each eligibility profile belongs to one tenant | Remove tenant_id from Application and get the tenant through Eligibility_Profile |
| 3NF | max_affordable_rent might be calculated from annual_income and number_dependents | Calculate it in a query or a view, or explain that it is a separate assessment |

Two more things we noticed. Contract.monthly_rent is not a repeated value, because it is the rent agreed when the contract was signed and it can be different from House.monthly_rent. Also, MySQL ignores the REFERENCES we wrote next to the columns in the original CREATE TABLE statements, so we should use FOREIGN KEY constraints at the end of the table, like we did in the CBS tables.

The real data is inserted in normalized form. The script first loads the region and period tables and then the two observation tables. It rejects duplicate keys and we can run it again without getting repeated rows. In total it loads 13 regions, 14 financial periods, 56 financial observations and 156 housing observations.

## Limitations

The tenants, landlords, houses, applications and contracts are fictional, so the results of our queries do not show the real housing market. The database also has real data from CBS: housing costs by region and type of tenure (table 84488ENG) and financial position by age and sex (table 86135ENG). This data is about provinces, the whole country and age groups, not about single tenants or houses. Because of this, we cannot put it in the Tenant or House tables. We also have nothing that connects the CBS regions with our Municipality and City tables, so we can only compare real and fictional data side by side.

The real data has some gaps. Housing costs only exist for 2012, 2015, 2018 and 2021. Poverty is missing from 2011 to 2017 and the 2024 values are preliminary. The CBS housing costs are average total costs, including utilities, so they are not the same as advertised rents (House.monthly_rent). Also, the CBS age groups (15 to 24 and 25 to 44) do not match our target group of 18 to 30.

We do not check the age of the tenants. We store the date of birth, but nothing checks that the tenant is between 18 and 30. We only keep part of the history. The CBS data covers 2011 to 2024, but in our own tables we only keep the contract rent and the dated eligibility assessments. House.monthly_rent is overwritten when it changes. Shared housing is not possible, because a contract has only one tenant. We also do not include housing benefits or other subsidies.

## Quality of the query results

Query 1 (tenant and owner housing costs by province in 2021) gives 12 rows and the results make sense. Query 2 (financial position by age and sex) gives 28 rows. It starts in 2018 because poverty is missing before that year. Query 3 (tenant housing costs next to financial indicators) is the weakest one. It joins only by year, so the national tenant numbers are repeated in every age and sex row, and poverty is empty for 2012 and 2015. It does not describe the same people, so it cannot tell us if housing is affordable for young people. To improve it, we want to use only 2018 and 2021 and describe it as a comparison of trends.

## Future work

In the short term, we can check the age range automatically using the date of birth, with a trigger or a view. We can connect applications with signed contracts by adding application_id to the Contract table. We can also calculate the rent-to-income ratio now. The maximum affordable rent of our fictional tenants is between 28% and 50% of their monthly income, and we can compare it with the CBS national ratio for tenants, which was 36.3% in 2021. We also want to make the affordability score easier to understand and include housing subsidies if we find data.

In the long term, we would like to compare affordability with real income data at municipality level, because now we only have national and province data. We would also like to follow rent changes over time in each city, include rent rules and housing policy by region, support household profiles and shared housing, add other countries, and make a live dashboard for housing organizations and policymakers.

# CBS data selected for the real-data exercise

| Dataset | Source and publication details | Licence | File and distinct observations |
| --- | --- | --- | --- |
| [Housing costs of households; dwelling characteristics, region](https://www.cbs.nl/en-gb/figures/detail/84488ENG) (84488ENG) | Statistics Netherlands (CBS). Last published revision: 9 June 2022; series available from 2012. | [CC BY 4.0](https://www.cbs.nl/en-gb/about-us/website/copyright) | [Housing costs CSV](housing_costs_households_cbs_84488ENG.csv): 156 |
| [Financial position of individuals; key figures](https://www.cbs.nl/en-gb/figures/detail/86135ENG) (86135ENG) | Statistics Netherlands (CBS). Latest data release noted by CBS: 17 December 2025; series available from 2011. The page shows a later update of 4 March 2026. | [CC BY 4.0](https://www.cbs.nl/en-gb/about-us/website/copyright) | [Financial position CSV](financial_position_age_sex_cbs_86135ENG.csv): 56 |

Accessed 2 October 2026. Cite CBS and indicate transformations when reusing these files.

## Selection and provenance

- The housing CSV is the group member's original CBS export, copied without modifying its rows. It selects *Total dwellings*, *Value*, three owner/tenant categories, the Netherlands and 12 provinces, and 2012, 2015, 2018, and 2021. Its observation key is `(Owner or tenant, Dwelling characteristics, Accuracy, Periods, Region)`: 3 × 1 × 1 × 4 × 13 = 156 unique rows.
- The financial CSV expands the group's original 14-row selection using the [CBS OData table](https://opendata.cbs.nl/ODataApi/OData/86135ENG/TypedDataSet). It selects `Age: 15 to 24 years` and `Age: 25 to 44 years`, `Male` and `Female`, and every year from 2011 through 2024. Its observation key is `(Characteristic persons, Sex, Periods)`: 2 × 2 × 14 = 56 unique rows. CBS category codes used for the export are `53050  ` and `53310  ` for age, and `3000   ` and `4000   ` for sex. The OData values were written with the column labels and number formatting of the group's original CSV; unavailable values are shown as `.` and provisional 2024 as `2024*`.
- Each CSV ends with `Source: CBS.`, which is attribution, **not** an observation. Do not include it in row counts or imports. No observation keys are duplicated in either selection.

The sources are complementary: one reports housing expenditure by region, tenure, and year; the other reports income and poverty by age, sex, and year. Both are aggregate statistics. The financial age bands extend beyond the project's 18–30 target, and the datasets do not identify individual tenants or rental listings. They should not be loaded into the existing `Tenant` or `House` tables as if they were individual records.

## Import notes for task 2

- `Periods` is a year, not a full date. In the financial CSV, `2024*` means a preliminary figure; retain that status separately when converting the year to an integer.
- A `.` denotes an unavailable value and should become SQL `NULL`. In this selection the financial CSV has four missing purchasing-power values and 28 missing poverty values; the housing CSV has no missing numeric values.
- Financial population counts and incomes are published in thousands; preserve the units or convert them explicitly. Numeric thousands separators such as `1,010.6` must be removed before parsing. Housing costs are monthly euros and the housing cost ratio is a percentage.
- Keep region labels such as `Friesland (PV)` as source values or map them through an explicit region table. Do not silently merge province and national rows or equate an aggregate housing cost with a property's advertised rent.

## MySQL integration

Run `./venv/bin/python import_cbs.py --validate-only` to check the files, then `./venv/bin/python import_cbs.py` to create the tables and import them. The script reads the existing `.env` keys `DB_USER`, `DB_PASSWORD`, and `DB_NAME`; `DB_HOST` and `DB_PORT` are optional and default to `localhost` and `3306`. It validates both files before connecting, skips the attribution footer, rejects duplicate observation keys, converts `.` to SQL `NULL`, removes thousands separators, and separates the preliminary marker from the report year. Re-running it updates rows with the same key without creating duplicates.

The [schema](../cbs_observations.sql) adds `CBS_Region`, `CBS_Financial_Period`, `CBS_Financial_Observation`, and `CBS_Housing_Cost_Observation`. A financial row is identified by age group, sex, and report year. A housing row is identified by region, tenure, dwelling characteristic, accuracy, and report year. Monetary figures use `DECIMAL`, percentages are constrained to 0–100, and region and year references have foreign keys. The preliminary status is held once per financial report year. The original operational tables are unaffected.

Verified in local MySQL on 2 October 2026: 13 regions, 14 financial periods, **56 financial observations**, and **156 housing observations**. A second import left the counts unchanged. The financial table contains 28 `NULL` poverty values from unavailable source cells, and 2024 is flagged preliminary. These rows are real aggregate observations; they do not make the existing mock tenant-to-house affordability queries representative of real people or listings.

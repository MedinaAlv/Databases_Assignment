# Group 19 — Database Project

**Group members:** Lilly Schulze, Juliette Drugmand, Federico Leongito, and Álvaro Medina

**Repository:** [MedinaAlv/Databases_Assignment](https://github.com/MedinaAlv/Databases_Assignment)

## Week 4 stakeholder video

[Watch or download the stakeholder video](assets/week4-stakeholder-video.mov).

## Project documentation

- [Week 2: data model and normalization report](docs/Week_2_Report.md)
- [Current database ERD](docs/Final_ERD.md)
- [Week 2: original ERD diagram](docs/ERD_Diagram.pdf)
- [Week 3: schema, constraints, and example queries](notebooks/database.ipynb)
- [Week 5: real-data normalization and limitations](docs/Week5_Answer_4-5.md)
- [Group SELECT queries and explanations](docs/select_queries.md)

## Real-world data sources

The two openly licensed CBS datasets selected for the real-data exercise are available in the [data directory](data/README.md). The housing-cost file contains 156 distinct observations; the expanded financial-position file contains 56 distinct observations. They cover different subjects and dimensions, so neither dataset is a subset of the other. Both contain aggregate statistics, not records of individual tenants or advertised properties.

To load them into a MySQL database configured in `.env`, run `./venv/bin/python scripts/import_cbs.py`. Use `./venv/bin/python scripts/import_cbs.py --validate-only` to check the CSVs without changing the database. The import creates separate CBS observation tables defined in [`cbs_observations.sql`](sql%20/cbs_observations.sql), so the existing tenant and house records are not used for these statistics. See the [data notes](data/README.md) for the source selection, cleaning rules, and verification results.

The week 3 example queries were rerun: they returned 24 tenant–house matches, four city summaries, and 18 tenant–city summaries, all from mock records. The [adapted CBS queries](sql%20/queries_cbs.sql) returned 12 province housing comparisons, 28 age-and-sex financial observations for 2018–2024, and 16 observations for years shared by both datasets. The CBS data contains aggregate statistics, so it cannot identify affordable houses for individual tenants.

## Societal Problem

The societal problem we are investigating is **Housing Costs and the Risk of Poverty Among Young People**.

Our project started with an article published by the Spanish newspaper *El País* on 5 June 2026, titled *“Young people who bear all household expenses are at risk of falling into poverty, according to a BBVA report.”* The article discusses the increasing financial pressure that housing costs place on young people in Spain. According to the report discussed in the article, **32.9% of young people in Spain would be living in poverty when their disposable income after housing costs is taken into account**.

While investigating the issue further, we discovered that housing affordability is not only a Spanish problem. Research has shown that housing costs and housing tenure are also related to poverty and economic hardship among young adults across Europe. One of the studies we found examines young adults aged 18–34 across 24 European countries and highlights the roles of housing costs, housing tenure, income, and rent regulation.

## Why Is This Problem Important?

Housing is essential for having an independent and stable life. However, high housing costs can make it difficult for young people to move out of their parents' homes, even when they have a job and an income. This can affect their financial security, independence, and ability to afford other essential needs.

The problem is particularly relevant to young adults because factors such as temporary or part-time employment, lower real wages, and increasing demand for rental housing can make it harder for them to afford housing. The Spanish report also notes that the average age at which young people leave their parents' home is around 30 in Spain, compared with 26 in the European Union.

Research on Europe also shows that housing affordability problems are particularly common among low-income households and market renters and are associated with higher poverty rates. Young people are among the groups that can be particularly vulnerable to these problems.

## Our Database

Our database is designed to explore housing affordability for **young adults aged 18–30** in the Netherlands and identify whether available housing could be affordable for a potential tenant.

The database should be able to answer questions such as:

- Which houses are currently available?
- What is the monthly rent of each house?
- Which houses could be affordable for a particular tenant?
- What is a tenant's income and employment status?
- Which houses have received applications from tenants?
- What is the status of each application?
- Which tenant is currently renting a particular house?
- Which landlords own particular houses?
- How does housing availability differ between cities?

The main goal is to connect information about **tenants, their financial circumstances, and available housing** so that housing affordability can be examined in relation to the risk of poverty.

## Stakeholders

The problem affects several groups:

- **Young people**, who may struggle to afford housing and live independently.
- **Parents and families**, who may need to financially support young adults or allow them to remain at home for longer.
- **Governments and local authorities**, which are responsible for housing policies, regulations, and social support.
- **Landlords and property developers**, who influence housing availability and rental prices.
- **Employers**, since housing costs can influence where young people are able to live and work.
- **Society as a whole**, because housing affordability is connected to poverty, inequality, independence, and future opportunities.

## Database Structure

The database consists of the following main entities:

- **Tenant** — stores information about people looking for housing.
- **Landlord** — stores information about property owners.
- **House** — stores information about properties, including rent, location, size, type, and availability.
- **Contract** — records rental agreements between tenants and landlords.
- **Municipality** — represents the relevant local authority.
- **City** — stores information about the location of properties.
- **Application** — records applications made by tenants for houses.
- **Eligibility Profile** — contains information used to assess whether housing is affordable or suitable for a tenant.

The main relationships include tenants signing contracts, landlords owning houses, cities containing houses, tenants applying for houses, and eligibility profiles describing the financial and employment circumstances relevant to an application.

## Affordability

A key part of our database is the **Eligibility Profile**. It contains information such as:

- Employment status
- Annual income
- Number of dependents
- Maximum affordable rent
- Assessment date

This allows us to compare a tenant's financial situation with the rental price of a house and investigate whether a property may be affordable for that tenant.

The database also distinguishes between the **advertised monthly rent of a house** and the **actual monthly rent specified in a rental contract**. This distinction is important because the final amount paid by a tenant may differ from the property's advertised rental price.

## Normalization

The CBS observation tables and the current core schema follow **1NF, 2NF, and 3NF** principles. We removed the duplicate `Application.tenant_id`; the tenant is obtained through the application's eligibility profile. The [normalization report](docs/Week5_Answer_4-5.md) documents this change. `max_affordable_rent` is stored as a separate assessment, not calculated solely from income and dependents.

During the normalization process, two issues were identified and addressed:

1. The landlord's address was originally stored as one combined attribute. This was removed because it contained multiple pieces of information rather than a single atomic value.

2. `government_id` was removed from the Contract table because the government associated with a contract can already be determined through the house and its city. Keeping it in Contract would create a transitive dependency and unnecessary duplication.

## Research Background

Our project is supported by research on housing affordability, poverty, and housing insecurity among young people.

In particular, the research we found examines:

- The relationship between **housing tenure and poverty among young European adults**.
- The relationship between **housing affordability, energy poverty, and financial well-being**.
- Factors associated with **housing insecurity among young adults**.
- The relationship between **housing affordability and poverty across Europe**, particularly among low-income households and market renters.

These sources helped us identify relevant variables for our database, including **age, income, housing costs, housing tenure, country, employment status, and rent regulation**.

## Project Goal

The overall goal of our database is to provide a structured way to investigate **whether young people can afford available housing and how housing costs may contribute to their risk of poverty**.

By connecting information about tenants, their financial circumstances, landlords, houses, applications, rental contracts, and locations, the database provides a foundation for analysing the housing affordability challenges faced by young people in Spain and, more broadly, across Europe.


## Running the database locally

Run these commands from the repository root with MySQL running. You need a MySQL user that can create a database and tables. The directory name `sql ` includes a trailing space, so keep the quotes around SQL file paths.

1. Set up Python once after cloning:

   ```bash
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```

2. Create a `.env` file in the repository root with your own MySQL credentials:

   ```text
   DB_USER=your_mysql_user
   DB_PASSWORD=your_mysql_password
   DB_NAME=housing_poverty
   ```

   `DB_HOST` and `DB_PORT` are optional; they default to `localhost` and `3306`. `.env` is ignored by Git, so each member creates their own.

3. Create an empty database, then load the core schema and mock records:

   ```bash
   mysql -u your_mysql_user -p -e "CREATE DATABASE housing_poverty;"
   mysql -u your_mysql_user -p housing_poverty < "sql /housing_poverty.sql"
   mysql -u your_mysql_user -p housing_poverty < "sql /mock_data.sql"
   ```

   Enter your MySQL password when prompted. Run the schema and mock data commands only once on an empty database.

4. Validate and import the CBS data:

   ```bash
   ./venv/bin/python scripts/import_cbs.py --validate-only
   ./venv/bin/python scripts/import_cbs.py
   ```

   The import creates the CBS tables and can be rerun without duplicating observations. To confirm the setup, run `mysql -u your_mysql_user -p housing_poverty -e "SHOW TABLES;"`.

The [notebook](notebooks/database.ipynb) is available for exploring the example queries. Select the `venv` kernel when opening it. After following the SQL setup above, skip the notebook cells that create tables or insert the same mock records.

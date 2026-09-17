# Group 19 — Database Project

**Group members:** Lilly Schulze, Juliette Drugmand, Federico Leongito, and Álvaro Medina

## Societal Problem

The societal problem we are investigating is **Housing Costs and the Risk of Poverty Among Young People**.

Our project started with an article published by the Spanish newspaper *El País* on 5 June 2026, titled *“Young people who bear all household expenses are at risk of falling into poverty, according to a BBVA report.”* The article discusses the increasing financial pressure that housing costs place on young people in Spain. According to the report discussed in the article, **32.9% of young people in Spain would be living in poverty when their disposable income after housing costs is taken into account**.

While investigating the issue further, we discovered that housing affordability is not only a Spanish problem. Research has shown that housing costs and housing tenure are also related to poverty and economic hardship among young adults across Europe. One of the studies we found examines young adults aged 18–34 across 24 European countries and highlights the roles of housing costs, housing tenure, income, and rent regulation.

## Why Is This Problem Important?

Housing is essential for having an independent and stable life. However, high housing costs can make it difficult for young people to move out of their parents' homes, even when they have a job and an income. This can affect their financial security, independence, and ability to afford other essential needs.

The problem is particularly relevant to young adults because factors such as temporary or part-time employment, lower real wages, and increasing demand for rental housing can make it harder for them to afford housing. The Spanish report also notes that the average age at which young people leave their parents' home is around 30 in Spain, compared with 26 in the European Union.

Research on Europe also shows that housing affordability problems are particularly common among low-income households and market renters and are associated with higher poverty rates. Young people are among the groups that can be particularly vulnerable to these problems.

## Our Database

Our database is designed to explore housing affordability for **young adults aged 18–30** and identify whether available housing could be affordable for a potential tenant.

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
- **Government** — represents the relevant government authority.
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

The database design was normalized according to **1NF, 2NF, and 3NF** to reduce duplication and prevent insertion, update, and deletion anomalies.

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

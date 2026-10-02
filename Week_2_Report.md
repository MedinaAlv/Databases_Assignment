# Week 2 - Data Modeling

## Task 1 - Scope of the Problem - What should the database be able to answer?

- Find affordable houses for adults aged 18–30 to help prevent poverty.
- The database should show which houses are available, their rent, and whether they are affordable for a tenant.

## Task 2 - How data interacts

- A house can be rented by multiple people, but a person can only rent 1 house at a time.
- A landlord can own multiple houses, but each house has one landlord.
- A tenant can apply for multiple houses.
- A house can have applications from multiple tenants.
- An application can be pending, rejected or accepted.
- A tenant has an eligibility profile containing information such as income and employment status.

## Task 3 - Entities

- Tenant
- Landlord
- House
- Contract
- Government
- City
- Application
- Eligibility Profile

## Task 4 - Relationships

- Tenant — signs — Contract
- Landlord — signs — Contract
- Landlord — has — House
- City — has — House
- Government — belongs to — City
- Tenant — makes — Application
- Eligibility Profile — describes/defines — Application
- Eligibility Profile — belongs to — City
- Application — applies for — House
- Contract — is associated with — Government

## Task 5/6 - Tables

### Tenant
- tenant_id — PK
- first_name
- last_name
- date_of_birth
- email
- phone_number

### Landlord
- landlord_id — PK
- first_name
- last_name
- email
- phone_number
- address

### House
- house_id — PK
- landlord_id — FK
- city_id — FK
- street
- house_number
- monthly_rent
- number_of_bedrooms
- property_type
- availability_status

### Contract
- contract_id — PK
- tenant_id — FK
- house_id — FK
- landlord_id — FK
- government_id — FK
- start_date
- end_date
- monthly_rent
- contract_status

### Government
- government_id — PK
- government_name
- government_level
- contact_email
- phone_number

### City
- city_id — PK
- government_id — FK
- city_name
- postal_code

### Application
- application_id — PK
- tenant_id — FK
- house_id — FK
- eligibility_profile_id — FK
- application_date
- application_status
- decision_date

### Eligibility Profile
- eligibility_profile_id — PK
- tenant_id — FK
- employment_status
- annual_income
- number_of_dependents
- maximum_affordable_rent
- assessment_date

## Normalize the ERD

Normalization was applied as a systematic pass over the ERD against the rules of 1NF, 2NF, and 3NF, in that order, since each form assumes the previous one already holds. The goal was not to change what the data means, but to remove duplication and hidden dependencies so every fact is stored exactly once in the table it structurally belongs to. This is supposed to prevent insertion, update, and deletion anomalies as the system grows. Two violations were found and fixed.

**1NF** requires every attribute to hold a single, atomic value. The Landlord table stored a single "address" column combining street, house number, city, and postal code into one text value (e.g. "14 Privet Drive, Little Whinging, 6321AB"). This does not store a single atomic value and is redundant, since the landlord can be reached through phone or email, we removed this attribute.

**2NF** applies to composite keys. Eligibility_Profile (eligibility_id, tenant_id) is the only composite-key table: its attributes (employment_status, annual_income, etc.) all depend on both columns together, not on either one alone, so no partial dependency exists and no change was required.

**3NF** forbids a non-key attribute depending transitively on another non-key attribute. Contract stored government_id, but this is a fact about the house, not the contract. house_id -> city_id (House) -> government_id (City) already determines it, so it was transitively dependent on the Contract's key. Repeating it on every contract row risked inconsistency if a house's municipality changed, so we removed it from Contract and it can now be retrieved through a join through House -> City -> Municipality.

> Note: It is important to note that Contract.monthly_rent and House.monthly_rent differ. The former refers to the actual amount paid by the tenant as determined by the tenant and landlord in the contract. The latter refers to the rent price the property was advertised as. Therefore it does not violate 3NF and we kept both.

## Tables showing Before and After applying normalizations

### 1NF Violation - Address in Landlord

**Before**

| landlord_id | first_name | last_name | email | phone_number | address |
|---|---|---|---|---|---|
| 1 | Harry | Potter | harrypotter@mail.com | 0031611223344 | 14 Privet Drive, Little Whinging, 6321AB |
| 2 | Hermione | Granger | hermionegranger@mail.com | 0031622334455 | 8 Heathgate, Hampstead Garden Suburb, London NW11 |

**After**

| landlord_id | first_name | last_name | email | phone_number |
|---|---|---|---|---|
| 1 | Harry | Potter | harrypotter@mail.com | 0031611223344 |
| 2 | Hermione | Granger | hermionegranger@mail.com | 0031622334455 |

### 3NF Violation: Transitively Dependent government_id on Contract

**Before**

| contract_id | tenant_id | house_id | government_id | monthly_rent | contract_status |
|---|---|---|---|---|---|
| 101 | 7 | 3 | 1 | 950 | active |
| 102 | 9 | 3 | 1 | 975 | active |
| 103 | 12 | 8 | 2 | 1100 | active |

**After**

| contract_id | tenant_id | house_id | monthly_rent | contract_status |
|---|---|---|---|---|







| 101 | 7 | 3 | 950 | active |
| 102 | 9 | 3 | 975 | active |
| 103 | 12 | 8 | 1100 | active |

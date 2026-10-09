# Current database ERD

This diagram shows the current schema's keys and main analysis fields. The [Week 2 PDF](ERD_Diagram.pdf) records the earlier design; the SQL files are authoritative for full column definitions and constraints.

```mermaid
erDiagram
    Person {
        int person_id PK
        string first_name
        string last_name
        string email
    }
    Tenant {
        int person_id PK
        date date_of_birth
    }
    Landlord {
        int person_id PK
    }
    Municipality {
        int municipality_id PK
        string municipality_name
    }
    City {
        int city_id PK
        int municipality_id FK
        string city_name
    }
    House {
        int house_id PK
        int landlord_id FK
        int city_id FK
        int monthly_rent
        string availability_status
    }
    Eligibility_Profile {
        int eligibility_id PK
        int tenant_id FK
        int annual_income
        int max_affordable_rent
        date assessment_date
    }
    Application {
        int application_id PK
        int eligibility_id FK
        int house_id FK
        string application_status
    }
    Contract {
        int contract_id PK
        int tenant_id FK
        int house_id FK
        int monthly_rent
        string contract_status
    }

    Person ||--o| Tenant : is
    Person ||--o| Landlord : is
    Tenant ||--o{ Eligibility_Profile : has
    Eligibility_Profile ||--o{ Application : supports
    House ||--o{ Application : receives
    Tenant ||--o{ Contract : signs
    House ||--o{ Contract : covers
    Landlord ||--o{ House : owns
    Municipality ||--o{ City : contains
    City ||--o{ House : contains
```

An application's tenant is identified by its eligibility profile. `Application` does not store a second tenant ID.

```mermaid
erDiagram
    CBS_Region {
        string region_name PK
        string region_type
    }
    CBS_Housing_Cost_Observation {
        string region_name PK
        string tenure PK
        string dwelling_characteristic PK
        string accuracy PK
        int report_year PK
        decimal housing_cost_ratio_pct
    }
    CBS_Financial_Period {
        int report_year PK
        boolean is_preliminary
    }
    CBS_Financial_Observation {
        string age_group PK
        string sex PK
        int report_year PK
        decimal in_poverty_pct
    }

    CBS_Region ||--o{ CBS_Housing_Cost_Observation : groups
    CBS_Financial_Period ||--o{ CBS_Financial_Observation : dates
```

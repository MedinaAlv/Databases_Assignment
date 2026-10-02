-- CBS aggregate observations are separate from the mock tenant/property records.
CREATE TABLE IF NOT EXISTS CBS_Region (
    region_name VARCHAR(100) PRIMARY KEY,
    region_type VARCHAR(20) NOT NULL,
    CONSTRAINT chk_cbs_region_type CHECK (region_type IN ('country', 'province'))
);

CREATE TABLE IF NOT EXISTS CBS_Financial_Period (
    report_year SMALLINT PRIMARY KEY,
    is_preliminary BOOLEAN NOT NULL,
    CONSTRAINT chk_cbs_financial_year CHECK (report_year BETWEEN 2011 AND 2100)
);

CREATE TABLE IF NOT EXISTS CBS_Financial_Observation (
    age_group VARCHAR(50) NOT NULL,
    sex VARCHAR(10) NOT NULL,
    report_year SMALLINT NOT NULL,
    people_thousands DECIMAL(12,1),
    mean_equivalised_income_thousand_eur DECIMAL(10,1),
    people_with_income_thousands DECIMAL(12,1),
    mean_personal_income_thousand_eur DECIMAL(10,1),
    median_purchasing_power_change_pct DECIMAL(5,1),
    economically_independent_pct DECIMAL(5,1),
    in_poverty_pct DECIMAL(5,1),
    PRIMARY KEY (age_group, sex, report_year),
    FOREIGN KEY (report_year) REFERENCES CBS_Financial_Period(report_year),
    CONSTRAINT chk_cbs_financial_sex CHECK (sex IN ('Male', 'Female')),
    CONSTRAINT chk_cbs_financial_people CHECK (people_thousands >= 0 AND people_with_income_thousands >= 0),
    CONSTRAINT chk_cbs_financial_income CHECK (mean_equivalised_income_thousand_eur >= 0 AND mean_personal_income_thousand_eur >= 0),
    CONSTRAINT chk_cbs_financial_independence CHECK (economically_independent_pct BETWEEN 0 AND 100),
    CONSTRAINT chk_cbs_financial_poverty CHECK (in_poverty_pct BETWEEN 0 AND 100)
);

CREATE TABLE IF NOT EXISTS CBS_Housing_Cost_Observation (
    region_name VARCHAR(100) NOT NULL,
    tenure VARCHAR(20) NOT NULL,
    dwelling_characteristic VARCHAR(100) NOT NULL,
    accuracy VARCHAR(50) NOT NULL,
    report_year SMALLINT NOT NULL,
    mean_monthly_total_housing_cost_eur DECIMAL(10,1),
    housing_cost_ratio_pct DECIMAL(5,1),
    PRIMARY KEY (region_name, tenure, dwelling_characteristic, accuracy, report_year),
    FOREIGN KEY (region_name) REFERENCES CBS_Region(region_name),
    CONSTRAINT chk_cbs_housing_tenure CHECK (tenure IN ('Total', 'Owner', 'Tenant')),
    CONSTRAINT chk_cbs_housing_year CHECK (report_year BETWEEN 2012 AND 2100),
    CONSTRAINT chk_cbs_housing_cost CHECK (mean_monthly_total_housing_cost_eur >= 0),
    CONSTRAINT chk_cbs_housing_ratio CHECK (housing_cost_ratio_pct BETWEEN 0 AND 100)
);

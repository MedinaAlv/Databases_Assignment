CREATE TABLE Person (
    person_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL
);

CREATE TABLE Tenant (
    person_id INT PRIMARY KEY,
    date_of_birth DATE NOT NULL,
    CONSTRAINT fk_tenant_person FOREIGN KEY (person_id) REFERENCES Person(person_id)
);

CREATE TABLE Landlord (
    person_id INT PRIMARY KEY,
    CONSTRAINT fk_landlord_person FOREIGN KEY (person_id) REFERENCES Person(person_id)
);

CREATE TABLE Municipality (
    municipality_id INT PRIMARY KEY,
    municipality_name VARCHAR(50) NOT NULL,
    municipality_level VARCHAR(50),
    contact_email VARCHAR(50),
    phone_number VARCHAR(15)
);

CREATE TABLE City (
    city_id INT PRIMARY KEY,
    municipality_id INT NOT NULL,
    city_name VARCHAR(50) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    CONSTRAINT fk_city_municipality FOREIGN KEY (municipality_id) REFERENCES Municipality(municipality_id)
);

CREATE TABLE House (
    house_id INT PRIMARY KEY,
    landlord_id INT,
    city_id INT,
    street VARCHAR(50) NOT NULL,
    house_number INT NOT NULL,
    monthly_rent INT NOT NULL,
    number_of_rooms INT NOT NULL,
    property_type VARCHAR(20),
    availability_status VARCHAR(20) DEFAULT 'available',
    CONSTRAINT fk_house_landlord FOREIGN KEY (landlord_id) REFERENCES Landlord(person_id),
    CONSTRAINT fk_house_city FOREIGN KEY (city_id) REFERENCES City(city_id),
    CONSTRAINT chk_house_rent CHECK (monthly_rent > 0),
    CONSTRAINT chk_house_rooms CHECK (number_of_rooms > 0)
);

CREATE TABLE Eligibility_Profile (
    eligibility_id INT PRIMARY KEY,
    tenant_id INT NOT NULL,
    employment_status VARCHAR(50),
    annual_income INT NOT NULL,
    number_dependents INT DEFAULT 0,
    max_affordable_rent INT,
    assessment_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_profile_tenant FOREIGN KEY (tenant_id) REFERENCES Tenant(person_id),
    CONSTRAINT chk_profile_income CHECK (annual_income >= 0),
    CONSTRAINT chk_profile_dependents CHECK (number_dependents >= 0),
    CONSTRAINT chk_profile_affordable_rent CHECK (max_affordable_rent >= 0)
);

CREATE TABLE Application (
    application_id INT PRIMARY KEY,
    tenant_id INT NOT NULL,
    eligibility_id INT NOT NULL,
    house_id INT NOT NULL,
    application_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    application_status VARCHAR(50),
    decision_date DATE,
    CONSTRAINT fk_application_tenant FOREIGN KEY (tenant_id) REFERENCES Tenant(person_id),
    CONSTRAINT fk_application_profile FOREIGN KEY (eligibility_id) REFERENCES Eligibility_Profile(eligibility_id),
    CONSTRAINT fk_application_house FOREIGN KEY (house_id) REFERENCES House(house_id)
);

CREATE TABLE Contract (
    contract_id INT PRIMARY KEY,
    tenant_id INT NOT NULL,
    house_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    minimum_contract_length INT,
    monthly_rent INT NOT NULL,
    contract_status VARCHAR(50) DEFAULT 'active',
    CONSTRAINT fk_contract_tenant FOREIGN KEY (tenant_id) REFERENCES Tenant(person_id),
    CONSTRAINT fk_contract_house FOREIGN KEY (house_id) REFERENCES House(house_id),
    CONSTRAINT chk_contract_rent CHECK (monthly_rent > 0)
);

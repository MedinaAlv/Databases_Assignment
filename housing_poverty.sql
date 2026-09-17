CREATE TABLE Person ( 

    person_id INT PRIMARY KEY, 

    first_name VARCHAR(50) NOT NULL, 

    last_name VARCHAR(50) NOT NULL, 

    email VARCHAR(50) UNIQUE NOT NULL, 

    phone_number VARCHAR(15) UNIQUE NOT NULL 

); 

  

CREATE TABLE Tenant ( 

    person_id INT PRIMARY KEY REFERENCES Person(person_id), 

    date_of_birth DATE NOT NULL 

); 

  

CREATE TABLE Landlord ( 

    person_id INT PRIMARY KEY REFERENCES Person(person_id) 

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

    municipality_id INT NOT NULL REFERENCES Municipality(municipality_id), 

    city_name VARCHAR(50) NOT NULL, 

    postal_code VARCHAR(20) NOT NULL 

); 

 

CREATE TABLE House ( 

    house_id INT PRIMARY KEY, 

    landlord_id INT REFERENCES Landlord(person_id), 

    city_id INT REFERENCES city(city_id), 

    street VARCHAR(50) NOT NULL, 

    house_number INT NOT NULL, 

    monthly_rent INT NOT NULL, 

    number_of_rooms INT NOT NULL,  

    property_type VARCHAR(20), 

    availability_status VARCHAR(20) DEFAULT 'available' 

); 

 

CREATE TABLE Eligibility_Profile ( 

    eligibility_id INT PRIMARY KEY, 

    tenant_id INT NOT NULL REFERENCES Tenant(person_id), 

    employment_status VARCHAR(50), 

    annual_income INT NOT NULL, 

    number_dependents INT DEFAULT 0, 

    max_affordable_rent INT, 

    assessment_date DATE NOT NULL DEFAULT CURRENT_DATE 

); 

  

CREATE TABLE Application ( 

    application_id INT PRIMARY KEY, 

    tenant_id INT NOT NULL REFERENCES Tenant(person_id), 

    eligibility_id INT NOT NULL REFERENCES Eligibility_Profile(eligibility_id), 

    house_id INT NOT NULL REFERENCES House(house_id), 

    application_date DATE NOT NULL DEFAULT CURRENT_DATE, 

    application_status VARCHAR(50), 

    decision_date DATE 

); 

  

CREATE TABLE Contract ( 

    contract_id  INT PRIMARY KEY, 

    tenant_id INT NOT NULL REFERENCES Tenant(person_id), 

    house_id INT NOT NULL REFERENCES House(house_id), 

    start_date DATE NOT NULL, 

    end_date DATE, 

    minimum_contract_length INT, 

    monthly_rent INT NOT NULL CHECK (monthly_rent > 0), 

    contract_status VARCHAR(50) DEFAULT 'active' 

); 

 
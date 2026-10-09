-- Mock records for the core tables. Run once after housing_poverty.sql.

INSERT INTO Person
(person_id, first_name, last_name, email, phone_number)
VALUES
(1, 'Sophie', 'Jansen', 'sophie.jansen@example.com', '0611111111'),
(2, 'Liam', 'de Vries', 'liam.devries@example.com', '0622222222'),
(3, 'Emma', 'Bakker', 'emma.bakker@example.com', '0633333333'),
(4, 'Noah', 'Smit', 'noah.smit@example.com', '0644444444'),
(5, 'Julia', 'Visser', 'julia.visser@example.com', '0655555555'),
(6, 'Lucas', 'Meijer', 'lucas.meijer@example.com', '0666666666'),
(7, 'Anna', 'Mulder', 'anna.mulder@example.com', '0677777777'),
(8, 'Mark', 'de Jong', 'mark.dejong@example.com', '0688888888'),
(9, 'Thomas', 'Peters', 'thomas.peters@example.com', '0699999999'),
(10, 'Lisa', 'van Dijk', 'lisa.vandijk@example.com', '0601010101'),
(11, 'David', 'Smit', 'david.smit@example.com', '0602020202'),
(12, 'Sarah', 'Visser', 'sarah.visser@example.com', '0603030303');

INSERT INTO Tenant
(person_id, date_of_birth)
VALUES
(1, '2002-04-15'),
(2, '1999-11-23'),
(3, '2001-07-08'),
(4, '2003-01-19'),
(5, '2000-09-30'),
(6, '1998-12-12'),
(7, '2002-06-21');

INSERT INTO Landlord
(person_id)
VALUES
(8),
(9),
(10),
(11),
(12);

INSERT INTO Municipality
(municipality_id, municipality_name, municipality_level, contact_email, phone_number)
VALUES
(1, 'Meerssen', 'City', 'info@meerssen.example.com', '0228111111'),
(2, 'Maastricht', 'City', 'info@maastricht.example.com', '0228222222'),
(3, 'Groningen', 'City', 'info@groningen.example.com', '0241333333'),
(4, 'Amsterdam', 'City', 'info@amsterdam.example.com', '0211444444');

INSERT INTO City
(city_id, municipality_id, city_name, postal_code)
VALUES
(1, 1, 'Meerssen', '53111'),
(2, 2, 'Maastricht', '50667'),
(3, 3, 'Groningen', '52062'),
(4, 4, 'Amsterdam', '40213');

INSERT INTO House
(house_id, landlord_id, city_id, street, house_number, monthly_rent, number_of_rooms, property_type, availability_status)
VALUES
(1, 8, 1, 'Kuileneindestraat', 10, 550, 2, 'Apartment', 'available'),
(2, 8, 1, 'Bunderstraat', 25, 720, 3, 'Apartment', 'rented'),
(3, 9, 2, 'Wycker Brugstraat', 45, 680, 2, 'Apartment', 'available'),
(4, 9, 2, 'Tongerseweg', 18, 850, 3, 'Apartment', 'available'),
(5, 10, 3, 'Oosterhamrikkade', 12, 500, 1, 'Studio', 'available'),
(6, 10, 3, 'Helper Brink', 33, 650, 2, 'Apartment', 'rented'),
(7, 11, 4, 'Jan Evertsenstraat', 8, 780, 3, 'Apartment', 'available'),
(8, 11, 4, 'Kinkerstraat', 40, 1200, 4, 'Apartment', 'rented'),
(9, 12, 1, 'Pastoor N. Creemersstraat', 55, 600, 2, 'Apartment', 'available'),
(10, 12, 2, 'Brusselsestraat', 100, 950, 3, 'House', 'available');

INSERT INTO Eligibility_Profile
(eligibility_id, tenant_id, employment_status, annual_income, number_dependents, max_affordable_rent, assessment_date)
VALUES
(1, 1, 'Student', 18000, 0, 600, '2026-09-01'),
(2, 2, 'Part-time employed', 24000, 0, 700, '2026-09-02'),
(3, 3, 'Student', 15000, 0, 550, '2026-09-03'),
(4, 4, 'Student', 12000, 0, 500, '2026-09-04'),
(5, 5, 'Full-time employed', 32000, 1, 800, '2026-09-05'),
(6, 6, 'Full-time employed', 38000, 2, 900, '2026-09-06'),
(7, 7, 'Student', 17000, 0, 600, '2026-09-07');

INSERT INTO Application
(application_id, eligibility_id, house_id, application_date, application_status, decision_date)
VALUES
(1, 1, 1, '2026-09-02', 'approved', '2026-09-05'),
(2, 2, 3, '2026-09-03', 'pending', NULL),
(3, 3, 5, '2026-09-04', 'approved', '2026-09-06'),
(4, 4, 1, '2026-09-05', 'rejected', '2026-09-08'),
(5, 5, 7, '2026-09-06', 'pending', NULL),
(6, 6, 10, '2026-09-07', 'approved', '2026-09-10'),
(7, 7, 9, '2026-09-08', 'pending', NULL);

INSERT INTO Contract
(contract_id, tenant_id, house_id, start_date, end_date, minimum_contract_length, monthly_rent, contract_status)
VALUES
(1, 1, 1, '2026-10-01', '2027-09-30', 12, 550, 'active'),
(2, 3, 5, '2026-10-01', '2027-09-30', 12, 500, 'active'),
(3, 6, 10, '2026-10-15', NULL, 12, 950, 'active'),
(4, 2, 2, '2025-09-01', '2026-08-31', 12, 720, 'expired'),
(5, 5, 7, '2026-01-01', '2026-12-31', 12, 780, 'active');

-- Query 1: Rental property ownership and availability
SELECT
    landlord.person_id AS landlord_id,
    COUNT(h.house_id) AS total_properties,
    COUNT(
        CASE
            WHEN h.availability_status = 'available'
            THEN h.house_id
        END
    ) AS available_properties
FROM landlord
LEFT JOIN house h
    ON landlord.person_id = h.landlord_id
GROUP BY landlord.person_id
ORDER BY total_properties DESC;

-- Query 2: Average rental prices by city
SELECT
    c.city_id,
    c.city_name,
    COUNT(h.house_id) AS available_property_count,
    AVG(h.monthly_rent) AS average_monthly_rent
FROM city c
LEFT JOIN house h
    ON c.city_id = h.city_id
    AND h.availability_status = 'available'
GROUP BY c.city_id, c.city_name
ORDER BY average_monthly_rent DESC;
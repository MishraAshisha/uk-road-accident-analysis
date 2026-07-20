-- KPI 1: VEHICLE CATEGORIZATION
-- Question: How can we categorize the diverse vehicle types involved in 2022 accidents into broad, actionable segments for analysis?

SELECT vehicle_type,
   	 CASE
       	 WHEN vehicle_type IN ('Agricultural vehicle') THEN 'Agricultural'
       	 WHEN vehicle_type IN ('Car', 'Private Car', 'Taxi') THEN 'Cars'
       	 WHEN vehicle_type IN ('Motorcycle 125cc and under','Motorcycle over 125cc and up to 500cc', 'Motorcycle over 500cc') THEN 'Bikes'
       	 ELSE 'Others'
   	 END AS vehicle_group
FROM road_accident
WHERE accident_date LIKE '%2022%'
LIMIT 7;

-- KPI 2: MONTHLY TRENDS
-- Question: What is the monthly trend of casualties for the current year (2022) to identify peak seasonal periods?

SELECT 
    CASE SUBSTR(accident_date, 4, 2)
        WHEN '01' THEN 'January'
        WHEN '02' THEN 'February'
        WHEN '03' THEN 'March'
        WHEN '04' THEN 'April'
        WHEN '05' THEN 'May'
        WHEN '06' THEN 'June'
        WHEN '07' THEN 'July'
        WHEN '08' THEN 'August'
        WHEN '09' THEN 'September'
        WHEN '10' THEN 'October'
        WHEN '11' THEN 'November'
        WHEN '12' THEN 'December'
        ELSE 'Unknown'
    END AS month_name,
    SUM(number_of_casual) AS CY_Casualties
FROM road_accident
WHERE accident_date LIKE '%2022%'
GROUP BY SUBSTR(accident_date, 4, 2)
ORDER BY SUBSTR(accident_date, 4, 2);

-- KPI 3: REGIONAL PROPORTIONS
-- Question: What percentage of total accidents occurred in Urban vs. Rural areas in 2022, and what were their total casualties?

SELECT 
    urban_or_rural_a AS Area,
    SUM(number_of_casual) AS CY_CASULTIES,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS Percentage_of_Total_Accidents
FROM road_accident
WHERE accident_date LIKE '%2022%'
GROUP BY urban_or_rural_a;




-- KPI 4: ROW-BY-ROW CONTRIBUTION
-- Question: How can we view individual accident records alongside their specific casualty counts and their percentage share against the annual total?

SELECT 
    accident_date,
    local_authority,
    urban_or_rural_a AS area,
    number_of_casual AS cy_casualties,
    COUNT(*) OVER() AS total_accident_records,
    ROUND(100.0 * number_of_casual / COUNT(*) OVER(), 5) AS percentage
FROM road_accident
WHERE accident_date LIKE '%2022%';

-- KPI 5: ENVIRONMENTAL ANALYSIS
-- Question: What is the distribution of total casualties and the overall percentage of accidents comparing Day vs. Night lighting conditions in 2022?

WITH t AS (
    SELECT 
        light_conditions,
        SUM(number_of_casual) AS total_casualties,
        ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS percentage,
        CASE 
            WHEN light_conditions = 'Daylight' THEN 'Day'
            ELSE 'Night'
        END AS light_conditions_in_uk
    FROM road_accident
    WHERE accident_date LIKE '%2022%'
    GROUP BY light_conditions
)
SELECT 
    light_conditions_in_uk, 
    SUM(total_casualties) AS total_casualties, 
    SUM(percentage) AS percentage
FROM t
GROUP BY light_conditions_in_uk;

-- Written and Analysed by Ashisha Mishra
-- Email: connect.amishra@protonmail.com
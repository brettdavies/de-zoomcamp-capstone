{{ config(materialized='view') }}

WITH recreationArea AS
(
    SELECT *
        ,CAST(RecAreaID AS INTEGER) AS RecAreaIDINT
        ,row_number() OVER(PARTITION BY RecAreaID) AS rn
    FROM {{ source('staging','RecAreas') }}
    WHERE RecAreaID NOT IN ('eb34b293-bd2b-4120-b6fa-c18be8184a67','RA40027','RA1014','BAH04091992')
),
recreationAreaAddress AS
(
    SELECT *
        ,row_number() OVER(PARTITION BY RecAreaID) AS rn
    FROM {{ source('staging','RecAreaAddresses') }}
)
SELECT
    ra.RecAreaIDINT AS recAreaID
    ,ra.RecAreaName AS recAreaName
    ,radd.City AS recAreaCity
    ,radd.PostalCode AS recAreaState
    ,radd.AddressStateCode AS recAreaPostalCode
FROM recreationArea AS ra
    LEFT JOIN recreationAreaAddress AS radd
        ON ra.RecAreaIDINT = radd.RecAreaID
WHERE TRUE
    AND ra.rn = 1
    AND radd.rn = 1

-- dbt build --m stg_recreationArea.sql --var 'is_test_run: false'
{% if var('is_test_run', default=true) %}

LIMIT 100000

{% endif %}

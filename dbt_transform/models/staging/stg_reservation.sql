{{ config(materialized='view') }}

WITH reservation AS
(
    SELECT *
        ,row_number() OVER(PARTITION BY historicalreservationid) AS rn
    FROM {{ source('staging','Reservations') }}
)
SELECT
    historicalreservationid AS historicalReservationId
    ,ordernumber AS orderNum
    ,agency
    ,park
    ,facilityid AS facilityId
    ,CAST(CAST(facilityzip AS FLOAT64) AS INTEGER) AS facilityZip
    ,facilitystate as facilityState
    ,customerzip AS customerZip

    -- timestamps
    ,CAST(orderdate AS TIMESTAMP) AS orderDatetime
    ,CAST(startdate AS TIMESTAMP) AS startDatetime
    ,CAST(enddate AS TIMESTAMP) AS endDatetime

    -- reservation details
    ,CASE
        WHEN enddate = '0001-01-01T00:00:00Z' THEN null
        ELSE date_diff(CAST(enddate AS TIMESTAMP), CAST(startdate AS TIMESTAMP), DAY)
    END AS nights
    ,CAST(CAST(numberofpeople AS FLOAT64) AS INTEGER) AS people
    ,equipmentdescription AS equipmentDesc
    ,equipmentlength AS equipmentLen

    -- money
    ,tax
    ,totalbeforetax AS subTotal
    ,discount
    ,totalpaid AS totalPaid

FROM reservation
WHERE rn = 1

-- dbt build --m stg_reservation.sql --var 'is_test_run: false'
{% if var('is_test_run', default=true) %}

LIMIT 100000

{% endif %}

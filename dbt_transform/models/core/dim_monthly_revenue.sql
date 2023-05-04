{{ config(materialized='table') }}

WITH reservation_data AS (
    SELECT * FROM {{ ref('fact_reservation') }}
    WHERE facilityState IS NOT NULL
)
SELECT
    -- Revenue grouping
    agency
    ,recAreaState
    ,recAreaName
    ,facilityName
    ,date_trunc(startDatetime, MONTH) AS revenue_month

    -- Revenue calculation 
    ,SUM(tax) AS revenue_monthly_tax
    ,SUM(subTotal) AS revenue_monthly_subTotal
    ,SUM(discount) AS revenue_monthly_discount
    ,SUM(totalPaid) AS revenue_monthly_totalPaid

    -- Additional calculations
    ,COUNT(reservationId) AS total_monthly_reservations
    ,AVG(nights) AS avg_montly_nights_per_reservation
    ,AVG(people) AS avg_montly_people_per_reservation

FROM reservation_data
GROUP BY 1,2,3,4,5

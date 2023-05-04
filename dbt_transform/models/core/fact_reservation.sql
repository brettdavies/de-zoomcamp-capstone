{{ config(materialized='table') }}

WITH reservation AS (
    SELECT *
    FROM {{ ref('stg_reservation') }}
), 

facility AS (
    SELECT *
    FROM {{ ref('stg_facility') }}
),

recArea AS (
    SELECT *
    FROM {{ ref('stg_recreationArea') }}
)
SELECT
    historicalreservationid AS reservationId
    ,r.orderNum
    ,r.agency
    -- ,r.park
    ,ra.recAreaName
    ,ra.recAreaCity
    ,ra.recAreaState
    ,ra.recAreaPostalCode
    -- ,f.parentRecAreaID
    ,f.facilityName
    -- ,f.parentOrgID
    ,f.facilityTypeDesc
    ,f.facilityAdaAccess
    ,r.facilityState
    ,r.facilityZip
    ,f.facilityLng
    ,f.facilityLat
    ,ST_GEOGPOINT(f.facilityLng, f.facilityLat) AS facilityPoint
    ,r.customerZip
    ,r.orderDatetime
    ,r.startDatetime
    ,r.endDatetime
    ,r.nights
    ,r.people
    ,r.equipmentDesc
    ,r.equipmentLen
    ,r.tax
    ,r.subTotal
    ,r.discount
    ,r.totalPaid

FROM reservation AS r
    LEFT JOIN facility AS f
        ON r.facilityId = f.facilityId
    LEFT JOIN recArea AS ra
        ON f.parentRecAreaID = ra.recAreaID

-- dbt build --m stg_reservations.sql --var 'is_test_run: false'
{% if var('is_test_run', default=true) %}

LIMIT 100000

{% endif %}

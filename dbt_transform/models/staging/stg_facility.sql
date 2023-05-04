{{ config(materialized='view') }}

WITH facility AS
(
    SELECT *
        ,row_number() OVER(PARTITION BY FacilityID) AS rn
    FROM {{ source('staging','Facilities') }}
    WHERE ParentRecAreaID NOT IN('RA1014','RA1014','BAH04091992')
)
SELECT
    FacilityID AS facilityId
    ,CAST(ParentRecAreaID as INTEGER) AS parentRecAreaID
    ,FacilityName AS facilityName
    ,ParentOrgID AS parentOrgID
    ,FacilityTypeDescription AS facilityTypeDesc
    ,FacilityAdaAccess AS facilityAdaAccess
    ,FacilityLongitude AS facilityLng
    ,FacilityLatitude AS facilityLat

FROM facility
WHERE rn = 1

-- dbt build --m stg_facility.sql --var 'is_test_run: false'
{% if var('is_test_run', default=true) %}

LIMIT 100000

{% endif %}

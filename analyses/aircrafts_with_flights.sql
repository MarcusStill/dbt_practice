{# Получим список кодов самолетов на которых был совершен хотя бы один полет #}
{% set aircrafts_codes_with_flights = dbt_utils.get_column_values(
    table=ref('stg_flights__flights'),
    column='aircraft_code'
) %}

SELECT
    *
FROM
    {{ ref('stg_flights__aircrafts') }}
WHERE 
    aircraft_code IN ('{{ aircrafts_codes_with_flights | join("', '") }}')
{{
    config(
        materialized = 'incremental',
        incremental_strategy = 'merge',
        unique_key = ['flight_id'],
        tags = ['flights']
    )
}}
select
    flight_id,
    flight_no,
    scheduled_departure,
    scheduled_arrival,
    departure_airport,
    arrival_airport,
    "status",
    aircraft_code,
    actual_departure,
    actual_arrival
from {{ source('demo_src', 'flights') }}
{% if is_incremental() %}
WHERE
    scheduled_departure >= (SELECT MAX(scheduled_departure) - interval '100 day' FROM {{ this }}) 
{% endif %}
/* Забираем все строки, у которых в поле scheduled_departure значение меньше максимальное не более чем на 100 дней */
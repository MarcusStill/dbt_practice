{{
  config(
        materialized = 'table',
    )
}}
{# Получим список уникальных значений статусов полетов #}
{% set statuses = dbt_utils.get_column_values(
    table=ref('stg_flights__flights'),
    column='status'
) %}

{% do log("Unique values of flight statuses: " ~ statuses | join(', '), info=True) %}

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
    actual_arrival,
   {{ concat_columns([ 'flight_id', 'flight_no' ]) }} as fligth_info
from
    {{ ref('stg_flights__flights') }}
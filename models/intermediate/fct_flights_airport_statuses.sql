{{
  config(
        materialized = 'table',
    )
}}

{# Логируем статусы для проверки #}
{% do log("Statuses: " ~ flight_statuses, info=true) %}

{# Задаём нужные статусы #}
{% set required_statuses = ['Departed', 'Arrived', 'On Time'] %}

select
    departure_airport as dep_air,
    {{ dbt_utils.pivot(
        column='status',
        values=required_statuses,
        agg='count',
        then_value=1,
        else_value=0,
        quote_identifiers=false
    ) }}
from {{ ref('fct_flights') }}
group by departure_airport
order by departure_airport

{# Выводим результат в консоль #}
{% if execute %}
  {{ log('Result:', info=True) }}
  {% set query %}
    SELECT * FROM {{ this }} LIMIT 5
  {% endset %}
  {% set results = run_query(query) %}
  {{ log(results.print_table(), info=True) }}
{% endif %}
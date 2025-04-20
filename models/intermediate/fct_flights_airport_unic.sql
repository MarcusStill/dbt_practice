{{
  config(
        materialized = 'table',
    )
}}

select distinct
    departure_airport
from {{ ref('fct_flights') }}
order by departure_airport

{# Выводим результат в консоль #}
{% if execute %}
  {{ log("Unique departure airports:", info=True) }}
  {% set airports_query %}
    select distinct departure_airport from {{ ref('fct_flights') }} order by departure_airport LIMIT 10
  {% endset %}
  {% set results = run_query(airports_query) %}
  {% for row in results %}
    {{ log(row[0], info=True) }}
  {% endfor %}
{% endif %}
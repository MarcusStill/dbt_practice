{# Считаем сколько всего полетов (количество строк в модели fct_fligths)
было запланировано за предыдущие 10 лет, начиная с текущей даты).#}
{% set current_date = run_started_at | string | truncate(10, True, "") %}
{% set current_year = current_date | truncate(4, True, "") | int %}
{% set prev_year = (current_year - 10) %}
{% set prev_date = prev_year ~ '-' ~ current_date[5:7] ~ '-' ~ current_date[8:10] %}
select
    EXTRACT(YEAR FROM scheduled_departure)::int AS flights_year,
    count(*) as count_flights
from
    {{ ref('fct_flights') }}
where 
    scheduled_departure between '{{ prev_date }}' and '{{ current_date }}'
group by flight_year
order by flight_year desc;

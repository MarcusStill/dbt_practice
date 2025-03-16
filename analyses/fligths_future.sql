{# Считаем сколько всего полетов (количество строк в модели fct_fligths) запланировано на дату, 
начиная с текущей даты (scheduled_departure >= [текущая дата]).#}
select
    count(*) as count_flight
from
    {{ ref('fct_flights') }}
where 
    scheduled_departure >= to_timestamp({{ run_started_at | string | truncate(10, True,"") }})

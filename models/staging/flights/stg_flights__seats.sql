{{
    config(
        materialized = 'table'
    )

}}
select
    aircraft_code,
    seat_no,
    fare_conditions
    --, 'static_value' as seat_group  -- добавляем новое поле
from {{ source('demo_src', 'seats') }}

{# Сохраняем текущий manifest.json:
mkdir state_snapshot
copy target\manifest.json state_snapshot\manifest.json

Запускаем dbt ls с указанием изменений:
dbt ls --select state:modified --state state_snapshot/ #}
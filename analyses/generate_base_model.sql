{{ codegen.generate_base_model(
    source_name='demo_src',
    table_name='ticket_flights',
    materialized='table'
) }}

{# Сохранение сгенерированного кода модели в файл
dbt run-operation codegen.generate_base_model --args "{source_name: 'demo_src', table_name: 'aircrafts', materialized: 'table'}" | grep -v '\[' > models/staging/flights/stg_flights__aircrafts_generated.sql
#}
{# Создадим pre_hook, который перед обновлением модели будет переименовывать таблицу,
существующую до начала обновления модели и относящуюся к данной модели,
устанавливая название по следующему шаблону:
intermediate.stg_flights__aircrafts_backup_[YYYY_MM_DD_HHSSmm], 
где [YYYY_MM_DD_HHSSmm] - год, месяц, число, часы, минуты и секунды текущего времени (времени начала обновления модели) #}
{{
    config(
        materialized = 'table',
        post_hook = '
            {% set timestamp = run_started_at | string | replace("-", "") | replace(" ", "_") | replace(":", "") | truncate(15, True, "") %}
            {% set base_identifier = this.identifier | replace("_backup", "") %}
            {% set backup_table = base_identifier ~ "_backup_" ~ timestamp %}
            
            {% set backup_relation = api.Relation.create(
                    database = this.database,
                    schema = this.schema,
                    identifier = backup_table,
                    type = "table"
                ) 
            %}
            
            {% do adapter.drop_relation(backup_relation) %}
            {% do adapter.rename_relation(this, backup_relation) %}
        '
    )

}}
select
    aircraft_code,
    model,
    "range"
from
    {{ source('demo_src', 'aircrafts') }}
{# Макрос на основе graph считающий количество моделей, seed, snapshot в проекте #}
{% macro count_models() %}
{% if execute %}
  {% set models = graph.nodes.values() | selectattr('resource_type', 'equalto', 'model') | list %}
  {% set seeds = graph.nodes.values() | selectattr('resource_type', 'equalto', 'seed') | list %}
  {% set snapshots = graph.nodes.values() | selectattr('resource_type', 'equalto', 'snapshot') | list %}

  {% set model_count = models | length %}
  {% set seed_count = seeds | length %}
  {% set snapshot_count = snapshots | length %}

  {{ log("Total in the project:", info=True) }}
  {{ log("- " ~ model_count ~ " models", info=True) }}
  {{ log("- " ~ seed_count ~ " seed", info=True) }}
  {{ log("- " ~ snapshot_count ~ " snapshot", info=True) }}
{% endif %}
{% endmacro %}

{# log("текст", info=True) 
Пишет сообщение в стандартный вывод (stdout). Видно в консоли при запуске команд типа dbt run, dbt build, dbt debug и т.п. #}
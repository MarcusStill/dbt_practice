{# Получаем список колонок #}

{% set fligths_relation = load_relation(ref('stg_flights__flights')) %}
{%- set columns = adapter.get_columns_in_relation(fligths_relation) -%}

{% for column in columns -%}
  {{ "Column: " ~ column }}
{% endfor %}

{# Получаем список колонок #}
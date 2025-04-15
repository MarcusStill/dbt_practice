{% macro limit_data_dev(column_name, days=5000) %}
{% if days < 0 %}
  {{ exceptions.raise_compiler_error("Error in the value passed in the 'days' parameter. Got: " ~ days) }}
{% endif %}
{% if target.name == 'dev' %}
WHERE
    {{ column_name }} >= current_date - interval '{{ days }} days'
{% endif %}
{% endmacro %}
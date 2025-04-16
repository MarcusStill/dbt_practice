{# Макрос проверяет от какого количества других объектов (seed, snapshot, models и т.д.) зависит текущая модель #}
{% macro check_dependencies(relation) %}
{% if execute %}
  {% set model_node = graph.nodes.values() 
      | selectattr("alias", "equalto", relation.identifier) 
      | selectattr("resource_type", "equalto", "model")
      | list 
      | first %}

  {% if model_node is not none %}
    {% set dependencies = model_node.depends_on.nodes %}
    {% set dependency_count = dependencies | length %}

    {% if dependency_count > 1 %}
      {{ log("Model " ~ model_node.name ~ " depends on " ~ dependency_count ~ " the objects!", info=True) }}
    {% endif %}
  {% endif %}
{% endif %}
{% endmacro %}

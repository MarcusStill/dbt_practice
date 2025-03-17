{% macro safe_select(table_name) %}

    {%- set target_database = target.database -%}
    {%- set target_schema = target.schema -%}

    {%- set table_exists = adapter.get_relation(
        database=target_database,
        schema=target_schema,
        identifier=table_name
    ) -%}

    {% if table_exists %}
        {% set query %}
            SELECT * FROM {{ target_database }}.{{ target_schema }}.{{ table_name }}
        {% endset %}
        {% set results = run_query(query) %}
        {% if results %}
            {% do log("Query results:", info=True) %}
            {% for row in results %}
                {% do log(row, info=True) %}
            {% endfor %}
        {% else %}
            {% do log("No rows returned.", info=True) %}
        {% endif %}
    {% else %}
        {% do log("Table does not exist. Returning SELECT NULL.", info=True) %}
        SELECT NULL AS result
    {% endif %}

{% endmacro %}
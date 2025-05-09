{%- macro concat_columns(columns, delim = ', ') %}
{# удаление таблиц и представлений в БД, которым нет соответствующих model, seed и snapshot в dbt проекте #}
    {%- for column in columns -%}
        {{ column }} {% if not loop.last %} || '{{ delim }}' || {% endif %}
    {%- endfor -%}
{% endmacro %}

{% macro drop_old_relations(dryrun=False) %}

    {% if execute %}
    
        {# находим все модели, seed, snapshot проекта dbt #}
        
        {% set current_models = [] %}
        
        {% for node in graph.nodes.values() | selectattr("resource_type", "in", ["model", "snapshot", "seed"]) %}
            {% do current_models.append(node.name) %}
        {% endfor %}
        
        {# формирование скрипта удаления всез таблиц и вьюх, которым не соответствует ни одна модель, сид и снэпшот #}
        
        {% set cleanup_query %}
        WITH MODELS_TO_DROP AS (
            SELECT
                CASE
                    WHEN TABLE_TYPE = 'BASE TABLE' THEN 'TABLE'
                    WHEN TABLE_TYPE = 'VIEW' THEN 'VIEW'
                END AS RELATION_TYPE,
                CONCAT_WS('.', TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME) as RELATION_NAME
            FROM
                {{ target.database }}.INFORMATION_SCHEMA.TABLES
            WHERE
                TABLE_SCHEMA = '{{ target.schema }}'
                AND UPPER(TABLE_NAME) NOT IN (
                    {%- for model in current_models -%}
                        '{{ model.upper() }}'
                        {%- if not loop.last -%}
                            ,
                        {%- endif %}
                    {%- endfor -%}
                )
        )
        SELECT
            'DROP ' || RELATION_TYPE || ' ' || RELATION_NAME || ';' as DROP_COMMANDS
        FROM
            MODELS_TO_DROP;
        {% endset %}
        
        {% do log(cleanup_query) %}
        
        {% set drop_commands = run_query(cleanup_query).columns[0].values() %}
        
        {# удаление лишних таблиц и вьюх / вывод скрипта удаления #}
        
        
        {% if drop_commands %}
            {% if dryrun | as_bool == False %}
                {% do log('Executing DROP commands ...', True) %}
            {% else %}
                {% do log('Printing DROP commands ...', True) %}
            {% endif %}
        
            {% for drop_command in drop_commands %}
                {% do log(drop_command, True) %}
                {% if  dryrun | as_bool == False %}
                    {% do run_query(drop_command) %}
                {% endif %}
            {% endfor %}
        {% else %}
             {% do log('No relations to clean', True) %}
        {% endif %}
    
    {% endif %}
{# 
Вызов макроса без удаления таблиц и представлений:
dbt run-operation drop_old_relations --args '{"dryrun": True}'

Вызов макроса с удалением таблиц и представлений:
dbt run-operation drop_old_relations
#}
{% endmacro %}

{# Макрос, который перечислит через запятую названия всех колонок из модели, название, которой будет передано в аргументе #}
{% macro show_columns_relation(relation) %}
    {# Получаем список колонок из переданного relation #}
    {%- set columns = adapter.get_columns_in_relation(relation) -%}

    {# Формируем строку с перечислением колонок через запятую #}
    {%- set column_names = columns | map(attribute='column') | join(', ') -%}

    {# Если колонок нет, возвращаем звездочку для выборки всех колонок #}
    {%- if column_names == '' %}
        {%- set column_names = '*' %}
    {%- endif %}

    {{ return(column_names) }}
{% endmacro %}


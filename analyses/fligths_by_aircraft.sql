{% set aicraft_query %}
select distinct
    aircraft_code
from
    {{ ref('fct_flights') }}
{% endset %}

{% set aicraft_query_results = run_query(aicraft_query) %}
{% if execute %}
    {% set important_aircrafs = aicraft_query_results.columns[0].values() %}
{% else %}
    {% set important_aircrafs = [] %}
{% endif %}
select
    {# {% set important_aircrafs = ['CN1', 'CR2', '763'] %} #}
    {% for aircraft in important_aircrafs %}
    sum(case when aircraft_code = '{{ aicraft }}' then 1 else 0 end) as fligths_{{ aicraft }}
        {%- if not loop.last %},{% endif %}
    {%- endfor %}
from
    {{ ref('fct_flights') }}

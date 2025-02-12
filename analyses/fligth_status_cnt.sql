{% set fligth_status_query %}
select distinct
    status
from
    {{ ref('stg_flights__flights') }}
{% endset %}

{% set aicraft_query_results = run_query(fligth_status_query) %}
{% if execute %}
    {% set fligth_status = aicraft_query_results.columns[0].values() %}
{% else %}
    {% set fligth_status = [] %}
{% endif %}
select
    {% for status in fligth_status %}
    count(case when status = '{{ status }}' then 1 end) as status_{{ status | replace(" ", "_") }}
         {%- if not loop.last %},{% endif %}
    {%endfor %}
from
    {{ ref('stg_flights__flights') }}
/* OR 
select distinct status, count(status) from {{ ref('stg_flights__flights') }} group by status 
*/
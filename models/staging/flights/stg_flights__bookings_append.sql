{{
    config(
        materialized = 'incremental',
        incremental_strategy = 'append',
        tags = ['bookings']
    )

}}
select
    book_ref,
    book_date,
    {{ penny_to_rub(column_name='total_amount') }} as total_amount
from 
    {{ source('demo_src', 'bookings') }}
{% if is_incremental() %}
where
    {{ bookref_to_bigint(bookref = 'book_ref') }} >= (SELECT MAX({{ bookref_to_bigint(bookref = 'book_ref') }}) FROM {{ this }})

{% endif %}
{# Приводим строкое значение из поля book_ref типу bigint. #}
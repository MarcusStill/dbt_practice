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
from {{ source('demo_src', 'bookings') }}
{% if is_incremental() %}
WHERE
    ('0x' || book_ref)::bigint > (SELECT MAX(('0x' || book_ref)::bigint) FROM {{ this }})

{% endif %}
/* Приводим строкое значение из поля book_ref к шестнадцаричному числу. Из-за преобразования получаем замедление. */
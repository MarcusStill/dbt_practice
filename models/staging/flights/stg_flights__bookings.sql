{{
    config(
        materialized = 'table',
        tags = ['bookings']
    )

}}

select
    {{ show_columns_relation(this) }}
from 
    {{ source('demo_src', 'bookings') }}
{{ limit_data_dev('book_date') }}
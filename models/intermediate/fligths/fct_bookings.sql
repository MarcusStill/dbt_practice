{{
  config(
        materialized = 'table',
        meta = {
            'owner': 'sql_file_owner@gmail.com'
        }
    )
}}
select
    {{ dbt_utils.generate_surrogate_key(['book_ref']) }} as booking_sk,
    book_ref,
    book_date,
    total_amount
from
    {{ ref('stg_flights__bookings') }}
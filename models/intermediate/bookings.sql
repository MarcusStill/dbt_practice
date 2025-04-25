{{
  config(
      materialized = 'table'
  )
}}
select
    flight_id,
    count(book_ref) as bookings_count,
    sum(total_amount) as bookings_total_amount
from {{ ref('fct_bookings') }}
group by flight_id

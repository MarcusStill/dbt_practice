{{
  config(
      materialized = 'table'
  )
}}
select
    flight_id,
    (count(t.ticket_no) - sum(case when t.ticket_no is not null then 1 else 0 end)) as ticket_flights_no_sold
from {{ ref('fct_tickets') }} t
group by flight_id

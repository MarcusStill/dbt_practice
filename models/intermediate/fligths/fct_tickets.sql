{{
  config(
      materialized = 'table'
  )
}}
 select
    tickets.ticket_no,
    tickets.book_ref,
    tickets.passenger_id,
    tickets.passenger_name,
    tickets.contact_data
from
    {{ ref('stg_flights__tickets') }} as tickets
 left join
    {{ ref('employee_tickets') }} as employees
    --{{ ref('stg_dict__employee_tickets') }} as employees
on
    tickets.passenger_id = employees.passenger_id
where
    employees.passenger_id is null
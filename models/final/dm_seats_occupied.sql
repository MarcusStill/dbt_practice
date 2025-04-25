{{ 
  config(
      materialized = 'table'
  ) 
}}

with ticket_flights as (
    select
        ticket_no,
        flight_id,
        amount
    from {{ ref('ticket_flights') }}
),
boarding_passes as (
    select
        ticket_no,
        flight_id,
        boarding_no,
        seat_no
    from {{ ref('stg_flights__boarding_passes') }}
),
seats as (
    select
        aircraft_code,
        seat_no,
        fare_conditions
    from {{ ref('stg_flights__seats') }}
),
flights as (
    select
        flight_id,
        flight_no,
        scheduled_departure,
        scheduled_arrival,
        departure_airport,
        arrival_airport,
        "status",
        aircraft_code,
        actual_departure,
        actual_arrival
    from {{ ref('stg_flights__flights') }}
),
departure_airports as (
    select
        airport_code,
        airport_name,
        city,
        coordinates
    from {{ ref('stg_flights__airports') }}
),
arrival_airports as (
    select
        airport_code,
        airport_name,
        city,
        coordinates
    from {{ ref('stg_flights__airports') }}
)

select
    f.departure_airport as Departure_Airport_Code,
    da.airport_name as Departure_Airport_Name,
    da.city as Departure_Airport_City,
    da.coordinates::text as Departure_Airport_Coordinates,
    f.arrival_airport as Arrival_Airport_Code,
    aa.airport_name as Arrival_Airport_Name,
    aa.city as Arrival_Airport_City,
    aa.coordinates::text as Arrival_Airport_Coordinates,
    f."status" as Flight_status,
    f.aircraft_code as Aircraft_code,
    f.scheduled_departure as Scheduled_departure_date,
    f.flight_no as Flight_no,
    f.flight_id as Flight_id,
    count(tf.ticket_no) as Ticket_flights_purchased,
    count(bp.boarding_no) as Boarding_passes_issued,
    sum(tf.amount) as Ticket_flights_amount,
    (count(se.seat_no) - count(tf.ticket_no)) as Ticket_flights_no_sold
from 
    flights f
left join ticket_flights tf on f.flight_id = tf.flight_id
left join boarding_passes bp on tf.ticket_no = bp.ticket_no
left join seats se on f.aircraft_code = se.aircraft_code and se.seat_no = bp.seat_no
left join departure_airports da on f.departure_airport = da.airport_code
left join arrival_airports aa on f.arrival_airport = aa.airport_code

group by 
    f.departure_airport, da.airport_name, da.city, da.coordinates::text,
    f.arrival_airport, aa.airport_name, aa.city, aa.coordinates::text,
    f."status", f.aircraft_code, f.scheduled_departure, f.flight_no, f.flight_id

{# Витрина dm_seats_occupied
Измерения (dimensions):
Departure_Airport_Code - код аэропорта отправления
Departure_Airport_Name - название аэропорта отправления
Departure_Airport_City - город аэропорта отправления
Departure_Airport_Coordinates - координаты аэропорта отправления
Arrival_Airport_Code - код аэропорта прибытия 
Arrival_Airport_City- город аэропорта прибытия 
Arrival_Airport_Name - название аэропорта прибытия 
Arrival_Airport_Coordinates - координаты аэропорта прибытия 
Flight_status - статус рейса
Aircraft_code - код самолета
Aircraft_model - модель самолета
Scheduled_departure_date - запланированная дата отправления
Flight_no - номер полета
Flight_id - идентификатор полета

Меры (measures):
Ticket_flights_purchased - количество купленных билетов (count(fct_ticket_flights.ticket_no))
Boarding_passes_issued - количество выданных посадочных талонов (count(fct_boarding_passes.ticket_no))
Ticket_flights_amount - сумма стоимости проданных билетов (sum(fct_ticket_flights.amount) ) 
Ticket_flights_no_sold - количество не проданных билетов (то есть оставшихся пустых мест в самолете) на рейс (считаем, сколько всего место в самолете и вычитаем количество проданных мест в самолете в рамках рейса) 
#}
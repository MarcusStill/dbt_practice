select
    aircraft_code,
    count(*) as aircraft_seat_cnt
from
    {{ ref('stg_flights__seats') }}
group by
    aircraft_code

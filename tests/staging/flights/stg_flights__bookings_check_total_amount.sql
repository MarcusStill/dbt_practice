{# Тест для проверки модели с бронированиями, который проверяет строки,
у которых поле total_amount больше 10000000 или меньше или равно 0. #}

select
    *
from "dwh_flight"."intermediate"."stg_flights__bookings"
    where total_amount <= 0
       or total_amount > 10000000
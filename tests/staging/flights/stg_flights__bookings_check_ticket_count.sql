{# Тест для проверки, что нет бронирований, в которые входит 5 или более билетов.
Если количество бронирований с 5 или более билетами:
- до 50, то не выводить предупреждение
- от 50 до 100, то вывести предупреждение
- более 100, то вывести ошибку #}
{{
    config(
        severity = 'error',
        error_if = '> 100',
        warn_if = '> 50'
    )
}}
WITH ticket_counts AS (
    SELECT 
        book_ref,
        COUNT(*) AS ticket_count
    FROM {{ ref('stg_flights__tickets') }}
    GROUP BY book_ref
)
SELECT
    book_ref
FROM ticket_counts
WHERE ticket_count >= 5

{# Тест для поиска некорректных записей #}
SELECT
    book_ref
FROM
    {{ ref('stg_flights__bookings') }}
WHERE
    length(book_ref) > 7
    
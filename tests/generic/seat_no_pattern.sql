{# Тест проверяет соответствие значений в колонке шаблону: 1_или2_цифры_+_буква #}
{% test seat_no_pattern(model, column_name) %}
    SELECT
        {{ column_name }}
    FROM
        {{ model }}
    WHERE NOT {{ column_name }} ~ '^[0-9]{1,2}[A-Z]+$'
{% endtest %}
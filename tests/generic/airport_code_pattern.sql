{# Тест проверяет соответствие значений в колонке шаблону: 3 символа, только заглавные буквы (A-Z) #}
{% test airport_code_pattern(model, column_name) %}
    SELECT
        {{ column_name }} AS invalid_airport_code
    FROM {{ model }}
    WHERE {{ column_name }} IS NOT NULL
      AND NOT (
          {{ column_name }} ~ '^[A-Z]{3}$'
      )
{% endtest %}
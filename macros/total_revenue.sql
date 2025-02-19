{% macro get_total_revenue(quantity_col, price_col) %}
    {{ quantity_col }} * {{ price_col }}
{% endmacro %}
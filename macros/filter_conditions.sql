{% macro filter_conditions(customer_id_null_filter=true, min_quantity=1) %}
    {% if customer_id_null_filter %}
        AND customerid IS NOT NULL
    {% endif %}
    {% if min_quantity > 0 %}
        AND quantity > {{ min_quantity }}
    {% endif %}
{% endmacro %}

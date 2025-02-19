{% macro incremental_config(unique_key) %}
  {{
    config(
      materialized='incremental',
      unique_key=unique_key,
      incremental_strategy='merge'
    )
  }}
{% endmacro %}

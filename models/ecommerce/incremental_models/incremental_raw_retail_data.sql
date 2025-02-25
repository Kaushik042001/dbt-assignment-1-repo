{{ config(
    materialized='incremental',
    unique_key='unique_id'
) }}

WITH incremental_raw_retail_data AS (
    SELECT
        unique_id,
        invoice_no,
        stock_code,
        description,
        quantity,
        invoice_date,
        unit_price,
        customer_id,
        country
    FROM {{ ref("unique_records") }}
    
    {% if is_incremental() %}
        -- Only include new records based on the latest invoice_date
        WHERE invoice_date > (SELECT MAX(invoice_date) FROM {{ this }})
    {% endif %}
)

SELECT * FROM incremental_raw_retail_data

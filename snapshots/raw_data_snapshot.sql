{% snapshot unique_records_snapshot %}

{{ config(
    target_schema='dbt_kchari',
    unique_key='unique_id',
    strategy='timestamp',  
    updated_at='invoice_date',  
    invalidate_hard_deletes=True
}}

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

{% endsnapshot %}

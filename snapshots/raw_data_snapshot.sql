{% snapshot unique_records_snapshot %}

{{ config(
    target_schema='dbt_kchari',
    unique_key='unique_id',
    strategy='check',
    check_cols=['invoice_no', 'stock_code','description', 'quantity','invoice_date', 'unit_price', 'customer_id', 'country'],  
    invalidate_hard_deletes=True
) }}

select
    unique_id,
    invoice_no,
    stock_code,
    description,
    quantity,
    invoice_date,
    unit_price,
    customer_id,
    country
from {{ ref("unique_records") }}

{% endsnapshot %}


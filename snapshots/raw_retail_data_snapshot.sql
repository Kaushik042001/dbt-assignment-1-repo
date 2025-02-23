{% snapshot raw_retail_data_snapshot %}

{{
  config(
    target_database='assignment_db',           
    target_schema='dbt_kchari',       
    unique_key='unique_id',                   
    strategy='timestamp',                      
    updated_at='invoice_date'                
  )
}}

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
from {{ ref("unique_raw_retail_data_records") }}

{% endsnapshot %}



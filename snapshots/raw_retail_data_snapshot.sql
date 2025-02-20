{% snapshot raw_retail_data_snapshot %}

{{
  config(
    target_database='assignment_db',           
    target_schema='ecommerce_snapshots',       
    unique_key='unique_key',                   
    strategy='timestamp',                      
    updated_at='invoice_date',                 
  )
}}

select
    invoiceno as invoice_no,
    stockcode as stock_code,
    description,
    quantity,
    invoicedate as invoice_date,
    unitprice as unit_price,
    customerid as customer_id,
    country,
    cast(
        row_number() over (
            order by invoice_date, customer_id, invoiceno, stockcode
        ) as string
    ) as unique_key
from {{ source("ecommerce", "raw_retail_data") }}

{% endsnapshot %}


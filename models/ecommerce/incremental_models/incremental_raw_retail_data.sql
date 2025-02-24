{{ config(
    materialized='incremental',
    unique_key='unique_id'
) }}

with incremental_raw_retail_data as (
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
)

select * from incremental_raw_retail_data

{{
    config(
        materialized="incremental",
        incremental_strategy="merge",
        unique_key="unique_id",
        updated_at="invoice_date"
    )
}}

-- Place the incremental condition first
{% if is_incremental() %}
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
    from {{ ref("unique_raw_retail_data_records") }}
    where invoice_date > (select max(invoice_date) from {{ this }})
)
{% else %}
-- For a full refresh, no filter is applied
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
    from {{ ref("unique_raw_retail_data_records") }}
)
{% endif %}

-- Final select
select * from incremental_raw_retail_data

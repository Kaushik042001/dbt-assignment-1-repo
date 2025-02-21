{{
    config(
        materialized="incremental",
        incremental_strategy="merge",
        unique_key="unique_key",
        updated_at="invoice_date",
    )
}}

-- Place the incremental condition first
{% if is_incremental() %}
with incremental_raw_retail_data as (
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
                order by invoicedate, customerid, invoiceno, stockcode
            ) as string
        ) as unique_key
    from {{ source("ecommerce", "raw_retail_data") }}
    where invoice_date > (select max(invoice_date) from {{ this }})
)
{% else %}
-- For a full refresh, no filter is applied
with incremental_raw_retail_data as (
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
                order by invoicedate, customerid, invoiceno, stockcode
            ) as string
        ) as unique_key
    from {{ source("ecommerce", "raw_retail_data") }}
)
{% endif %}

-- Final select
select * from incremental_raw_retail_data

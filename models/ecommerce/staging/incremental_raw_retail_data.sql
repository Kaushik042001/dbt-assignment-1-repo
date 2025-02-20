{{
    config(
        materialized="incremental",
        incremental_strategy="merge",
        unique_key="unique_key",
        updated_at="invoice_date",
    )
}}

with
    incremental_raw_retail_data as (
        select
            invoiceno as invoice_no,
            stockcode as stock_code,
            description,
            quantity,
            invoicedate as invoice_date,
            unitprice as unit_price,
            customerid as customer_id,
            country,
            -- Generate a surrogate key (for unique identification)
            cast(
                row_number() over (
                    order by invoicedate, customerid, invoiceno, stockcode
                ) as string
            ) as unique_key
        from {{ source("ecommerce", "raw_retail_data") }}
    )

{% if is_incremental() %}
    -- Incremental condition: Only process new or updated records since the last run
    where invoice_date > (select max(invoice_date) from {{ this }})
{% endif %}

-- Base selection for the model
select *
from incremental_raw_retail_data

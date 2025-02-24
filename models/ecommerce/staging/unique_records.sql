with unique_records as (

    select
        {{ dbt_utils.generate_surrogate_key(['invoiceno', 'stockcode', 'invoicedate', 'customerid', 'quantity', 'unitprice']) }} as unique_id,
        invoiceno as invoice_no,
        stockcode as stock_code,
        description,
        quantity,
        invoicedate as invoice_date,
        unitprice as unit_price,
        customerid as customer_id,
        country
    from {{ ref("stg_raw_retail_data") }}
)

select * from unique_records
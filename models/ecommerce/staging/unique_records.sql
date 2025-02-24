with unique_records as (
    select
        invoiceno as invoice_no,
        stockcode as stock_code,
        description,
        quantity,
        invoicedate as invoice_date,
        unitprice as unit_price,
        customerid as customer_id,
        country,
        md5(concat_ws('|', 
            coalesce(invoiceno::string, 'NULL'), 
            coalesce(stockcode::string, 'NULL'), 
            coalesce(invoicedate::string, 'NULL'), 
            coalesce(customerid::string, 'NULL')
        )) as unique_id
    from {{ ref("stg_raw_retail_data") }}
)

select * from unique_records

with unique_raw_retail_data_records as (
    select
        invoiceno as invoice_no,
        stockcode as stock_code,
        description,
        quantity,
        invoicedate invoice_date,
        unitprice as unit_price,
        customerid as customer_id,
        country,
        md5(concat_ws('|', 
            coalesce(invoiceno::string, 'NULL'), 
            coalesce(stockcode::string, 'NULL'), 
            coalesce(invoicedate::string, 'NULL'), 
            coalesce(customerid::string, 'NULL')
        )) as unique_key
    from {{ ref("stg_raw_retail_data") }}
)

select * from unique_raw_retail_data_records

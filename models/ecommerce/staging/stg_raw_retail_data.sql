with stg_raw_retail_data as (
    select
        invoiceno,
        stockcode,
        description,
        quantity,
        invoicedate,
        unitprice,
        customerid,
        country
    from {{ source("ecommerce","raw_retail_data")}}
)

select * from stg_raw_retail_data


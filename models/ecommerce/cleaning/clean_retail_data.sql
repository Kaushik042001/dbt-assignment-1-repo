{{
  config(
    cluster_by = ['customer_id', 'invoice_date']  
  )
}}

WITH clean_retail_data AS (
    SELECT 
        invoiceno AS invoice_no,
        stockcode AS stock_code,
        description,
        quantity,
        invoicedate AS invoice_date,
        unitprice AS unit_price,
        customerid AS customer_id,
        country
    FROM {{ ref('stg_raw_retail_data') }}
    WHERE 1=1 -- This ensures the macro conditions can append without syntax errors
    {{ filter_conditions(customer_id_null_filter=true, min_quantity=1) }} -- macro for filter conditions
)

SELECT * FROM clean_retail_data

WITH clean_retail_data AS (
    SELECT 
        invoiceno AS invoice_no,
        stockcode AS stock_code,
        description,
        quantity,
        invoicedate AS invoice_date,
        unitprice AS unit_price,
        customerid AS customer_id,
        country,
        ROW_NUMBER() OVER (PARTITION BY stockcode ORDER BY invoicedate DESC) AS row_num
    FROM {{ ref('stg_raw_retail_data') }}
    WHERE 1=1
    {{ filter_conditions(customer_id_null_filter=true, min_quantity=1) }}
)

-- Select only the first row for each distinct stock_code
SELECT * 
FROM clean_retail_data
WHERE row_num = 1

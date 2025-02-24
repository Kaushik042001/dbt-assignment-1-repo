WITH deduplicated_records AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY invoiceno, stockcode, customerid, quantity, unitprice, country
            ORDER BY CAST(invoicedate AS TIMESTAMP_NTZ) DESC  -- Select latest invoicedate
        ) AS row_num
    FROM {{ ref("stg_raw_retail_data") }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key([
        'invoiceno', 'stockcode', 'CAST(invoicedate AS TIMESTAMP_NTZ)', 'customerid', 'quantity', 'unitprice', 'country'
    ]) }} AS unique_id,
    invoiceno AS invoice_no,
    stockcode AS stock_code,
    description,
    quantity,
    CAST(invoicedate AS TIMESTAMP_NTZ) AS invoice_date,  -- Ensure invoicedate is stored as TIMESTAMP_NTZ
    unitprice AS unit_price,
    customerid AS customer_id,
    country
FROM deduplicated_records
WHERE row_num = 1  -- Select only the latest record per duplicate set



SELECT
    crd.customer_id,
    count(crd.invoice_no) as total_orders,
    cp.total_revenue as total_monetary_value,
    MIN(crd.invoice_date) AS first_purchase_date,
    MAX(crd.invoice_date) AS last_purchase_date, -- To calculate the date range
    DATEDIFF('day', first_purchase_date, last_purchase_date) AS total_days, -- Calculate the number of days since the first purchase
    -- Calculate purchase frequency by day
    CASE 
        WHEN total_days = 0 THEN COUNT(crd.invoice_no)  -- Handle edge case for single-day purchases
        ELSE total_orders / total_days
    END AS purchase_frequency_per_day
FROM 
    {{ ref('clean_retail_data') }} AS crd
INNER JOIN {{ ref("customer_purchases") }} AS cp
ON crd.customer_id = cp.customer_id
GROUP BY crd.customer_id, total_orders, total_monetary_value
ORDER BY purchase_frequency_per_day , total_days DESC


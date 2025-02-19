WITH customer_purchases AS (
    SELECT
        customer_id,
        invoice_no,
        invoice_date,  -- Include the invoice date to ensure uniqueness
        COUNT(invoice_no) AS total_orders,
        SUM(quantity) AS total_quantity,
        SUM(unit_price) AS total_price,
        AVG(unit_price) AS avg_order_value,
        {{ get_total_revenue('total_quantity', 'total_price') }} AS total_revenue
    FROM {{ ref("clean_retail_data") }}
    GROUP BY customer_id, invoice_no, invoice_date  -- Group by invoice_date for uniqueness
    ORDER BY total_revenue DESC
)

-- Aggregate at the customer level
SELECT 
    customer_id, 
    COUNT(total_orders) AS total_order_count
FROM customer_purchases 
GROUP BY customer_id
ORDER BY total_order_count DESC

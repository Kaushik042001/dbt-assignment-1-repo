{{
  config(
    materialized='ephemeral',

    
    pre_hook=[
        "INSERT INTO audit_logs (model_name, execution_time, status) VALUES ('customer_purchases', CURRENT_TIMESTAMP, 'STARTED')"
    ],

    post_hook=[
        "INSERT INTO audit_logs (model_name, execution_time, status) VALUES ('customer_purchases', CURRENT_TIMESTAMP, 'COMPLETED')"
    ]
  )
}}

SELECT
    customer_id,
    invoice_no,
    COUNT(invoice_no) AS total_orders,
    SUM(quantity) AS total_quantity,
    SUM(unit_price) AS total_price,
    AVG(unit_price) AS avg_order_value,
    {{ get_total_revenue('total_quantity', 'total_price') }} AS total_revenue
FROM {{ ref("clean_retail_data") }}
GROUP BY customer_id, invoice_no
ORDER BY total_revenue DESC

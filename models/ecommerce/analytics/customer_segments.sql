SELECT
    customer_id,
    total_quantity,
    total_revenue,
    avg_order_value,
    -- Segmentation rules: Adjust thresholds as needed
    case
        when total_revenue > 5000 THEN 'High Value'
        when avg_order_value >= 5 THEN 'Frequent Buyer'
        else 'Low Value'
    end as customer_segment
from {{ ref('customer_purchases') }}
        
select
    customer_id,
    total_quantity,
    total_revenue,
    avg_order_value,
    -- Segmentation rules
    case
        when total_revenue > 5000
        then 'High Value'
        when avg_order_value >= 5
        then 'Frequent Buyer'
        else 'Low Value'
    end as customer_segment
from {{ ref("customer_purchases") }}

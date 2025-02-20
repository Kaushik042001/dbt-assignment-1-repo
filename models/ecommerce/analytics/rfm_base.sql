select
    crd.customer_id,
    count(crd.invoice_no) as total_orders,
    cp.total_revenue as total_monetary_value,
    min(crd.invoice_date) as first_purchase_date,
    max(crd.invoice_date) as last_purchase_date,  -- To calculate the date range
    datediff('day', first_purchase_date, last_purchase_date) as total_days,  -- Calculate the number of days since the first purchase
    -- Calculate purchase frequency by day
    case
        when total_days = 0
        then count(crd.invoice_no)  -- Handle edge case for single-day purchases
        else total_orders / total_days
    end as purchase_frequency_per_day

from {{ ref("clean_retail_data") }} as crd
inner join {{ ref("customer_purchases") }} as cp on crd.customer_id = cp.customer_id

group by crd.customer_id, total_orders, total_monetary_value
order by purchase_frequency_per_day, total_days desc

select

    customer_id,
    datediff('day', last_purchase_date, current_date) as recency,
    purchase_frequency_per_day,
    total_monetary_value,

    -- Assign RFM scores using NTILE
    ntile(5) over (
        order by datediff('day', current_date, last_purchase_date)
    ) as recency_score,
    ntile(5) over (order by purchase_frequency_per_day desc) as frequency_score,
    ntile(5) over (order by total_monetary_value desc) as monetary_score

from {{ ref("rfm_base") }}
order by frequency_score asc

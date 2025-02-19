SELECT
    customer_id,
    DATEDIFF('day', last_purchase_date, CURRENT_DATE) AS recency,
    purchase_frequency_per_day,
    total_monetary_value,

    -- Assign RFM scores using NTILE
    NTILE(5) OVER (ORDER BY DATEDIFF('day', CURRENT_DATE, last_purchase_date)) AS recency_score,
    NTILE(5) OVER (ORDER BY purchase_frequency_per_day DESC) AS frequency_score,
    NTILE(5) OVER (ORDER BY total_monetary_value DESC) AS monetary_score
FROM {{ ref('rfm_base')}}
ORDER BY frequency_score ASC
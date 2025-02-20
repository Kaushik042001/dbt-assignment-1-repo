SELECT
    
    *,
    recency_score + frequency_score + monetary_score AS rfm_score,
    CASE
        WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'Top Customers'
        WHEN recency_score <= 2 AND frequency_score <= 2 AND monetary_score <= 2 THEN 'At-Risk Customers'
        ELSE 'Average Customers'
    END AS rfm_segment
    
FROM {{ ref("rfm_scores")}}
select

    sales_date,
    daily_sales,
    LAG(daily_sales) OVER (ORDER BY sales_date) AS previous_day_sales,
    (daily_sales - LAG(daily_sales) OVER (ORDER BY sales_date)) /
    NULLIF(LAG(daily_sales) OVER (ORDER BY sales_date), 0) * 100 AS sales_growth

FROM {{ref("daily_sales")}}

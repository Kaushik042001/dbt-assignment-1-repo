select

    date_trunc('day', invoice_date) AS sales_date,
    sum(unit_price) AS daily_sales

from {{ ref('clean_retail_data') }}
group by sales_date


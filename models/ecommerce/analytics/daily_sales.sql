{{ incremental_config('sales_date') }}
with daily_sales as (
    select
        date_trunc('day', invoice_date) AS sales_date,
        sum(unit_price) AS daily_sales
    from {{ ref('clean_retail_data') }}
    group by sales_date


    {% if is_incremental() %}
        HAVING MAX(invoice_date) > (SELECT MAX(sales_date) FROM {{ this }})
    {% endif %}
)

select * from daily_sales
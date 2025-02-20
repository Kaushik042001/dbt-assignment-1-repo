{{
  config(
    materialized='ephemeral'
  )
}}


select 
    
    date_trunc('day', invoice_date) as sales_date, 
    sum(unit_price) as daily_sales

from {{ ref("clean_retail_data") }}
group by sales_date

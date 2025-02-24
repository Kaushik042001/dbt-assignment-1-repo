{% snapshot unique_records_snapshot %}

{{
  config(
    target_database='assignment_db',   
    target_schema='dbt_kchari',        
    unique_key='unique_id',            
    strategy='timestamp',              
    updated_at='invoice_date'          
  )
}}

select * from {{ ref("unique_records") }}

{% endsnapshot %}

select * from unique_records_snapshot

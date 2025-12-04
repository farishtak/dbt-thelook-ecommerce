{{ config( materialized='incremental', 
  incremental_strategy='merge',
  unique_key='order_items_id',
  on_schema_change='sync_all_columns', 
  partition_by={'field': 'order_date', 'data_type': 'date'}, 
  cluster_by=['order_id'] ) }} 
  
   /*partition splits table by order_date for performance and cluster groups data with similar order_id close together for efficiency. 
    incremental merge adds new records and updates existing ones based on pk match on order_id */
  


with base as (
    
     select *
      from {{ ref('stg_thelook_orderitems') }}
      
       {% if is_incremental() %} -- Only consider data newer than the last ODS partition or a small backfill window - this will backload from 3 days prior to most recent order_date 
       where order_date >= date_sub( (select coalesce(max(order_date), date '1970-01-01') from {{ this }}), interval 3 day ) 
       {% endif %} ) 
       
       
       select * from base
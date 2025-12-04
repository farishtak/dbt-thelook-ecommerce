{{ config( materialized='incremental', 
  incremental_strategy='merge',
  unique_key='product_id',
  on_schema_change='sync_all_columns', 
  partition_by={'field': 'load_date', 'data_type': 'date'}, 
  cluster_by=['product_id'] ) }} 
  
   /*partition splits table by load_date for performance and cluster groups data with similar product_id close together for efficiency. 
    incremental merge adds new records and updates existing ones based on pk match on order_id */
  


with base as (
    
     select *
      from {{ ref('stg_thelook_products') }}
      
       {% if is_incremental() %} -- Only consider data newer than the last ODS partition or a small backfill window - this will backload from 3 days prior to most recent order_date 
       where load_date >= date_sub( (select coalesce(max(load_date), date '1970-01-01') from {{ this }}), interval 3 day ) 
       {% endif %} ) 
       
       
       select * from base
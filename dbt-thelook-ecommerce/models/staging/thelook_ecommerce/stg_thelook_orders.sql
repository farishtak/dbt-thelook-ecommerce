--this is where we conduct data type castings, column name changes, add utility columns to our raw/staging data

select distinct 
cast(order_id as string) order_id,
cast(user_id as string) customer_id,
status order_status,
gender,
cast(DATETIME(TIMESTAMP(created_at), "America/Los_Angeles") as date) order_date,
DATETIME(TIMESTAMP(created_at), "America/Los_Angeles") created_at_pst,
DATETIME(TIMESTAMP(returned_at), "America/Los_Angeles") returned_at_pst,
DATETIME(TIMESTAMP(shipped_at), "America/Los_Angeles") shipped_at_pst,
DATETIME(TIMESTAMP(delivered_at), "America/Los_Angeles") delivered_at_pst,
num_of_item,
current_date('America/Los_Angeles') load_date

from {{ source('thelook_ecommerce', 'orders') }} 

where cast(DATETIME(TIMESTAMP(created_at), "America/Los_Angeles") as date) = DATE_SUB(
  DATE(CURRENT_DATETIME('America/Los_Angeles')),
  INTERVAL 1 DAY
)   --returns yesterday's data only to mimic ingest data for prior day

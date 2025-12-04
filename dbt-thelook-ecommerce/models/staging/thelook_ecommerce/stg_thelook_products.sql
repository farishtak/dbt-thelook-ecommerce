--this is where we conduct data type castings, column name changes, add utility columns to our raw/staging data

select distinct 
cast(id as string) product_id,
cost,
category,
name,
brand,
retail_price, 
department,
sku,
distribution_center_id,
current_date('America/Los_Angeles') load_date

from {{ source('thelook_ecommerce', 'products') }} 

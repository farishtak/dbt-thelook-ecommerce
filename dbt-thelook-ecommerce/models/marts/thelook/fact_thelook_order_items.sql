-- fact table containing total order counts by product and date

with order_items as (

select 
order_date,
product_id, 
count(order_items_id) times_ordered

from {{ ref('ods_thelook_orderitems') }}

group by 
order_date,
product_id
)

select 
oi.order_date,
p.product_id,
p.category,
p.brand,
p.name,
oi.times_ordered

      
    from order_items oi join {{ ref('ods_thelook_products') }} p
         on oi.product_id = p.product_id 
    
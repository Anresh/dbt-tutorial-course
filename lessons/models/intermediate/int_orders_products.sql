WITH products AS (
        SELECT 
        product_id,
        cost as product_cost,
        retail_price as product_retail_price,
        department as product_department
        FROM {{ ref("stg_ecommerce__products") }}
)

SELECT
--item data
        order_items.order_item_id AS order_item_id,
        order_items.order_id,
        order_items.user_id,
        order_items.product_id,
        order_items.sale_price,
        --product data
        products.product_cost,
        products.product_retail_price,
        products.product_department,
--calculated fileds
        
      order_items.sale_price-products.product_cost as item_profit,
      products.product_retail_price-order_items.sale_price as discount
FROM {{ ref("stg_ecommerce__order_items") }} as order_items
left join products on products.product_id=order_items.product_id

/*
    Checks that, for any order, that the number of line items in the order_items table
	matches the num_items_ordered column in the orders table.

    Returns all of the rows where we don't get a match

    We could run multiple checks here (e.g. check only 1 user_id per order, or that the shipped_at timestamps
	are all the same for a given order), but this is just an example of a custom test.
*/

--{{config(severity='warn')}}
WITH order_details AS (
SELECT
order_id,
count(*) as number_of_items_in_order
FROM {{ref("stg_ecommerce__order_items")}}
GROUP BY 1)

SELECT 
o.order_id,
o.items_count,
od.number_of_items_in_order
FROM {{ref("stg_ecommerce__orders")}} o
FULL OUTER JOIN order_details od
USING(order_id)
where o.order_id IS NULL
or
od.order_id is NULL
or o.items_count!=od.number_of_items_in_order
WITH

-- Aggregate measures
order_item_measures AS (
	SELECT
		order_id,
		SUM(sale_price) AS total_sale_price,
		SUM(product_cost) AS total_product_cost,
		SUM(item_profit) AS total_profit,
		SUM(discount) AS total_discount

        --{%- set departments= ['Men','Women'] -%}
		{% for department in dbt_utils.get_column_values(table=ref('int_orders_products'), column='product_department') %}
		SUM(IF(product_department = '{{ department }}', item_sale_price, 0)) AS total_sold_{{ department.lower() }}swear{{"," if not loop.last }}
{%- endfor %})


SELECT
    od.order_id,
	od.created_at AS order_created_at,
	{{ is_weekend('od.created_at') }} ,
    od.shipped_at AS order_shipped_at,
	od.delivered_at AS order_delivered_at,
	od.returned_at AS order_returned_at,
	od.status AS order_status,
	od.items_count,
	om.total_sale_price,
	om.total_product_cost,
	om.total_profit,
	om.total_discount,
	-- Columns from our templated Jinja statement
	-- We could just hard code these if we wanted, e.g.: total_sold_menswear, total_sold_womenswear
	{%- for department_name in departments %}
	om.total_sold_{{department_name.lower()}}swear,
	{%- endfor %}

	-- In practise we'd calculate this column in the model itself, but it's
	-- a good way to demonstrate how to use an ephemeral materialisation
	TIMESTAMP_DIFF(od.created_at, user_data.first_order_created_at, DAY) AS days_since_first_order
FROM {{ ref('stg_ecommerce__orders') }} AS od
LEFT JOIN order_item_measures AS om
	ON od.order_id = om.order_id
left join {{ref('int_ecommerce__first_order_created')}} as user_data
on user_data.user_id=od.user_id
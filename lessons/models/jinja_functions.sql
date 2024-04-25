{# 
get all columns in a table
#}
{% set columns = adapter.get_columns_in_relation(ref('orders')) %}

{#
get all columns in a table check that they start with 'total'
#}
SELECT
{%- for column in columns -%}
  {% if column.name.startswith('total') %}
{{ column.name.upper() }},
  {%- endif -%}
{%- endfor %}

{#
get all values from a column in a table 
#}

{% set values = dbt_utils.get_column_values(ref('orders'), 'order_status') %}

{{values}}
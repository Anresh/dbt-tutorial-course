{%- macro is_weekend(date_column) -%}
 EXTRACT(DAYOFWEEK from DATE({{ date_column }})) in  (1,7)
{%- endmacro -%}
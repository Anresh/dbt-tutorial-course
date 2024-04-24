{#
	This test is basically a "not_null" and "unique"
	rolled into one.

	It fails if a column is NULL or occurs more than once
#}

{% test primary_key(model, column_name) %}
with validation as (
select {{column_name}} as primary_key,
count(1) as occurrences
from {{model}}
group by 1
)

select *
from validation
where occurrences>1 or primary_key is null
{% endtest %}

{% test col_greater_than(model, column_name,value=0) %}
select {{column_name}} as row_that_failed
from {{model}}
where {{column_name}}<={{value}}
{% endtest %}
{# comment that WILL NOT 
appear in the compiled sql #}

--comment that WILL appear in the compiled sql

{% set my_long_variable %}
SELECT 1 as my_col
{% endset -%}


{{my_long_variable}}
{{my_long_variable}}
{{my_long_variable}}


{% set my_list = ['user_id','created_at']%}
select 
{% for item in my_list %}
{{ item }} {% if not loop.last %},{% endif %}
{% endfor %}

{{ my_list }}
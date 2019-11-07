{% macro extract_email_domain(email) -%}
  SUBSTRING(email, STRPOS(email, '@') + 1)
{%- endmacro %}

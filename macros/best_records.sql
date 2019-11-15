{#
  Pattern for selecting the highest scoring rows according to a scoring
  expression or ordering over a given source and partition. 
  
  To provide a scoring function, callers should use Jinja 'call' blocks to invoke
  this macro (see https://jinja.palletsprojects.com/en/2.10.x/templates/#call)
  and use the caller body to provide the scoring function.

  Example:

  {% call best_records(ref('user_actions'), partition_by='user_id') %}
    CASE
      WHEN signup_date > DATEADD('day', -7 CURRENT_DATE) THEN 10
      ELSE 5
    END
  {% endcall %}

  For simpler use cases, the `order_by` keyword arg can be specified to
  provide an ordering for choosing the best record for each partition.

  Example:

  {{ best_records(ref('user_actions'),
                  partition_by='user_id',
                  order_by='signup_date DESC') }}
 #}
{% macro best_records(source=null, partition_by='id', order_by=None) %}
WITH
{% if caller %}
  scored_records AS (
    SELECT *,
      {{ caller() }} AS _score
    FROM {{ source }}
  ),

  ranked_records AS (
    SELECT 
      *,
      ROW_NUMBER() OVER (
        PARTITION BY {{ partition_by }}
        ORDER BY _score DESC
      ) AS _rank
    FROM scored_records
  )
{% else %}
  ranked_records AS (
    SELECT
      *,
      ROW_NUMBER() OVER (
        PARTITION BY {{ partition_by }}
        {% if order_by %}ORDER BY {{ order_by }}{% endif %}
      ) AS _rank
    FROM {{ source }}
  )
{% endif %}

SELECT * FROM ranked_records WHERE _rank = 1
{% endmacro %}

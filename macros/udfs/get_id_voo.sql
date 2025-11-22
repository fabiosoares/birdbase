{% macro getIdVoo() %}

CREATE OR REPLACE FUNCTION {{target.schema}}.getIdVoo(voo STRING)
RETURNS STRING
AS (
    CASE 
        WHEN UPPER(voo) = 'YES' THEN '2' -- Não voa
        WHEN UPPER(voo) = 'NO' THEN '1' -- Voa
        WHEN UPPER(voo) = 'PARTIAL' THEN '3'
        ELSE NULL
    END
)

{% endmacro %}

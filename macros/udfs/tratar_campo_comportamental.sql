{% macro tratarCampoComportamental() %}

CREATE OR REPLACE FUNCTION {{target.schema}}.tratarCampoComportamental(comportamento STRING)
RETURNS INTEGER
AS (
    CASE 
        WHEN comportamento IN ('1','0') THEN CAST(comportamento AS INTEGER) 
        ELSE NULL
    END
)

{% endmacro %}

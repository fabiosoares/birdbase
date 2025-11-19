{% macro tratarCampoBoolString() %}

CREATE OR REPLACE FUNCTION {{target.schema}}.tratarCampoBoolString(campo INTEGER)
RETURNS STRING
AS (
    CASE 
        WHEN campo = 1 THEN 'SIM'
        WHEN campo = 0 THEN 'NÃO'
        ELSE 'NÃO INFORMADO'
    END
)

{% endmacro %}

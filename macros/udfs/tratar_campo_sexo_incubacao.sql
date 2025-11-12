{% macro tratarCampoSexoIncubacao() %}

CREATE OR REPLACE FUNCTION {{target.schema}}.tratarCampoSexoIncubacao(sexo STRING)
RETURNS STRING
AS (
    CASE 
        WHEN UPPER(sexo) LIKE '%B%' THEN 'AMBOS'
        WHEN UPPER(sexo) LIKE '%M%' THEN 'MACHO'
        WHEN UPPER(sexo) LIKE '%F%' THEN 'FEMEA' 
        ELSE NULL
    END
)

{% endmacro %}

{% macro removerAcentos() %}
CREATE OR REPLACE FUNCTION {{target.schema}}.removerAcentos(frase string)
RETURNS STRING
LANGUAGE js AS """
if (frase === null || frase === undefined)
    return null

return frase.replace(/[ÀÁÂÃÄÅ]/g, 'A')
              .replace(/[àáâãäå]/g, 'a')
              .replace(/[ÈÉÊË]/g, 'E')
              .replace(/[èéêë]/g, 'e')
              .replace(/[ÌÍÎÏ]/g, 'I')
              .replace(/[ìíîï]/g, 'i')
              .replace(/[ÒÓÔÕÖ]/g, 'O')
              .replace(/[òóôõö]/g, 'o')
              .replace(/[ÙÚÛÜ]/g, 'U')
              .replace(/[ùúûü]/g, 'u')
              .replace(/[Ç]/g, 'C')
              .replace(/[ç]/g, 'c')
              .replace(/[Ñ]/g, 'N')
              .replace(/[ñ]/g, 'n')
"""
{% endmacro %}

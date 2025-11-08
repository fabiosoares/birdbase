{% macro tratarNumerico() %}

CREATE OR REPLACE FUNCTION {{target.schema}}.tratarNumerico(str STRING)
RETURNS string
LANGUAGE js AS """
str = str.trim().replace(',', '.');
str = str.replace('T', '0.001');

return str;
"""

{% endmacro %}

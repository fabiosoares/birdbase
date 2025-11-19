-- https://discourse.getdbt.com/t/using-dbt-to-manage-user-defined-functions/18
{% macro create_udfs() %}

create schema if not exists {{target.schema}};

-- genéricas
{{removerAcentos()}};
{{tratarCamposTp()}};
{{tratarNumerico()}};
{{tratarCampoBoolString()}};
-- específicas birdbase
{{tratarCampoComportamental()}};
{{tratarCampoSexoIncubacao()}};


{% endmacro %}
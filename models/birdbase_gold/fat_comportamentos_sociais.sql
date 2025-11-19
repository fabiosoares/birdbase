-- dbt run --select fat_comportamentos_sociais
{{
  config(
	materialized='view',
	unique_key='id_ave',
	tags=['birdbase', 'fat']
  )
}}

SELECT
    fat_aves.id_ave,
    fat_aves.sgk_ordem,
    dim_ordens.tp_ordem_latin AS tp_ordem_latin,
    dim_ordens.ds_ordem AS ds_ordem,
    fat_aves.nm_cientifico  AS nm_cientifico,
    CONCAT(dim_ordens.tp_ordem_latin, ' (',dim_ordens.ds_ordem,')') AS tp_ds_ordem,
    {{ target.schema }}.tratarCampoBoolString(fat_aves.is_comportamento_colonial) AS tp_comportamento_colonial,
    {{ target.schema }}.tratarCampoBoolString(fat_aves.is_comportamento_forma_bando) AS is_comportamento_forma_bando,
    {{ target.schema }}.tratarCampoBoolString(fat_aves.is_comportamento_pares_grupos_familiares) AS is_comportamento_pares_grupos_familiares,
    {{ target.schema }}.tratarCampoBoolString(fat_aves.is_comportamento_solitario_pares) AS tp_comportamento_solitario_pares,
    {{ target.schema }}.tratarCampoBoolString(fat_aves.is_comportamento_solitario) AS tp_comportamento_solitario,
    {{ target.schema }}.tratarCampoBoolString(fat_aves.is_monogamia) AS tp_comportamento_monogamia,
    {{ target.schema }}.tratarCampoBoolString(fat_aves.is_poligamia) AS tp_comportamento_poligamia,
    {{ target.schema }}.tratarCampoBoolString(fat_aves.is_criacao_cooperativa) AS tp_comportamento_criacao_cooperativa,
FROM
  {{ ref('fat_aves') }} fat_aves
LEFT JOIN {{ ref('dim_ordens') }} dim_ordens
    ON fat_aves.sgk_ordem = dim_ordens.sgk_ordem





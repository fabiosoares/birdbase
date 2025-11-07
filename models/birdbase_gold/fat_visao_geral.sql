-- dbt run --select fat_visao_geral
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
    fat_aves.tp_familia,
    fat_aves.tp_genero,
    fat_aves.tp_especie
FROM
  {{ ref('fat_aves') }} fat_aves
LEFT JOIN {{ ref('dim_ordens') }} dim_ordens
    ON fat_aves.sgk_ordem = dim_ordens.sgk_ordem





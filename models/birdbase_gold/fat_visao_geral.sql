-- dbt run --select fat_visao_geral
{{
  config(
	materialized='view',
	unique_key='id_passaro',
	tags=['birdbase', 'fat']
  )
}}

SELECT
    fat_passaros.id_passaro,
    fat_passaros.sgk_ordem,
    dim_ordens.tp_ordem_latin AS tp_ordem_latin,
    dim_ordens.ds_ordem AS ds_ordem,
    fat_passaros.nm_cientifico  AS nm_cientifico,
    CONCAT(dim_ordens.tp_ordem_latin, ' (',dim_ordens.ds_ordem,')') AS tp_ds_ordem,
    fat_passaros.tp_familia,
    fat_passaros.tp_genero,
    fat_passaros.tp_especie
FROM
  {{ ref('fat_passaros') }} fat_passaros
LEFT JOIN {{ ref('dim_ordens') }} dim_ordens
    ON fat_passaros.sgk_ordem = dim_ordens.sgk_ordem





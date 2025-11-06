-- dbt run --select fat_passaros
{{
  config(
	materialized='table',
	unique_key='id_passaro',
	tags=['birdbase', 'fat']
  )
}}



SELECT
    d.ioc_15_1 AS id_passaro,
    dim_status_conservacao.sgk_status_conservacao AS sgk_status_conservacao,
    d.latin_birdlife_ioc_clements_avilist AS nm_cientifico,


FROM
  {{ source( 'birdbase_bronze',
    'data' ) }} d

LEFT JOIN {{ ref('dim_status_conservacao') }} dim_status_conservacao
    ON d.2024_iucn_red_list_category = dim_status_conservacao.tp_status_conservacao
    OR (d.2024_iucn_red_list_category IS NULL AND dim_status_conservacao.sgk_status_conservacao = 'NULL')



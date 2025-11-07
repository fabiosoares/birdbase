-- dbt run --select ft_conservacao_biogeografia
{{
  config(
	materialized='view',
	unique_key='id_passaro',
	tags=['birdbase', 'fat']
  )
}}

SELECT
    fat_passaros.id_passaro,
    fat_passaros.sgk_status_conservacao,
    dim_status_conservacao.nm_portugues,
    fat_passaros.sgk_reino_biogeografico,
    dim_reino_biogeografico.tp_reino_biogeografico,
    fat_passaros.nm_cientifico
FROM
  {{ ref('fat_passaros') }} fat_passaros
LEFT JOIN {{ ref('dim_status_conservacao') }} dim_status_conservacao
    ON fat_passaros.sgk_status_conservacao = dim_status_conservacao.sgk_status_conservacao
LEFT JOIN {{ ref('dim_reino_biogeografico') }} dim_reino_biogeografico
    ON fat_passaros.sgk_reino_biogeografico = dim_reino_biogeografico.sgk_reino_biogeografico





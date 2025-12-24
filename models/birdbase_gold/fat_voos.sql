-- dbt run --select fat_voos
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
    fat_aves.nm_popular,
    CONCAT(dim_ordens.tp_ordem_latin, ' (',dim_ordens.ds_ordem,')') AS tp_ds_ordem,
    dim_voos.ds_voo AS ds_voo,
    dim_migracoes.ds_migracao AS ds_migracao,
    {{ target.schema }}.tratarCampoBoolString(fat_aves.is_migracao_altitudinal_elevacional) AS tp_migracao_altitudinal_elevacional,
    {{ target.schema }}.tratarCampoBoolString(fat_aves.is_movimento_irregular) AS tp_movimento_irregular,
    {{ target.schema }}.tratarCampoBoolString(fat_aves.is_dispersao_longa_distancia) AS tp_dispersao_longa_distancia,
    {{ target.schema }}.tratarCampoBoolString(fat_aves.is_sedentario) AS tp_sedentario,
FROM
  {{ ref('fat_aves') }} fat_aves
LEFT JOIN {{ ref('dim_ordens') }} dim_ordens
    ON fat_aves.sgk_ordem = dim_ordens.sgk_ordem
LEFT JOIN {{ ref('dim_voos') }} dim_voos
    ON fat_aves.sgk_voo = dim_voos.sgk_voo
LEFT JOIN {{ ref('dim_migracoes') }} dim_migracoes
    ON fat_aves.sgk_migracao = dim_migracoes.sgk_migracao





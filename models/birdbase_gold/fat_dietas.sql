-- dbt run --select fat_dietas
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
    fat_aves.vl_dieta_peso_invertebrados,
    fat_aves.vl_dieta_peso_frutas,
    fat_aves.vl_dieta_peso_nectar,
    fat_aves.vl_dieta_peso_sementes,
    fat_aves.vl_dieta_peso_vertebrados_terrestres,
    fat_aves.vl_dieta_peso_peixes,
    fat_aves.vl_dieta_peso_carniceiros,
    fat_aves.vl_dieta_peso_vegetal_nao_reprodutivo,
    fat_aves.vl_dieta_peso_diversificada,
    fat_aves.vl_dieta_ponderada_total,
    fat_aves.ds_dieta,
    fat_aves.qtd_tp_alimentos_principais_consumidos,
    fat_aves.nr_esi_indice_especializacao_ecologica,
    dim_dietas.tp_dieta_portugues
FROM
  {{ ref('fat_aves') }} fat_aves
LEFT JOIN {{ ref('dim_ordens') }} dim_ordens
    ON fat_aves.sgk_ordem = dim_ordens.sgk_ordem
LEFT JOIN {{ ref('dim_dietas') }} dim_dietas
    ON fat_aves.sgk_dieta = dim_dietas.sgk_dieta





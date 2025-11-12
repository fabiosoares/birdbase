-- dbt run --select fat_habitats
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
    fat_aves.is_habitat_forestal,
    fat_aves.is_habitat_bambu,
    fat_aves.is_habitat_bosque,
    fat_aves.is_habitat_arbustos,
    fat_aves.is_habitat_savana,
    fat_aves.is_habitat_pastagens,
    fat_aves.is_habitat_planicies,
    fat_aves.is_habitat_areas_rochosas,
    fat_aves.is_habitat_artificial,
    fat_aves.is_habitat_riparia,
    fat_aves.is_habitat_costa_maritma,
    fat_aves.is_habitat_zonas_umidas,
    fat_aves.is_habitat_mar_aberto,
    fat_aves.is_habitat_outros,
    dim_habitats_principal.ds_habitat AS ds_habitat_principal,
    dim_habitats_principal.tp_habitat_portugues AS tp_habitat_principal,
    fat_aves.qtd_habitats_principais,
    fat_aves.nr_esi_indice_especializacao_ecologica
FROM
  {{ ref('fat_aves') }} fat_aves
LEFT JOIN {{ ref('dim_ordens') }} dim_ordens
    ON fat_aves.sgk_ordem = dim_ordens.sgk_ordem
LEFT JOIN {{ ref('dim_habitats') }} dim_habitats_principal
    ON fat_aves.sgk_habitat_principal = dim_habitats_principal.sgk_habitat






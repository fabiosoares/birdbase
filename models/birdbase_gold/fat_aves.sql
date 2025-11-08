-- dbt run --select fat_aves
{{
  config(
	materialized='table',
	unique_key='id_ave',
	tags=['birdbase', 'fat']
  )
}}



SELECT
    -- 1. Informações Taxonômicas e Nomenclatura
    d.ioc_15_1 AS id_ave,
    d.latin_birdlife_ioc_clements_avilist AS nm_cientifico,
    dim_ordens.sgk_ordem AS sgk_ordem,
    d.family_ioc_15_1 AS tp_familia,
    d.genus AS tp_genero,
    d.species AS tp_especie,
    -- 2. Conservação e Biogeografia
    dim_reino_biogeografico.sgk_reino_biogeografico AS sgk_reino_biogeografico,
    dim_status_conservacao.sgk_status_conservacao AS sgk_status_conservacao,
    CAST(d.rr AS BOOLEAN) AS is_alcance_global_restrito,
    CAST(d.isl AS BOOLEAN) AS is_reproducao_restrita_ilhas,
    dim_faixa_latitudinal.id_faixa_latitudinal

FROM
  {{ source( 'birdbase_bronze',
    'data' ) }} d

LEFT JOIN {{ ref('dim_status_conservacao') }} dim_status_conservacao
    ON d.2024_iucn_red_list_category = dim_status_conservacao.tp_status_conservacao
    OR (d.2024_iucn_red_list_category IS NULL AND dim_status_conservacao.sgk_status_conservacao = 'NULL')
LEFT JOIN {{ ref('dim_reino_biogeografico') }} dim_reino_biogeografico
    ON UPPER(d.rlm) = dim_reino_biogeografico.tp_reino_biogeografico
LEFT JOIN {{ ref('dim_ordens') }} dim_ordens
    ON d.order = dim_ordens.tp_ordem_latin
LEFT JOIN {{ ref('dim_faixa_latitudinal') }} dim_faixa_latitudinal
    ON d.lat = dim_faixa_latitudinal.id_faixa_latitudinal





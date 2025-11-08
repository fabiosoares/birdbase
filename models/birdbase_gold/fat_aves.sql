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
    dim_faixa_latitudinal.id_faixa_latitudinal,
    
    -- 4. Habitat e Dieta
    CAST(d.f AS BOOLEAN) AS is_habitat_forestal,
    CAST(d.bm AS BOOLEAN) AS is_habitat_bambu,
    CAST(d.wd AS BOOLEAN) AS is_habitat_bosque,
    CAST(d.sh AS BOOLEAN) AS is_habitat_arbustos,
    CAST(d.sv AS BOOLEAN) AS is_habitat_savana,
    CAST(d.g AS BOOLEAN) AS is_habitat_pastagens,
    CAST(d.pl AS BOOLEAN) AS is_habitat_planicies,
    CAST(d.r AS BOOLEAN) AS is_habitat_areas_rochosas,
    CAST(d.a AS BOOLEAN) AS is_habitat_artificial,
    CAST(d.rv AS BOOLEAN) AS is_habitat_riparia,
    CAST(d.c AS BOOLEAN) AS is_habitat_costa_maritma,
    CAST(d.w AS BOOLEAN) AS is_habitat_zonas_umidas,
    CAST(d.se AS BOOLEAN) AS is_habitat_mar_aberto,
    CAST(d.o AS BOOLEAN) AS is_habitat_outros,
    CAST(d.o_desc AS BOOLEAN) AS ds_habitat_outros,
    d.primary_habitat AS nm_habitat_principal,
    d.hb AS qtd_habitats_principais,

    -- 4.2 Dieta
    dim_dietas.sgk_dieta AS sgk_dieta,
    CAST(REPLACE(d.in_wt, 'T', '0.001') AS NUMERIC) AS vl_dieta_peso_invertebrados,
    CAST(REPLACE(d.fr_wt, 'T', '0.001') AS NUMERIC) AS vl_dieta_peso_frutas,
    CAST(REPLACE(d.ne_wt, 'T', '0.001') AS NUMERIC) AS vl_dieta_peso_nectar,
    CAST(REPLACE(d.se_wt, 'T', '0.001') AS NUMERIC) AS vl_dieta_peso_sementes,
    CAST(REPLACE(d.ve_wt, 'T', '0.001') AS NUMERIC) AS vl_dieta_peso_vertebrados_terrestres,
    CAST(REPLACE(d.fi_wt, 'T', '0.001') AS NUMERIC) AS vl_dieta_peso_peixes,
    CAST(REPLACE(d.sc_wt, 'T', '0.001') AS NUMERIC) AS vl_dieta_peso_carniceiros,
    CAST(REPLACE(d.pl_wt, 'T', '0.001') AS NUMERIC) AS vl_dieta_peso_vegetal_nao_reprodutivo,
    CAST(REPLACE(d.ms_wt, 'T', '0.001') AS NUMERIC) AS vl_dieta_peso_diversificada,
    CAST(d.sum_wt AS NUMERIC) AS vl_dieta_ponderada_total,
    d.desc AS ds_dieta,
    d.db AS qtd_tp_alimentos_principais_consumidos,
    d.esi AS nr_esi_indice_especializacao_ecologica,
    
    
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
LEFT JOIN {{ ref('dim_dietas') }} dim_dietas
    ON d.primary_diet = dim_dietas.tp_dieta_ingles





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
    CAST(d.f AS INTEGER) AS is_habitat_forestal,
    CAST(d.bm AS INTEGER) AS is_habitat_bambu,
    CAST(d.wd AS INTEGER) AS is_habitat_bosque,
    CAST(d.sh AS INTEGER) AS is_habitat_arbustos,
    CAST(d.sv AS INTEGER) AS is_habitat_savana,
    CAST(d.g AS INTEGER) AS is_habitat_pastagens,
    CAST(d.pl AS INTEGER) AS is_habitat_planicies,
    CAST(d.r AS INTEGER) AS is_habitat_areas_rochosas,
    CAST(d.a AS INTEGER) AS is_habitat_artificial,
    CAST(d.rv AS INTEGER) AS is_habitat_riparia,
    CAST(d.c AS INTEGER) AS is_habitat_costa_maritma,
    CAST(d.w AS INTEGER) AS is_habitat_zonas_umidas,
    CAST(d.se AS INTEGER) AS is_habitat_mar_aberto,
    CAST(d.o AS INTEGER) AS is_habitat_outros,
    d.o_desc AS ds_habitat_outros,
    dim_habitats_principal.sgk_habitat AS sgk_habitat_principal,
    d.hb AS qtd_habitats_principais,

    -- 4.2 Dieta
    dim_dietas.sgk_dieta AS sgk_dieta,
    
    CAST({{target.schema}}.tratarNumerico(d.in_wt) AS NUMERIC) AS vl_dieta_peso_invertebrados,
    CAST({{target.schema}}.tratarNumerico(d.fr_wt) AS NUMERIC) AS vl_dieta_peso_frutas,
    CAST({{target.schema}}.tratarNumerico(d.ne_wt) AS NUMERIC) AS vl_dieta_peso_nectar,
    CAST({{target.schema}}.tratarNumerico(d.se_wt) AS NUMERIC) AS vl_dieta_peso_sementes,
    CAST({{target.schema}}.tratarNumerico(d.ve_wt) AS NUMERIC) AS vl_dieta_peso_vertebrados_terrestres,
    CAST({{target.schema}}.tratarNumerico(d.fi_wt) AS NUMERIC) AS vl_dieta_peso_peixes,
    CAST({{target.schema}}.tratarNumerico(d.sc_wt) AS NUMERIC) AS vl_dieta_peso_carniceiros,
    CAST({{target.schema}}.tratarNumerico(d.pl_wt) AS NUMERIC) AS vl_dieta_peso_vegetal_nao_reprodutivo,
    CAST({{target.schema}}.tratarNumerico(d.ms_wt) AS NUMERIC) AS vl_dieta_peso_diversificada,
    CAST(d.sum_wt AS NUMERIC) AS vl_dieta_ponderada_total,
    d.desc AS ds_dieta,
    d.db AS qtd_tp_alimentos_principais_consumidos,
    d.esi AS nr_esi_indice_especializacao_ecologica,

    -- 5.1 Comportamento Social
    {{target.schema}}.tratarCampoComportamental(d.social_1) AS is_comportamento_colonial,
    {{target.schema}}.tratarCampoComportamental(d.social_2) AS is_comportamento_forma_bando,
    {{target.schema}}.tratarCampoComportamental(d.social_3) AS is_comportamento_pares_grupos_familiares,
    {{target.schema}}.tratarCampoComportamental(d.social_4) AS is_comportamento_solitario_pares,
    {{target.schema}}.tratarCampoComportamental(d.social_5) AS is_comportamento_solitario,
    {{target.schema}}.tratarCampoComportamental(CAST(d.mono AS STRING)) AS is_monogamia,
    {{target.schema}}.tratarCampoComportamental(CAST(d.poly AS STRING)) AS is_poligamia,
    {{target.schema}}.tratarCampoComportamental(CAST(d.coop AS STRING)) AS is_criacao_cooperativa,

    -- 5.2 Reprodução
    d.brd1 AS nr_ninhada_minima_anual,
    d.brd2 AS nr_ninhada_maxima_anual,
    d.clutch_min AS nr_ovos_minimo_por_ninhada,
    d.clutch_max AS nr_ovos_maximo_por_ninhada,
    {{target.schema}}.tratarCampoSexoIncubacao(d.incu_sex) AS tp_sexo_incubacao,
    d.incu1 AS nr_dias_incubacao_minima,
    d.incu2 AS nr_dias_incubacao_maxima,
    d.fldg1 AS nr_dias_periodo_fledging_minimo,
    d.fldg2 AS nr_dias_periodo_fledging_maximo,
    d.para_1 AS is_parasita_ninho,
    {{target.schema}}.tratarCampoComportamental(d.para_2) AS is_parasita_ninho_vitima,

    -- 6 Movimento
    

    
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
LEFT JOIN {{ ref('dim_habitats') }} dim_habitats_principal
    ON d.primary_habitat = dim_habitats_principal.tp_habitat_ingles





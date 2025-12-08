-- dbt run --select fat_comportamentos_sociais
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
    fat_aves.tp_familia,
    fat_aves.tp_genero,
    fat_aves.tp_especie,
    fat_aves.nm_cientifico,
    fat_aves.nm_portugues,
    fat_aves.nm_popular,
    CASE WHEN fat_aves.nm_popular IS NOT NULL THEN
      CONCAT(fat_aves.nm_cientifico, ' (', fat_aves.nm_popular, ')')
    ELSE fat_aves.nm_cientifico
    END AS nm_cientifico_portugues,
    fat_aves.nm_gcp_path_image,
    CONCAT(dim_ordens.tp_ordem_latin, ' (',dim_ordens.ds_ordem,')') AS tp_ds_ordem,
    -- Comportamento Social
    {{ target.schema }}.tratarCampoBoolString(fat_aves.is_comportamento_colonial) AS tp_comportamento_colonial,
    {{ target.schema }}.tratarCampoBoolString(fat_aves.is_comportamento_forma_bando) AS is_comportamento_forma_bando,
    {{ target.schema }}.tratarCampoBoolString(fat_aves.is_comportamento_pares_grupos_familiares) AS is_comportamento_pares_grupos_familiares,
    {{ target.schema }}.tratarCampoBoolString(fat_aves.is_comportamento_solitario_pares) AS tp_comportamento_solitario_pares,
    {{ target.schema }}.tratarCampoBoolString(fat_aves.is_comportamento_solitario) AS tp_comportamento_solitario,
    {{ target.schema }}.tratarCampoBoolString(fat_aves.is_monogamia) AS tp_comportamento_monogamia,
    {{ target.schema }}.tratarCampoBoolString(fat_aves.is_poligamia) AS tp_comportamento_poligamia,
    {{ target.schema }}.tratarCampoBoolString(fat_aves.is_criacao_cooperativa) AS tp_comportamento_criacao_cooperativa,
    -- Reprodução
    fat_aves.nr_ninhada_minima_anual,
    fat_aves.nr_ninhada_maxima_anual,
    fat_aves.nr_ovos_minimo_por_ninhada,
    fat_aves.nr_ovos_maximo_por_ninhada,
    fat_aves.tp_sexo_incubacao,
    fat_aves.nr_dias_incubacao_minima,
    fat_aves.nr_dias_incubacao_maxima,
    fat_aves.nr_dias_periodo_fledging_minimo,
    fat_aves.nr_dias_periodo_fledging_maximo,
    {{ target.schema }}.tratarCampoBoolString(fat_aves.is_parasita_ninho) AS tp_parasita_ninho,
    {{ target.schema }}.tratarCampoBoolString(fat_aves.is_parasita_ninho_vitima) AS tp_parasita_ninho_vitima,

    -- Conservação Biogeográfica
    dim_status_conservacao.nm_portugues AS nm_status_conservacao,
    CONCAT(dim_reino_biogeografico.tp_reino_biogeografico, ' - ', dim_reino_biogeografico.nm_portugues) AS nm_reino_biogeografico,
    {{ target.schema }}.tratarCampoBoolString(CAST(fat_aves.is_alcance_global_restrito AS INTEGER)) AS tp_alcance_restrito,
    {{ target.schema }}.tratarCampoBoolString(CAST(fat_aves.is_reproducao_restrita_ilhas AS INTEGER)) AS tp_reproducao_restrita_ilhas,
    dim_faixa_latitudinal.tp_faixa_latitudinal,
FROM
  {{ ref('fat_aves') }} fat_aves
LEFT JOIN {{ ref('dim_ordens') }} dim_ordens
    ON fat_aves.sgk_ordem = dim_ordens.sgk_ordem
LEFT JOIN {{ ref('dim_status_conservacao') }} dim_status_conservacao
    ON fat_aves.sgk_status_conservacao = dim_status_conservacao.sgk_status_conservacao
LEFT JOIN {{ ref('dim_reino_biogeografico') }} dim_reino_biogeografico
    ON fat_aves.sgk_reino_biogeografico = dim_reino_biogeografico.sgk_reino_biogeografico
LEFT JOIN {{ ref('dim_faixa_latitudinal') }} dim_faixa_latitudinal
    ON fat_aves.id_faixa_latitudinal = dim_faixa_latitudinal.id_faixa_latitudinal





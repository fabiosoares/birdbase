-- dbt run --select fat_reproducoes
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

FROM
  {{ ref('fat_aves') }} fat_aves
LEFT JOIN {{ ref('dim_ordens') }} dim_ordens
    ON fat_aves.sgk_ordem = dim_ordens.sgk_ordem





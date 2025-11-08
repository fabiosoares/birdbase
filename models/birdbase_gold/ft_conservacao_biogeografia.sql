-- dbt run --select ft_conservacao_biogeografia
{{
  config(
	materialized='view',
	unique_key='id_passaro',
	tags=['birdbase', 'fat']
  )
}}

SELECT
    fat_aves.id_ave,
    fat_aves.sgk_status_conservacao,
    dim_status_conservacao.nm_portugues,
    fat_aves.sgk_reino_biogeografico,
    CONCAT(dim_reino_biogeografico.tp_reino_biogeografico, ' - ', dim_reino_biogeografico.nm_portugues) AS nm_reino_biogeografico,
    fat_aves.nm_cientifico,
    fat_aves.is_alcance_global_restrito,
    fat_aves.is_reproducao_restrita_ilhas,
    dim_faixa_latitudinal.tp_faixa_latitudinal
FROM
  {{ ref('fat_aves') }} fat_aves
LEFT JOIN {{ ref('dim_status_conservacao') }} dim_status_conservacao
    ON fat_aves.sgk_status_conservacao = dim_status_conservacao.sgk_status_conservacao
LEFT JOIN {{ ref('dim_reino_biogeografico') }} dim_reino_biogeografico
    ON fat_aves.sgk_reino_biogeografico = dim_reino_biogeografico.sgk_reino_biogeografico
LEFT JOIN {{ ref('dim_faixa_latitudinal') }} dim_faixa_latitudinal
    ON fat_aves.id_faixa_latitudinal = dim_faixa_latitudinal.id_faixa_latitudinal





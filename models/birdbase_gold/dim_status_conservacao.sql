-- dbt run -select dim_status_conservacao
{{
  config(
	materialized='table',
	unique_key='sgk_status_conservacao',
	tags=['birdbase', 'dim']
  )
}}

WITH tbl_base AS (
    SELECT 'EX'  AS sgk_status_conservacao, 'EX'  AS tp_status_conservacao, 'Extinct' AS nm_ingles, 'Extinto' AS nm_portugues
    UNION ALL
    SELECT 'EW', 'EW', 'Extinct in the Wild', 'Extinto na Natureza'
    UNION ALL
    SELECT 'CR', 'CR', 'Critically Endangered', 'Criticamente Ameaçado'
    UNION ALL
    SELECT 'CR_PEW', 'CR (PEW)', 'Possibly Extinct in the Wild', 'Possivelmente Extinto na Natureza'
    UNION ALL
    SELECT 'EN', 'EN', 'Endangered', 'Em Perigo'
    UNION ALL
    SELECT 'VU', 'VU', 'Vulnerable', 'Vulnerável'
    UNION ALL
    SELECT 'NT', 'NT', 'Near Threatened', 'Quase Ameaçado'
    UNION ALL
    SELECT 'LC', 'LC', 'Least Concern', 'Pouco Preocupante'
    UNION ALL
    SELECT 'DD', 'DD', 'Data Deficient', 'Dados Insuficientes'
)
SELECT * FROM tbl_base

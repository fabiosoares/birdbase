-- dbt run -select dim_status_conservacao
{{
  config(
	materialized='table',
	unique_key='sgk_status_conservacao',
	tags=['birdbase', 'dim']
  )
}}

WITH tbl_base AS (
    SELECT 'EX'  AS sgk_status_conservacao, 'EX'  AS tp_status_conservacao, 'Extinct' AS nm_ingles, 'Extinto' AS nm_portugues, 'EXTINTO' AS tp_categoria
    UNION ALL
    SELECT 'EW', 'EW', 'Extinct in the Wild', 'Extinto na Natureza', 'EXTINTO NA NATUREZA'
    UNION ALL
    SELECT 'CR', 'CR', 'Critically Endangered', 'Criticamente Ameaçado', 'AMEAÇADO'
    UNION ALL
    SELECT 'CR_PEW', 'CR (PEW)', 'Possibly Extinct in the Wild', 'Possivelmente Extinto na Natureza', 'AMEAÇADO'
    UNION ALL
    SELECT 'CR_PE', 'CR (PE)', 'Possibly Extinct', 'Possivelmente Extinto', 'AMEAÇADO'
    UNION ALL
    SELECT 'EN', 'EN', 'Endangered', 'Em Perigo', 'AMEAÇADO'
    UNION ALL
    SELECT 'VU', 'VU', 'Vulnerable', 'Vulnerável', 'AMEAÇADO'
    UNION ALL
    SELECT 'NT', 'NT', 'Near Threatened', 'Quase Ameaçado', 'QUASE AMEAÇADO'
    UNION ALL
    SELECT 'LC', 'LC', 'Least Concern', 'Pouco Preocupante', 'POUCO PREOCUPANTE'
    UNION ALL
    SELECT 'DD', 'DD', 'Data Deficient', 'Dados Insuficientes', 'NÃO ESPECIFICADO'
    UNION ALL
    SELECT 'NULL', NULL, 'Not Specified', 'Não Especificado', 'NÃO ESPECIFICADO'
)
SELECT * FROM tbl_base
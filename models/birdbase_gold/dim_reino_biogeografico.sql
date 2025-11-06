-- dbt run -select dim_reino_biogeografico
{{
  config(
	materialized='table',
	unique_key='sgk_reino_biogeografico',
	tags=['birdbase', 'dim']
  )
}}

WITH tbl_base AS (
    SELECT 'A' AS sgk_reino_biogeografico, 'A' AS tp_reino_biogeografico, 'Australiano' AS nm_portugues
    UNION ALL
    SELECT 'C', 'C', 'Cosmopolita'
    UNION ALL
    SELECT 'E', 'E', 'Hemisfério Oriental'
    UNION ALL
    SELECT 'F', 'F',  'Afrotropical'
    UNION ALL
    SELECT 'I', 'I', 'Indomalaio'
    UNION ALL
    SELECT 'L', 'L', 'Neotropical'
    UNION ALL
    SELECT 'M', 'M', 'Madagascar e Ilhas'
    UNION ALL
    SELECT 'N', 'N', 'Neártico'
    UNION ALL
    SELECT 'O', 'O', 'Oceania'
    UNION ALL
    SELECT 'P', 'P', 'Paleártico'
    UNION ALL
    SELECT 'S', 'S', 'Polo Sul'
    UNION ALL
    SELECT 'W', 'W', 'Wallacea'
    UNION ALL
    SELECT 'Z', 'Z', 'Nova Zelândia e Ilhas'
)
SELECT * FROM tbl_base

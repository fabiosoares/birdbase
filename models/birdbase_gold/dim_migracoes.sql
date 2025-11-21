-- dbt run -select dim_migracoes
{{
  config(
	materialized='table',
	unique_key='sgk_migracao',
	tags=['birdbase', 'dim']
  )
}}

WITH tbl_base AS (
    SELECT '1' AS sgk_migracao, 0 AS nr_migracao, 'NAO' AS tp_migracao, 'Não migrante' AS ds_migracao,
    UNION ALL
    SELECT '2' AS sgk_migracao, 1 AS nr_migracao, 'SIM' AS tp_migracao, 'Migrante' AS ds_migracao,
    UNION ALL
    SELECT '3' AS sgk_migracao, 2 AS nr_migracao, 'PARCIAL' AS tp_migracao, 'Migrante parcial' AS ds_migracao
)
SELECT * FROM tbl_base
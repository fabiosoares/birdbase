-- dbt run -select dim_voos
{{
  config(
	materialized='table',
	unique_key='sgk_voo',
	tags=['birdbase', 'dim']
  )
}}

WITH tbl_base AS (
    SELECT '1' AS sgk_voo, 'SIM' AS tp_voo, 'VOA' AS ds_voo,
    UNION ALL
    SELECT '2' AS sgk_voo, 'NAO' AS tp_voo, 'NÃO VOA' AS ds_voo,
    UNION ALL
    SELECT '3' AS sgk_voo, 'PARCIAL' AS tp_voo, 'VOO PARCIAL/SUBESPÉCIES NÃO VOADORAS' AS ds_voo
)
SELECT * FROM tbl_base

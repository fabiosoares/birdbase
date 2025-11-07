-- dbt run -select dim_faixa_latitudinal
{{
  config(
	materialized='table',
	unique_key='sgk_faixa_latitudinal',
	tags=['birdbase', 'dim']
  )
}}

WITH tbl_base AS (
    SELECT 
    1 AS id_faixa_latitudinal, 
    'Tropical' AS tp_faixa_latitudinal
    UNION ALL SELECT 
        2, 'Tropical-Temperado'
    UNION ALL SELECT 
        3, 'Temperado'
    UNION ALL SELECT 
        4, 'Temperado-Polar'
    UNION ALL SELECT 
        5, 'Polar'

)
SELECT * FROM tbl_base

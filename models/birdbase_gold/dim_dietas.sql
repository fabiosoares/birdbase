-- dbt run -select dim_dietas
{{
  config(
	materialized='table',
	unique_key='sgk_dieta',
	tags=['birdbase', 'dim']
  )
}}

WITH tbl_base AS (
    SELECT 'Herbivore' AS sgk_dieta, 'Herbivore' AS tp_dieta_ingles, 'Herbívoro' AS tp_dieta_portugues
    UNION ALL
    SELECT 'Plant', 'Plant', 'Plantas'
    UNION ALL
    SELECT 'Invertebrate', 'Invertebrate', 'Invertebrados'
    UNION ALL
    SELECT 'Fruit', 'Fruit', 'Frutas'
    UNION ALL
    SELECT 'Omnivore', 'Omnivore', 'Onívoro'
    UNION ALL
    SELECT 'Seed', 'Seed', 'Sementes'
    UNION ALL
    SELECT 'Fish', 'Fish', 'Peixes'
    UNION ALL
    SELECT 'Nectar', 'Nectar', 'Néctar'
    UNION ALL
    SELECT 'Carnivore', 'Carnivore', 'Carnívoro'
    UNION ALL
    SELECT 'Vertebrate', 'Vertebrate', 'Vertebrados'
    UNION ALL
    SELECT 'No Information', 'No Information', 'Sem Informação'
    UNION ALL
    SELECT 'Ovivore', 'Ovivore', 'Ovívoro'
    UNION ALL
    SELECT 'Scavenger', 'Scavenger', 'Necrófago'
    UNION ALL
    SELECT 'Beeswax', 'Beeswax', 'Cera de Abelha'
)
SELECT * FROM tbl_base

-- dbt run -select dim_habitats
{{
  config(
	materialized='table',
	unique_key='sgk_habitat',
	tags=['birdbase', 'dim']
  )
}}

WITH tbl_base AS (
    SELECT 
        'Savanna'     AS sgk_habitat, 
        'Savanna'     AS tp_habitat_ingles, 
        'Savana'      AS tp_habitat_portugues,
        'SV'          AS sg_habitat,
        'Savana (inclui planícies áridas, pastagens arborizadas, pampas, campos)' AS ds_habitat
    UNION ALL SELECT 
        'Plains',     'Plains',     'Planícies',
        'PL',         'Planícies (inclui áreas secas e abertas, semi-deserto, estepe, tundra)'
    UNION ALL SELECT 
        'Forest',     'Forest',     'Floresta',
        'F',          'Floresta (inclui floresta secundária, pântano, taiga, etc.)'
    UNION ALL SELECT 
        'Grassland',  'Grassland',  'Pastagem',
        'G',          'Pastagens (inclui tundra, estepe, páramo, etc.)'
    UNION ALL SELECT 
        'Woodland',   'Woodland',   'Bosque',
        'WD',         'Bosque (inclui savana arborizada, floresta decídua/seca, etc.)'
    UNION ALL SELECT 
        'Shrub',      'Shrub',      'Arbustivo',
        'SH',         'Arbustos (inclui matagal, cerrado, caatinga, etc.)'
    UNION ALL SELECT 
        'Wetland',    'Wetland',    'Área Úmida',
        'W',          'Zonas Úmidas (inclui lagos, pântanos, juncais)'
    UNION ALL SELECT 
        'Coastal',    'Coastal',    'Litorâneo',
        'C',          'Costa Marítima (inclui mangue, estuário, baías, dunas costeiras)'
    UNION ALL SELECT 
        'Riparian',   'Riparian',   'Ciliar (Margens de Rios)',
        'RV',         'Ripária (inclui floresta de galeria, riachos, água corrente)'
    UNION ALL SELECT 
        'Sea',        'Sea',        'Marinho',
        'SE',         'Mar Aberto (pelágico)'
    UNION ALL SELECT 
        'Rocky',      'Rocky',      'Rochoso',
        'R',          'Áreas Rochosas (inclui falésias, afloramentos, inselbergs)'
    UNION ALL SELECT 
        'Desert',     'Desert',     'Deserto',
        'D',          'Deserto (inclui dunas de areia não costeiras)'
    UNION ALL SELECT 
        'Artificial', 'Artificial', 'Artificial',
        'A',          'Artificial (inclui áreas agrícolas, plantações, suburbanas, pedreiras)'
    UNION ALL SELECT 
        'Bamboo',     'Bamboo',     'Bambu',
        'BM',         'Bambu'

)
SELECT * FROM tbl_base

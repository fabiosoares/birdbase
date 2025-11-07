-- dbt run -select dim_ordens
{{
  config(
	materialized='table',
	unique_key='sgk_ordem',
	tags=['birdbase', 'dim']
  )
}}

WITH tbl_base AS (
    SELECT 
    'Struthioniformes' AS sgk_ordem, 
    'Struthioniformes' AS tp_ordem_latin, 
    'Avestruzes' AS ds_ordem
    UNION ALL SELECT 
        'Rheiformes', 'Rheiformes', 'Emas'
    UNION ALL SELECT 
        'Apterygiformes', 'Apterygiformes', 'Kiwis'
    UNION ALL SELECT 
        'Casuariiformes', 'Casuariiformes', 'Casuares e emas-australianas (emus)'
    UNION ALL SELECT 
        'Tinamiformes', 'Tinamiformes', 'Inhambus ou tinamús'
    UNION ALL SELECT 
        'Anseriformes', 'Anseriformes', 'Patos, gansos e cisnes'
    UNION ALL SELECT 
        'Galliformes', 'Galliformes', 'Galinhas, perus, faisões, codornas'
    UNION ALL SELECT 
        'Caprimulgiformes', 'Caprimulgiformes', 'Bacuraus, curiangos e afins'
    UNION ALL SELECT 
        'Musophagiformes', 'Musophagiformes', 'Turacos'
    UNION ALL SELECT 
        'Otidiformes', 'Otidiformes', 'Abetardas'
    UNION ALL SELECT 
        'Cuculiformes', 'Cuculiformes', 'Cucos e anus'
    UNION ALL SELECT 
        'Mesitornithiformes', 'Mesitornithiformes', 'Mesitos (aves endêmicas de Madagascar)'
    UNION ALL SELECT 
        'Pterocliformes', 'Pterocliformes', 'Gangas'
    UNION ALL SELECT 
        'Columbiformes', 'Columbiformes', 'Pombos e rolas'
    UNION ALL SELECT 
        'Gruiformes', 'Gruiformes', 'Grous, saracuras e frangos-d’água'
    UNION ALL SELECT 
        'Podicipediformes', 'Podicipediformes', 'Mergulhões'
    UNION ALL SELECT 
        'Phoenicopteriformes', 'Phoenicopteriformes', 'Flamingos'
    UNION ALL SELECT 
        'Charadriiformes', 'Charadriiformes', 'Maçaricos, gaivotas e trinta-réis'
    UNION ALL SELECT 
        'Eurypygiformes', 'Eurypygiformes', 'Pavãozinho-do-paraíso e kagu'
    UNION ALL SELECT 
        'Phaethontiformes', 'Phaethontiformes', 'Rabos-de-palha'
    UNION ALL SELECT 
        'Gaviiformes', 'Gaviiformes', 'Mergulhões-do-norte (ou gansos-mergulhadores)'
    UNION ALL SELECT 
        'Sphenisciformes', 'Sphenisciformes', 'Pinguins'
    UNION ALL SELECT 
        'Procellariiformes', 'Procellariiformes', 'Pardelas, petréis e albatrozes'
    UNION ALL SELECT 
        'Ciconiiformes', 'Ciconiiformes', 'Cegonhas'
    UNION ALL SELECT 
        'Pelecaniformes', 'Pelecaniformes', 'Pelicanos, garças e biguás'
    UNION ALL SELECT 
        'Suliformes', 'Suliformes', 'Atobás, fragatas e corvos-marinhos'
    UNION ALL SELECT 
        'Opisthocomiformes', 'Opisthocomiformes', 'Cigana (hoatzin)'
    UNION ALL SELECT 
        'Cathartiformes', 'Cathartiformes', 'Urubus e condores-do-novo-mundo'
    UNION ALL SELECT 
        'Accipitriformes', 'Accipitriformes', 'Águias, gaviões e abutres'
    UNION ALL SELECT 
        'Strigiformes', 'Strigiformes', 'Corujas'
    UNION ALL SELECT 
        'Coliiformes', 'Coliiformes', 'Rolieiros-de-rabo-de-rato (aves africanas)'
    UNION ALL SELECT 
        'Leptosomiformes', 'Leptosomiformes', 'Cuco-rolinha de Madagascar'
    UNION ALL SELECT 
        'Trogoniformes', 'Trogoniformes', 'Surucuás e quetzais'
    UNION ALL SELECT 
        'Bucerotiformes', 'Bucerotiformes', 'Calaus e abubilas'
    UNION ALL SELECT 
        'Coraciiformes', 'Coraciiformes', 'Martim-pescadores, rolieiros e abelharucos'
    UNION ALL SELECT 
        'Piciformes', 'Piciformes', 'Pica-paus, tucanos e jacus'
    UNION ALL SELECT 
        'Cariamiformes', 'Cariamiformes', 'Seriema'
    UNION ALL SELECT 
        'Falconiformes', 'Falconiformes', 'Falcões e caracarás'
    UNION ALL SELECT 
        'Psittaciformes', 'Psittaciformes', 'Papagaios, araras e periquitos'
    UNION ALL SELECT 
        'Passeriformes', 'Passeriformes', 'Passarinhos em geral (pardais, canários, sabiás etc.)'

)
SELECT * FROM tbl_base

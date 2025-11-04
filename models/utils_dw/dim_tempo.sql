{{
  config(
    materialized='table',
    cluster_by=["dt_base", "sgk_tempo"],
    unique_key='dt_base',
    tags=['dim', 'full']
  )
}}

WITH year_2000_to_2100 AS (
    SELECT dt_base
FROM UNNEST(
    GENERATE_DATE_ARRAY(DATE('2000-01-01'), DATE('2100-12-31'), INTERVAL 1 DAY)
) AS dt_base
),

calendario AS (
  SELECT
    {{ dbt_utils.generate_surrogate_key(['dt_base']) }} AS sgk_tempo, 
    dt_base,
    FORMAT_DATE('%d/%m/%Y', dt_base) AS dt_formato_br,
    EXTRACT(YEAR FROM dt_base) AS nr_ano,
    LPAD(CAST(EXTRACT(QUARTER FROM dt_base) AS STRING), 2, '0') AS nr_trimestre,
    LPAD(CAST(EXTRACT(MONTH FROM dt_base) AS STRING), 2, '0') AS nr_mes,
    LPAD(CAST(EXTRACT(DAY FROM dt_base) AS STRING), 2, '0') AS nr_dia,
    CASE 
      WHEN FORMAT_DATE('%B', dt_base) = 'January' THEN 'Janeiro'
      WHEN FORMAT_DATE('%B', dt_base) = 'February' THEN 'Fevereiro'
      WHEN FORMAT_DATE('%B', dt_base) = 'March' THEN 'Março'
      WHEN FORMAT_DATE('%B', dt_base) = 'April' THEN 'Abril'
      WHEN FORMAT_DATE('%B', dt_base) = 'May' THEN 'Maio'
      WHEN FORMAT_DATE('%B', dt_base) = 'June' THEN 'Junho'
      WHEN FORMAT_DATE('%B', dt_base) = 'July' THEN 'Julho'
      WHEN FORMAT_DATE('%B', dt_base) = 'August' THEN 'Agosto'
      WHEN FORMAT_DATE('%B', dt_base) = 'September' THEN 'Setembro'
      WHEN FORMAT_DATE('%B', dt_base) = 'October' THEN 'Outubro'
      WHEN FORMAT_DATE('%B', dt_base) = 'November' THEN 'Novembro'
      WHEN FORMAT_DATE('%B', dt_base) = 'December' THEN 'Dezembro'
    END AS nm_mes,
    LPAD(CAST(EXTRACT(DAYOFWEEK FROM dt_base) AS STRING), 2, '0') AS nr_dia_semana,
    CASE 
      WHEN FORMAT_DATE('%A', dt_base) = 'Sunday' THEN 'Domingo'
      WHEN FORMAT_DATE('%A', dt_base) = 'Monday' THEN 'Segunda-feira'
      WHEN FORMAT_DATE('%A', dt_base) = 'Tuesday' THEN 'Terça-feira'
      WHEN FORMAT_DATE('%A', dt_base) = 'Wednesday' THEN 'Quarta-feira'
      WHEN FORMAT_DATE('%A', dt_base) = 'Thursday' THEN 'Quinta-feira'
      WHEN FORMAT_DATE('%A', dt_base) = 'Friday' THEN 'Sexta-feira'
      WHEN FORMAT_DATE('%A', dt_base) = 'Saturday' THEN 'Sábado'
    END AS nm_dia_semana,
    CASE
      WHEN FORMAT_DATE('%A', dt_base) not in ('Saturday', 'Sunday') THEN TRUE
      ELSE FALSE
    END AS is_dia_util,
    CONCAT(EXTRACT(YEAR FROM dt_base), 'Q', LPAD(CAST(EXTRACT(QUARTER FROM dt_base) AS STRING), 2, '0')) AS nr_ano_trimestre,
    CONCAT(EXTRACT(YEAR FROM dt_base), LPAD(CAST(EXTRACT(MONTH FROM dt_base) AS STRING), 2, '0')) AS nr_ano_mes,
    CONCAT(EXTRACT(YEAR FROM dt_base), LPAD(CAST(EXTRACT(WEEK FROM dt_base) AS STRING), 2, '0')) AS nr_ano_semana,
    LPAD(CAST(EXTRACT(WEEK FROM dt_base) AS STRING), 2, '0') AS nr_semana,
    LPAD(CAST(EXTRACT(ISOWEEK FROM dt_base) AS STRING), 2, '0') AS nr_iso_semana,
    CAST(EXTRACT(ISOYEAR FROM dt_base) AS STRING) AS nr_iso_ano,
    FIRST_VALUE(CAST(EXTRACT(QUARTER FROM dt_base) AS STRING)) OVER (PARTITION BY EXTRACT(ISOYEAR FROM dt_base), EXTRACT(ISOWEEK FROM dt_base) ORDER BY dt_base DESC) AS nr_iso_trimestre,
    DATE_TRUNC(dt_base, MONTH) AS dt_primeiro_dia_mes,
    LAST_DAY(dt_base, YEAR) AS dt_ultimo_dia_ano
  FROM 
    year_2000_to_2100),
-- Campo usado na tabela `projetoomni.bi_data_mart.calendario_dias_uteis`
ordem_dia_util AS (
  SELECT
    ROW_NUMBER() OVER (ORDER BY dt_base) AS nr_ordem_dia_util,
    dt_base
  FROM
    calendario
  WHERE
    dt_base >= '2018-01-01'
    AND is_dia_util IS TRUE
  group by 2)
SELECT
  sgk_tempo,
  calendario.dt_base,
  dt_formato_br,
  nr_ano,
  nr_mes,
  nr_dia,
  nm_mes,
  nr_dia_semana,
  nm_dia_semana,
  is_dia_util,
  nr_ordem_dia_util,
  nr_trimestre,
  nr_ano_trimestre,
  nr_ano_mes,
  nr_ano_semana,
  nr_semana,
  nr_iso_semana,
  nr_iso_ano,
  LPAD(nr_iso_trimestre, 2, '0') AS nr_iso_trimestre,
  dt_primeiro_dia_mes,
  dt_ultimo_dia_ano
FROM
  calendario
LEFT JOIN
  ordem_dia_util
ON
  calendario.dt_base = ordem_dia_util.dt_base
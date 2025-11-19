{{ config(
    unique_key='id_piloto',
    materialized='table',
    tags=['tempo', 'estatisticas']
) }}

SELECT
    pt.id_piloto,
    c.ano_corrida AS ano,
    COUNT(*) AS numero_paradas
FROM {{ ref('stg_pit_stops') }} AS pt
LEFT JOIN {{ ref('stg_corridas') }} AS c
    ON pt.id_corrida = c.id_corrida
GROUP BY pt.id_piloto, c.ano_corrida

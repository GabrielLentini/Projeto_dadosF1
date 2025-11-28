{{ config(
    unique_key='id_piloto',
    materialized='table',
    tags=['tempo', 'estatisticas']
) }}

SELECT
    ps.id_piloto,
    cor.ano_corrida AS ano,
    COUNT(*) AS numero_paradas
FROM {{ ref('stg_pit_stops') }} AS ps
LEFT JOIN {{ ref('stg_corridas') }} AS cor
    ON ps.id_corrida = cor.id_corrida
GROUP BY ps.id_piloto, cor.ano_corrida

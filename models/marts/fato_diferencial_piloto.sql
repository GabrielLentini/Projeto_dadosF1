{{ config(
    unique_key='id_diferencial_piloto',
    materialized='table',
    tags=['estatisticas']
) }}

SELECT
    {{ dbt_utils.generate_surrogate_key([
        'MAX(est.id_estatisticas)',
        'MAX(ps.id_piloto)'
    ]) }} AS id_diferencial_piloto,
    MAX(est.id_estatisticas) AS id_estatisticas,
    MAX(ps.id_piloto) AS id_piloto,
    ps.numero_paradas,
    ps.ano
FROM {{ ref('int_pit_stops') }} AS ps
LEFT JOIN {{ ref('dim_estatisticas') }} AS est
    ON ps.id_piloto = est.id_piloto
GROUP BY ps.numero_paradas, ps.ano

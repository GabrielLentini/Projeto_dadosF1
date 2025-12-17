{{ config(
    unique_key='id_pilotos',
    materialized='table',
    tags=['pilotos']
) }}

SELECT
    {{ dbt_utils.generate_surrogate_key([
        'pil.id_pilotos',
        'dp.id_piloto'
    ]) }} AS id_fato_ranking_pilotos,
    pil.id_pilotos AS id_piloto,
    dp.vitorias,
    dp.podios,
    dp.pole_positions
FROM {{ ref('int_historico_pilotos') }} AS dp
LEFT JOIN {{ ref('dim_pilotos') }} AS pil
    ON dp.id_piloto = pil.id_pilotos

{{ config(
    unique_key='id_dim_pilotos',
    materialized='table',
    tags=['pilotos']
) }}

SELECT
    {{ dbt_utils.generate_surrogate_key([
        'dim.id_dim_pilotos',
        'int_dp.id_piloto'
    ]) }} AS id_fato_ranking_pilotos,
    dim.id_dim_pilotos,
    int_dp.vitorias,
    int_dp.podios,
    int_dp.pole_positions
FROM {{ ref('int_dados_pilotos') }} AS int_dp
LEFT JOIN {{ ref('dim_pilotos') }} AS dim
    ON int_dp.id_piloto = dim.id_piloto

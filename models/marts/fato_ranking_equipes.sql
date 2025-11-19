{{ config(
    unique_key='id_fato_ranking_piloto',
    materialized='table',
    tags=['construtores']
) }}

SELECT
    {{ dbt_utils.generate_surrogate_key([
        'dim.id_dim_equipes',
        'int_de.id_equipe'
    ]) }} AS id_fato_ranking_equipe,
    dim.id_dim_equipes,
    int_de.vitorias,
    int_de.podios,
    int_de.pole_positions
FROM {{ ref('int_dados_equipes') }} AS int_de
LEFT JOIN {{ ref('dim_equipes') }} AS dim
    ON int_de.id_equipe = dim.id_equipe

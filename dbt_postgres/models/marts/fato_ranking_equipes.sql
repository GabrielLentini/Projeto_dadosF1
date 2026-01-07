{{ config(
    unique_key='id_ranking_piloto',
    materialized='table',
    tags=['construtores']
) }}

SELECT
    {{ dbt_utils.generate_surrogate_key([
        'eq.id_equipes',
        'de.id_equipe'
    ]) }} AS id_ranking_equipe,
    eq.id_equipes,
    de.vitorias,
    de.podios,
    de.pole_positions
FROM {{ ref('int_historico_equipes') }} AS de
LEFT JOIN {{ ref('dim_equipes') }} AS eq
    ON de.id_equipe = eq.id_equipe

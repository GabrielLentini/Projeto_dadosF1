{{ config(
    unique_key='id_dim_pilotos',
    materialized='table',
    tags=['construtores']
) }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['de.id_equipe']) }} AS id_dim_equipes,
    de.id_equipe,
    c.nome_equipe,
    de.pontos_totais_equipe,
    COALESCE(te.titulos, 0) AS titulos,
    de.vitorias,
    de.podios,
    de.pole_positions,
    de.largadas_top10,
    de.largadas_fora_top10,
    c.nacionalidade_equipe,
    pe.pilotos_da_equipe
FROM {{ ref('int_dados_equipes') }} AS de
LEFT JOIN {{ ref('int_titulos_equipes') }} AS te
    ON te.id_equipe = de.id_equipe
LEFT JOIN {{ ref('stg_construtores') }} AS c
    ON c.id_equipe = de.id_equipe
LEFT JOIN {{ ref('int_pilotos_equipe') }} AS pe
    ON pe.id_equipe = de.id_equipe

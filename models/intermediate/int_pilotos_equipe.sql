{{ config(
    unique_key='id_equipe',
    materialized='table',
    tags=['construtores']
) }}

SELECT
    MAX(c.id_equipe) AS id_equipe,
    JSONB_BUILD_OBJECT(
        c.nome_equipe,
        JSONB_AGG(DISTINCT JSONB_BUILD_OBJECT(
            'id_piloto', p.id_piloto,
            'nome_piloto', p.nome_piloto
        ))
    ) AS pilotos_da_equipe
FROM {{ ref('stg_construtores') }} AS c
LEFT JOIN {{ ref('stg_resultados') }} AS r
    ON r.id_equipe = c.id_equipe
LEFT JOIN {{ ref('stg_pilotos') }} AS p
    ON r.id_piloto = p.id_piloto
GROUP BY c.nome_equipe

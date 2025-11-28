{{ config(
    unique_key='id_equipe',
    materialized='table',
    tags=['construtores']
) }}

SELECT
    MAX(con.id_equipe) AS id_equipe,
    JSONB_BUILD_OBJECT(
        con.nome_equipe,
        JSONB_AGG(DISTINCT JSONB_BUILD_OBJECT(
            'id_piloto', pil.id_piloto,
            'nome_piloto', pil.nome_piloto
        ))
    ) AS pilotos_da_equipe
FROM {{ ref('stg_construtores') }} AS con
LEFT JOIN {{ ref('stg_resultados') }} AS res
    ON res.id_equipe = con.id_equipe
LEFT JOIN {{ ref('stg_pilotos') }} AS pil
    ON res.id_piloto = pil.id_piloto
GROUP BY con.nome_equipe

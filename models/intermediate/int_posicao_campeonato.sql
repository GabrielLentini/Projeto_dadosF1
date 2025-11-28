{{ config(
    unique_key='id_piloto',
    materialized='table',
    tags=['pilotos']
) }}

WITH pontos_corrida AS (
    SELECT
        res.id_piloto,
        cor.ano_corrida,
        (COALESCE(res.pontos, 0) + COALESCE(spr.pontos, 0)) AS pontos_corrida,
        ROW_NUMBER() OVER (
            PARTITION BY res.id_piloto, cor.ano_corrida
            ORDER BY (COALESCE(res.pontos, 0) + COALESCE(spr.pontos, 0)) DESC
        ) AS rn
    FROM {{ ref('stg_resultados') }} AS res
    LEFT JOIN {{ ref('stg_corridas') }} cor
        ON res.id_corrida = cor.id_corrida
    LEFT JOIN {{ ref('stg_sprint') }} spr
        ON res.id_corrida = spr.id_corrida
        AND res.id_piloto = spr.id_piloto
),

pontos_validos AS (
    SELECT
        id_piloto,
        ano_corrida,
        SUM(pontos_corrida) AS pontos_no_ano
    FROM pontos_corrida
    WHERE
        (ano_corrida <= 1990 AND rn <= 11)
        OR
        (ano_corrida > 1990)
    GROUP BY id_piloto, ano_corrida
)

SELECT
    id_piloto,
    ano_corrida AS ano,
    pontos_no_ano,
    ROW_NUMBER() OVER (
        PARTITION BY ano_corrida
        ORDER BY pontos_no_ano DESC
    ) AS colocacao_no_campeonato
FROM pontos_validos

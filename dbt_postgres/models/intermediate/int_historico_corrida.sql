{{ config(
    unique_key='id_corrida',
    materialized='table',
    tags=['resultados']
) }}

WITH pole_position AS (
    SELECT
        res.id_corrida,
        MAX(pil.nome_piloto) AS piloto_pole_position
    FROM {{ ref('stg_resultados') }} AS res
    LEFT JOIN {{ ref('stg_pilotos') }} AS pil
        ON res.id_piloto = pil.id_piloto
    WHERE res.posicao_largada = 1
    GROUP BY res.id_corrida
),

podio AS (
    SELECT
        res.id_corrida,
        MAX(CASE WHEN res.posicao = '1' THEN pil.nome_piloto END) AS primeiro_colocado,
        MAX(CASE WHEN res.posicao = '2' THEN pil.nome_piloto END) AS segundo_colocado,
        MAX(CASE WHEN res.posicao = '3' THEN pil.nome_piloto END) AS terceiro_colocado
    FROM {{ ref('stg_resultados') }} AS res
    LEFT JOIN {{ ref('stg_pilotos') }} AS pil
        ON pil.id_piloto = res.id_piloto
    GROUP BY res.id_corrida  -- Garantir uma linha por corrida
)

SELECT
    pod.id_corrida,
    pod.primeiro_colocado,
    pod.segundo_colocado,
    pod.terceiro_colocado,
    pole.piloto_pole_position
FROM podio AS pod
LEFT JOIN pole_position AS pole
    ON pod.id_corrida = pole.id_corrida

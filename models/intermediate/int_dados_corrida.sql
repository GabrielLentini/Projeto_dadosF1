{{ config(
    unique_key='id_corrida',
    materialized='table',
    tags=['resultados']
) }}

WITH pole_position AS (
    SELECT
        r.id_corrida,
        MAX(p.nome_piloto) AS piloto_pole_position
    FROM {{ ref('stg_resultados') }} AS r
    LEFT JOIN {{ ref('stg_pilotos') }} AS p
        ON r.id_piloto = p.id_piloto
    WHERE r.posicao_largada = 1
    GROUP BY r.id_corrida
),

podio AS (
    SELECT
        r.id_corrida,
        MAX(CASE WHEN r.posicao = '1' THEN p.nome_piloto END) AS primeiro_colocado,
        MAX(CASE WHEN r.posicao = '2' THEN p.nome_piloto END) AS segundo_colocado,
        MAX(CASE WHEN r.posicao = '3' THEN p.nome_piloto END) AS terceiro_colocado
    FROM {{ ref('stg_resultados') }} AS r
    LEFT JOIN {{ ref('stg_pilotos') }} AS p
        ON r.id_piloto = p.id_piloto
    GROUP BY r.id_corrida  -- Garantir uma linha por corrida
)

SELECT
    po.id_corrida,
    po.primeiro_colocado,
    po.segundo_colocado,
    po.terceiro_colocado,
    pp.piloto_pole_position
FROM podio AS po
LEFT JOIN pole_position AS pp
    ON po.id_corrida = pp.id_corrida

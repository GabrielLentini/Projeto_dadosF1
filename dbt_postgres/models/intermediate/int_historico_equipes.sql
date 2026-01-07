{{ config(
    unique_key='id_equipe',
    materialized='table',
    tags=['construtores']
) }}


SELECT
    res.id_equipe,
    SUM(COALESCE(res.pontos, 0) + COALESCE(spr.pontos, 0)) AS pontos_totais_equipe,
    COUNT(*) FILTER (WHERE res.posicao = '1') AS vitorias,
    COUNT(*) FILTER (WHERE res.posicao IN ('1', '2', '3')) AS podios,
    COUNT(*) FILTER (WHERE res.posicao_largada = '1') AS pole_positions,
    COUNT(*) FILTER (WHERE res.posicao_largada::int <= 10) AS largadas_top10,
    COUNT(*) FILTER (WHERE res.posicao_largada::int > 10) AS largadas_fora_top10
FROM {{ ref('stg_resultados') }} AS res
LEFT JOIN {{ ref('stg_sprint') }} AS spr
    ON
        spr.id_corrida = res.id_corrida
        AND spr.id_equipe = res.id_equipe
GROUP BY res.id_equipe

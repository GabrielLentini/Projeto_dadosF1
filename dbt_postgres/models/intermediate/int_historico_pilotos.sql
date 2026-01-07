{{ config(
    unique_key='id_piloto',
    materialized='table',
    tags=['pilotos']
) }}


SELECT
    res.id_piloto,
    SUM(COALESCE(res.pontos, 0) + COALESCE(spr.pontos, 0)) AS pontos_totais_carreira,
    COUNT(*) FILTER (WHERE res.posicao = '1') AS vitorias,
    COUNT(*) FILTER (WHERE res.posicao IN ('1', '2', '3')) AS podios,
    COUNT(*) FILTER (WHERE res.posicao_largada = '1') AS pole_positions,
    COUNT(*) FILTER (WHERE res.posicao_largada::int <= 10) AS largadas_top10,
    COUNT(*) FILTER (WHERE res.posicao_largada::int > 10) AS largadas_fora_top10
FROM {{ ref('stg_resultados') }} AS res
LEFT JOIN {{ ref('stg_sprint') }} AS spr
    ON
        spr.id_corrida = res.id_corrida
        AND spr.id_piloto = res.id_piloto
GROUP BY res.id_piloto

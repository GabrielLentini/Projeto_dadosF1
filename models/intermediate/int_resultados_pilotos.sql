{{ config(
    unique_key='id_piloto',
    materialized='table',
    tags=['pilotos']
) }}

-- noqa:disable=AM03, LT05, ST06
WITH cte_vitorias AS (
    SELECT
        r.id_piloto,
        SUM(COALESCE(r.pontos, 0) + COALESCE(s.pontos, 0)) AS pontos,
        COUNT(*) FILTER (WHERE r.posicao = '1') AS vitorias,
        COUNT(*) FILTER (WHERE r.posicao IN ('1', '2', '3')) AS podios,
        COUNT(*) FILTER (WHERE r.posicao_largada = '1') AS pole_positions,
        COUNT(*) FILTER (WHERE r.posicao_largada IN ('1', '2', '3', '4', '5', '6', '7', '8', '9', '10')) AS largadas_top10,
        COUNT(*) FILTER (WHERE r.posicao_largada::int > 10) AS largadas_fora_top10
    FROM {{ ref('stg_corridas') }} AS c
    LEFT JOIN {{ ref('stg_resultados') }} AS r
        ON r.id_corrida = c.id_corrida
    LEFT JOIN {{ ref('stg_sprint') }} AS s
        ON
            s.id_corrida = c.id_corrida
            AND s.id_piloto = r.id_piloto
    GROUP BY r.id_piloto
),

pontos_corrida AS (
    SELECT
        c.ano_corrida,
        r.id_piloto,
        r.id_corrida,
        (COALESCE(r.pontos, 0) + COALESCE(s.pontos, 0)) AS pontos_corrida,
        ROW_NUMBER() OVER (
            PARTITION BY c.ano_corrida, r.id_piloto
            ORDER BY (COALESCE(r.pontos, 0) + COALESCE(s.pontos, 0)) DESC
        ) AS rn
    FROM {{ ref('stg_corridas') }} AS c
    LEFT JOIN {{ ref('stg_resultados') }} AS r
        ON r.id_corrida = c.id_corrida
    LEFT JOIN {{ ref('stg_sprint') }} AS s
        ON
            s.id_corrida = c.id_corrida
            AND s.id_piloto = r.id_piloto
),

pontos_validos AS (
    SELECT
        ano_corrida,
        id_piloto,
        SUM(pontos_corrida) AS pontos_no_ano
    FROM pontos_corrida
    WHERE
        (ano_corrida <= 1990 AND rn <= 11)
        OR
        (ano_corrida > 1990)
    GROUP BY ano_corrida, id_piloto
),

cte_titulos AS (
    SELECT
        id_piloto,
        COUNT(*) AS titulos
    FROM (
        SELECT DISTINCT ON (ano_corrida)
            ano_corrida,
            id_piloto
        FROM pontos_validos
        ORDER BY ano_corrida, pontos_no_ano DESC
    ) AS sub_select
    GROUP BY id_piloto
)

SELECT
    v.id_piloto,
    CONCAT(p.primeiro_nome_piloto, ' ', p.sobrenome_piloto) AS nome_piloto,
    p.abreviacao_piloto,
    v.pontos AS pontos_totais_carreira,
    COALESCE(t.titulos, 0) AS titulos,
    v.vitorias,
    v.podios,
    v.pole_positions,
    v.largadas_top10,
    v.largadas_fora_top10,
    p.nacionalidade_piloto,
    p.data_nascimento_piloto
FROM cte_vitorias AS v
LEFT JOIN cte_titulos AS t
    ON t.id_piloto = v.id_piloto
LEFT JOIN {{ ref('stg_pilotos') }} AS p
    ON p.id_piloto = v.id_piloto
ORDER BY titulos DESC, v.vitorias DESC

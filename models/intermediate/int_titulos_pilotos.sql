{{ config(
    unique_key='id_piloto',
    materialized='table',
    tags=['pilotos']
) }}

-- noqa:disable=AM03
WITH pontos_corrida AS (
    SELECT
        c.ano_corrida,
        r.id_piloto,
        r.id_corrida,
        (COALESCE(r.pontos, 0) + COALESCE(s.pontos, 0)) AS pontos_corrida,
        ROW_NUMBER() OVER (
            PARTITION BY c.ano_corrida, r.id_piloto
            ORDER BY (COALESCE(r.pontos, 0) + COALESCE(s.pontos, 0)) DESC
        ) AS rn
    FROM {{ ref('stg_resultados') }} AS r
    LEFT JOIN {{ ref('stg_corridas') }} AS c
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
    id_piloto,
    COALESCE(titulos, 0) AS titulos
FROM cte_titulos

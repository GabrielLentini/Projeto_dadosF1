{{ config(
    unique_key='id_piloto',
    materialized='table',
    tags=['pilotos']
) }}

WITH pontos_por_piloto AS (
    SELECT
        r.id_piloto,
        c.ano_corrida,
        SUM((COALESCE(r.pontos, 0) + COALESCE(s.pontos, 0))) AS pontos_no_ano
    FROM {{ ref('stg_resultados') }} AS r
    LEFT JOIN {{ ref('stg_corridas') }} AS c
        ON r.id_corrida = c.id_corrida
    LEFT JOIN {{ ref('stg_sprint') }} AS s
        ON
            r.id_corrida = s.id_corrida
            AND r.id_piloto = s.id_piloto
    GROUP BY r.id_piloto, c.ano_corrida
)

SELECT
    id_piloto,
    ano_corrida AS ano_campeonato,
    pontos_no_ano,
    ROW_NUMBER() OVER (
        PARTITION BY ano_corrida
        ORDER BY pontos_no_ano DESC
    ) AS colocacao_no_campeonato
FROM pontos_por_piloto

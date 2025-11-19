{{ config(
    unique_key='id_dim_corridas',
    materialized='table',
    tags=['resultados']
) }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['MAX(r.id_resultado)', 'c.id_corrida']) }} AS id_dim_corridas,
    c.id_corrida,
    MAX(r.id_resultado) AS id_resultado,  -- Garantir que o id_resultado seja agregado corretamente
    MAX(c.ano_corrida) AS ano_corrida,
    MAX(c.nome_circuito) AS nome_circuito,
    MAX(c.data_corrida) AS data_corrida,
    MAX(r.tempo_conclusao_corrida) AS tempo_conclusao_corrida,
    MAX(r.voltas_concluidas) AS voltas_concluidas,
    MIN(r.tempo_volta_mais_rapida) AS tempo_volta_mais_rapida,  -- A volta mais rápida (MIN)
    MAX(dc.primeiro_colocado) AS primeiro_colocado,  -- Garantir que só um piloto seja retornado
    MAX(dc.segundo_colocado) AS segundo_colocado,
    MAX(dc.terceiro_colocado) AS terceiro_colocado,
    MAX(dc.piloto_pole_position) AS piloto_pole_position
FROM {{ ref('stg_resultados') }} AS r
LEFT JOIN {{ ref('stg_corridas') }} AS c
    ON c.id_corrida = r.id_corrida
LEFT JOIN {{ ref('int_dados_corrida') }} AS dc
    ON r.id_corrida = dc.id_corrida
GROUP BY c.id_corrida

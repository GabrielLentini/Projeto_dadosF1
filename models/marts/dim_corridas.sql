{{ config(
    unique_key='id_corridas',
    materialized='table',
    tags=['resultados']
) }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['MAX(res.id_resultado)', 'cor.id_corrida']) }} AS id_corridas,
    cor.id_corrida,
    MAX(res.id_resultado) AS id_resultado,  -- Garantir que o id_resultado seja agregado corretamente
    MAX(cor.ano_corrida) AS ano_corrida,
    MAX(cor.nome_circuito) AS nome_circuito,
    MAX(cor.data_corrida) AS data_corrida,
    MAX(res.tempo_conclusao_corrida) AS tempo_conclusao_corrida,
    MAX(res.voltas_concluidas) AS voltas_concluidas,
    MIN(res.tempo_volta_mais_rapida) AS tempo_volta_mais_rapida,  -- A volta mais rápida (MIN)
    MAX(dc.primeiro_colocado) AS primeiro_colocado,  -- Garantir que só um piloto seja retornado
    MAX(dc.segundo_colocado) AS segundo_colocado,
    MAX(dc.terceiro_colocado) AS terceiro_colocado,
    MAX(dc.piloto_pole_position) AS piloto_pole_position
FROM {{ ref('stg_resultados') }} AS res
LEFT JOIN {{ ref('stg_corridas') }} AS cor
    ON cor.id_corrida = res.id_corrida
LEFT JOIN {{ ref('int_historico_corrida') }} AS dc
    ON res.id_corrida = dc.id_corrida
GROUP BY cor.id_corrida

{{ config(
    unique_key='id_corridas',
    materialized='table',
    tags=['estatisticas', 'resultados']
) }}

SELECT
    MAX(cor.id_corridas) AS id_corrida,
    cor.ano_corrida
FROM {{ ref('int_historico_corrida') }} AS dc
LEFT JOIN {{ ref('dim_corridas') }} AS cor
    ON dc.id_corrida = cor.id_corrida
WHERE cor.nome_circuito IN ('SAO PAULO GRAND PRIX', 'BRAZILIAN GRAND PRIX')
GROUP BY cor.ano_corrida

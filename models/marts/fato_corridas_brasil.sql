{{ config(
    unique_key='id_fato_corrida_brasil',
    materialized='table',
    tags=['estatisticas', 'resultados']
) }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['MAX(dim.id_dim_corridas)']) }} AS id_fato_corrida_brasil,
    MAX(dim.id_dim_corridas) AS id_dim_corridas,
    dim.ano_corrida
FROM {{ ref('int_dados_corrida') }} AS dc
LEFT JOIN {{ ref('dim_corridas') }} AS dim
    ON dc.id_corrida = dim.id_corrida
WHERE dim.nome_circuito IN ('SAO PAULO GRAND PRIX', 'BRAZILIAN GRAND PRIX')
GROUP BY dim.ano_corrida

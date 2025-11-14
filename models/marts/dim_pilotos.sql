{{ config(
    unique_key='id_dim_pilotos',
    materialized='table',
    tags=['pilotos']
) }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['dp.id_piloto']) }} AS id_dim_pilotos,
    dp.id_piloto,
    CONCAT(p.primeiro_nome_piloto, ' ', p.sobrenome_piloto) AS nome_piloto,
    p.abreviacao_piloto,
    dp.pontos_totais_carreira,
    tp.titulos,
    dp.vitorias,
    dp.podios,
    dp.pole_positions,
    dp.largadas_top10,
    dp.largadas_fora_top10,
    p.nacionalidade_piloto,
    p.data_nascimento_piloto
FROM {{ ref('int_dados_pilotos') }} AS dp
LEFT JOIN {{ ref('int_titulos_pilotos') }} AS tp
    ON tp.id_piloto = dp.id_piloto
LEFT JOIN {{ ref('stg_pilotos') }} AS p
    ON p.id_piloto = dp.id_piloto

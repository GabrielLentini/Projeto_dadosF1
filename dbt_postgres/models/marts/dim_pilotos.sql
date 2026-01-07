{{ config(
    unique_key='id_pilotos',
    materialized='table',
    tags=['pilotos']
) }}

SELECT
    dp.id_piloto AS id_pilotos,
    CONCAT(pil.primeiro_nome_piloto, ' ', pil.sobrenome_piloto) AS nome_piloto,
    pil.abreviacao_piloto,
    dp.pontos_totais_carreira,
    COALESCE(tp.titulos, 0) AS titulos,
    dp.vitorias,
    dp.podios,
    dp.pole_positions,
    dp.largadas_top10,
    dp.largadas_fora_top10,
    pil.nacionalidade_piloto,
    pil.data_nascimento_piloto
FROM {{ ref('int_historico_pilotos') }} AS dp
LEFT JOIN {{ ref('int_titulos_pilotos') }} AS tp
    ON tp.id_piloto = dp.id_piloto
LEFT JOIN {{ ref('stg_pilotos') }} AS pil
    ON pil.id_piloto = dp.id_piloto

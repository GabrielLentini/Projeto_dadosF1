{{ config(
    unique_key='id_circuito',
    materialized='ephemeral',
    tags=['local']
) }}

SELECT 
    {{ string_field('circuitId', int_format=True) }} AS id_circuito,
    {{ replace_diacritics("name") }} AS nome_circuito,
    {{ replace_diacritics("circuitRef") }} AS nome_circuito_abreviado,
    {{ replace_diacritics("location") }} AS nome_cidade,
    {{ replace_diacritics("country") }} AS nome_pais,
    url AS wikipedia_circuito,
    lat,
    lng,
    alt
FROM {{ ref('circuits') }}

{{ config(
    unique_key='id_classificacao_construtores',
    materialized='ephemeral',
    tags=['construtores']
) }}

SELECT
    {{ string_field('constructorStandingsId', int_format=True) }} AS id_classificacao_construtores,
    {{ string_field('raceId', int_format=True) }} AS id_corrida,
    {{ string_field('constructorId', int_format=True) }} AS id_equipe,
    points AS pontos,
    "positionText" AS posicao,
    wins AS vitorias
FROM {{ ref('constructor_standings') }}

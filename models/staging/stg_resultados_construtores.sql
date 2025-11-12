{{ config(
    unique_key='id_resultado_construtores',
    materialized='ephemeral',
    tags=['construtores']
) }}

SELECT
    {{ string_field('constructorResultsId', int_format=True) }} AS id_resultado_construtores,
    {{ string_field('raceId', int_format=True) }} AS id_corrida,
    {{ string_field('constructorId', int_format=True) }} AS id_equipe,
    points AS pontos,
    status
FROM {{ ref('constructor_results') }}

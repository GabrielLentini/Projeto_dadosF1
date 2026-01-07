{{ config(
    unique_key='id_classificacao',
    materialized='ephemeral',
    tags=['tempo', 'resultados']
) }}

SELECT
    {{ string_field('qualifyId', int_format=True) }} AS id_classificacao,
    {{ string_field('raceId', int_format=True) }} AS id_corrida,
    {{ string_field('driverId', int_format=True) }} AS id_piloto,
    {{ string_field('constructorId', int_format=True) }} AS id_equipe,
    {{ string_field('number') }} AS numero_piloto,
    position AS posicao,
    {{ string_field('q1') }} AS tempo_volta_q1,
    {{ string_field('q2') }} AS tempo_volta_q2,
    {{ string_field('q3') }} AS tempo_volta_q3
FROM {{ ref('qualifying') }}

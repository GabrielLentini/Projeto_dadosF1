{{ config(
    materialized='ephemeral',
    tags=['tempo']
) }}

SELECT
    {{ string_field('raceId', int_format=True) }} AS id_corrida,
    {{ string_field('driverId', int_format=True) }} AS id_piloto,
    lap AS volta,
    position AS posicao,
    time AS tempo_volta,
    milliseconds AS milisegundos
FROM {{ ref('lap_times') }}

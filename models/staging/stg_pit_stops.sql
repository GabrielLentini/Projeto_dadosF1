{{ config(
    materialized='ephemeral',
    tags=['tempo']
) }}

SELECT
    {{ string_field('raceId', int_format=True) }} AS id_corrida,
    {{ string_field('driverId', int_format=True) }} AS id_piloto,
    stop AS parada_boxes,
    lap AS volta,
    duration AS tempo_parada_boxes,    
    milliseconds AS milisegundos,
    time
FROM {{ ref('pit_stops') }}
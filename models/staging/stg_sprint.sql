{{ config(
    unique_key='id_resultado',
    materialized='ephemeral',
    tags=['resultados']
) }}

SELECT
    {{ string_field('resultId', int_format=True) }} AS id_resultado,
    {{ string_field('raceId', int_format=True) }} AS id_corrida,
    {{ string_field('driverId', int_format=True) }} AS id_piloto,
    {{ string_field('constructorId', int_format=True) }} AS id_equipe,
    {{ string_field('statusId', int_format=True) }} AS id_status,
    REPLACE({{ string_field('number') }}, '\N', '(N/A)') AS numero_piloto,
    grid AS posicao_largada,
    "positionText" AS posicao,
    points AS pontos,
    laps AS voltas_concluidas,
    REPLACE(time, '\N', '(N/A)') AS tempo_conclusao_corrida,
    REPLACE("fastestLap", '\N', '(N/A)') AS volta_mais_rapida_piloto,
    REPLACE("fastestLapTime", '\N', '(N/A)') AS tempo_volta_mais_rapida,
    "positionOrder",
    milliseconds
FROM {{ ref('sprint_results') }}

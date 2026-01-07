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
    {{ string_field('number') }} AS numero_piloto,
    grid AS posicao_largada,
    "positionText" AS posicao,
    points AS pontos,
    laps AS voltas_concluidas,
    REPLACE(time, '\N', '(N/A)') AS tempo_conclusao_corrida,
    REPLACE("fastestLap", '\N', '(N/A)') AS volta_mais_rapida_piloto,
    REPLACE(rank, '\N', '(N/A)') AS posicao_rank_voltas_mais_rapida,
    REPLACE("fastestLapTime", '\N', '(N/A)') AS tempo_volta_mais_rapida,
    REPLACE("fastestLapSpeed", '\N', '(N/A)') AS velocidade_media_volta_mais_rapida,
    "positionOrder"
FROM {{ ref('results') }}

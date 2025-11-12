{{ config(
    unique_key='id_classificacao_pilotos',
    materialized='ephemeral',
    tags=['pilotos']
) }}

SELECT
    {{ string_field('driverStandingsId', int_format=True) }} AS id_classificacao_pilotos,
    {{ string_field('raceId', int_format=True) }} AS id_corrida,
    {{ string_field('driverId', int_format=True) }} AS id_piloto,
    points AS pontos,
    position AS posicao_int,
    "positionText" AS posicao,
    wins AS vitorias
FROM {{ ref('driver_standings') }}

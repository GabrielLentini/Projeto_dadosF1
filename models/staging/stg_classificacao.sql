{{ config(
    unique_key='id_classificacao',
    materialized='ephemeral',
    tags=['tempo']
) }}

SELECT
    {{ string_field('qualifyId', int_format=True) }} AS id_classificacao,
    {{ string_field('raceId', int_format=True) }} AS id_corrida,
    {{ string_field('driverId', int_format=True) }} AS id_piloto,
    {{ string_field('constructorId', int_format=True) }} AS id_equipe,
    REPLACE({{ string_field('number') }}, '\N', '(N/A)') AS numero_piloto,
    position AS posicao,
    REPLACE(q1, '\N', '(N/A)') AS tempo_volta_q1,
    REPLACE(q2, '\N', '(N/A)') AS tempo_volta_q2,
    REPLACE(q3, '\N', '(N/A)') AS tempo_volta_q3
FROM {{ ref('qualifying') }}

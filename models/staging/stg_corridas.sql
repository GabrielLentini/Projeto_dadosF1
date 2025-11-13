{{ config(
    unique_key='id_corrida',
    materialized='ephemeral',
    tags=['resultados']
) }}

SELECT
    {{ string_field('raceId', int_format=True) }} AS id_corrida,
    year AS ano_corrida,
    round AS numero_corrida,
    {{ replace_diacritics("name") }} AS nome_circuito,
    date AS data_corrida,
    time AS horario_corrida,
    url AS wikipedia_corrida,
    REPLACE(fp1_date, '\N', '0001-01-01') AS data_treino_livre_um,
    REPLACE(fp2_date, '\N', '0001-01-01') AS data_treino_livre_dois,
    REPLACE(fp3_date, '\N', '0001-01-01') AS data_treino_livre_tres,
    {{ string_field('fp1_time') }} AS horario_treino_livre_um,
    {{ string_field('fp2_time') }} AS horario_treino_livre_dois,
    {{ string_field('fp3_time') }} AS horario_treino_livre_tres
FROM {{ ref('races') }}

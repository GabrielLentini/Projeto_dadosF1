{{ config(
    unique_key='id_piloto',
    materialized='ephemeral',
    tags=['pilotos']
) }}

SELECT
    {{ string_field('driverId', int_format=True) }} AS id_piloto,
    REPLACE({{ string_field('number') }}, '\N', '(N/A)') AS numero_piloto,
    {{ replace_diacritics("code") }} AS abreviacao_piloto,
    {{ replace_diacritics("forename") }} AS primeiro_nome_piloto,
    {{ replace_diacritics("surname") }} AS sobrenome_piloto,
    dob AS data_nascimento_piloto,
    {{ replace_diacritics("nationality") }} AS nacionalidade_equipe,
    url AS wikipedia_piloto,
    "driverRef"
FROM {{ ref('drivers') }}
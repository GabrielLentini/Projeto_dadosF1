{{ config(
    unique_key='id_equipe',
    materialized='ephemeral',
    tags=['construtores']
) }}

SELECT
    {{ string_field('constructorId', int_format=True) }} AS id_equipe,
    {{ replace_diacritics("name") }} AS nome_equipe,
    {{ replace_diacritics("nationality") }} AS nacionalidade_equipe,
    url AS wikipedia_equipe,
    "constructorRef"
FROM {{ ref('constructors') }}

{{ config(
    unique_key='id_status',
    materialized='ephemeral',
    tags=['status']
) }}

SELECT
    {{ string_field('statusId', int_format=True) }} AS id_status,
    {{ replace_diacritics('status') }} AS status
FROM {{ ref('status') }}

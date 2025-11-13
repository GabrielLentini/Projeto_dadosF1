{%- macro string_field(field, cast_type=dbt.type_string(), case_null='(N/A)', uppercase=True, lowercase=False, int_format=False, type_column=False) -%}

{% if not type_column %}
    {% set field = '"' ~ field ~ '"' %}
{% endif %}

{% if int_format %}
    {% set field = "CASE WHEN CAST(" ~ field ~ " AS TEXT) ~ '^[0-9]+(\\.[0-9]+)?$' THEN CAST(" ~ field ~ " AS NUMERIC(28, 0)) ELSE NULL END" %}
    coalesce(
        nullif(nullif(nullif(nullif(nullif(CAST(REGEXP_REPLACE(split_part(trim(CAST({{ field }} AS TEXT)), '.', 1), '^0*', '') AS TEXT), ''), 'NULL'), 'NONE'), 'NAN'), '\N'),
        '{{ case_null }}'
    )
{% else %}
    {% set field = "CAST(" ~ field ~ " AS TEXT)" %}
    {% set field = "CASE WHEN " ~ field ~ " IN ('nan','(N/A)','None') THEN NULL ELSE " ~ field ~ " END" %}
    {% if uppercase %}
        coalesce(
            nullif(nullif(nullif(nullif(nullif(upper(trim({{ field }})), ''), 'NULL'), 'NONE'), 'NAN'), '\N'),
            '{{ case_null }}'
        )
    {% elif lowercase %}
        coalesce(
            nullif(nullif(nullif(nullif(nullif(lower(trim({{ field }})), ''), 'NULL'), 'NONE'), 'NAN'), '\N'),
            '{{ case_null }}'
        )
    {% else %}
        coalesce(
            nullif(nullif(nullif(nullif(nullif(trim({{ field }}), ''), 'NULL'), 'None'), 'Nan'), '\N'),
            '{{ case_null }}'
        )
    {% endif %}
{% endif %}
{%- endmacro -%}

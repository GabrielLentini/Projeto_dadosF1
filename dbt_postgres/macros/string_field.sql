{%- macro string_field(field, cast_type=dbt.type_string(), case_null='(N/A)', uppercase=True, lowercase=False, int_format=False, type_column=False) -%}

    -- A macro string_field é utilizada para padronização e limpeza de dados, mantendo como (N/A)
    -- os casos em que temos valor nulo ou vazio, assim como deixando escritas todas em maísculo
    -- e convertendo tipos númericos para string. 

    ------------------------------------------------------------------------------
    --    Caso o campo NÃO seja uma coluna literal (type_column=False),
    --    ele é convertido para string entre aspas para evitar erros de parse.
    --    Exemplo: field=nome → "nome"
    ------------------------------------------------------------------------------
    {% if not type_column %}
        {% set field = '"' ~ field ~ '"' %}
    {% endif %}

    ------------------------------------------------------------------------------
    --    BLOCO PARA FORMATAÇÃO NUMÉRICA (int_format=True)
    --    - Verifica se o campo contém apenas números (inteiros ou decimais)
    --    - Converte para NUMERIC(28,0)
    --    - Remove zeros à esquerda
    --    - Aplica tratamento de nulos e retorna case_null caso o valor seja inválido
    ------------------------------------------------------------------------------
    {% if int_format %}
        {% set field = "CASE WHEN CAST(" ~ field ~ " AS TEXT) ~ '^[0-9]+(\\.[0-9]+)?$' THEN CAST(" ~ field ~ " AS NUMERIC(28, 0)) ELSE NULL END" %}
        coalesce(
            nullif(nullif(nullif(nullif(nullif(CAST(REGEXP_REPLACE(split_part(trim(CAST({{ field }} AS TEXT)), '.', 1), '^0*', '') AS TEXT), ''), 'NULL'), 'NONE'), 'NAN'), '\N'),
            '{{ case_null }}'
        )

    ------------------------------------------------------------------------------
    --    BLOCO PARA FORMATAÇÃO PADRÃO (strings)
    --    - Sempre CAST para texto
    --    - Trata valores como 'nan', 'None', '(N/A)' como NULL
    --    - Permite converter resultado para UPPERCASE ou lowercase
    --    - Faz trim e limpeza completa
    ------------------------------------------------------------------------------
    {% else %}
        {% set field = "CAST(" ~ field ~ " AS TEXT)" %}
        {% set field = "CASE WHEN " ~ field ~ " IN ('nan','(N/A)','None') THEN NULL ELSE " ~ field ~ " END" %}

        {% if uppercase %}
            --------------------------------------------------------------
            --    upper case + trim + múltiplos nullif
            --------------------------------------------------------------
            coalesce(
                nullif(nullif(nullif(nullif(nullif(upper(trim({{ field }})), ''), 'NULL'), 'NONE'), 'NAN'), '\N'),
                '{{ case_null }}'
            )

        {% elif lowercase %}
            --------------------------------------------------------------
            --    lower case + trim + múltiplos nullif
            --------------------------------------------------------------
            coalesce(
                nullif(nullif(nullif(nullif(nullif(lower(trim({{ field }})), ''), 'NULL'), 'NONE'), 'NAN'), '\N'),
                '{{ case_null }}'
            )

        {% else %}
            --------------------------------------------------------------
            --    formatação neutra (sem upper/lower)
            --------------------------------------------------------------
            coalesce(
                nullif(nullif(nullif(nullif(nullif(trim({{ field }}), ''), 'NULL'), 'None'), 'Nan'), '\N'),
                '{{ case_null }}'
            )
        {% endif %}
    {% endif %}
{%- endmacro -%}

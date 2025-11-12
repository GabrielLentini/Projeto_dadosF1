{%- macro replace_diacritics(field) -%}
    -- Substitui um amplo conjunto de caracteres acentuados individualmente

TRANSLATE(
    {{ string_field(field) }},
    'ÁÀÃÂÄáàãâäÉÈÊËéèêëÍÌÎÏíìîïÓÒÕÔÖóòõôöÚÙÛÜúùûüÇç',
    'AAAAAaaaaaEEEEeeeeIIIIiiiiOOOOOoooooUUUUuuuuCc'
) 

{%- endmacro -%}

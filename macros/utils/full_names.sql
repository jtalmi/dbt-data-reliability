{% macro full_table_name() -%}
    upper(concat(database_name, '.', schema_name, '.', table_name))
{%- endmacro %}

{% macro full_schema_name() -%}
    upper(concat(database_name, '.', schema_name))
{%- endmacro %}

{% macro full_column_name() -%}
    upper(concat(database_name, '.', schema_name, '.', table_name, '.', column_name))
{%- endmacro %}

{% macro full_name_to_db() -%}
    trim(split(full_table_name,'.')[0],'"') as database_name
{%- endmacro %}

{% macro full_name_to_schema() -%}
    trim(split(full_table_name,'.')[1],'"') as schema_name
{%- endmacro %}

{% macro full_name_to_table() -%}
    trim(split(full_table_name,'.')[2],'"') as table_name
{%- endmacro %}
{% macro get_columns_from_information_schema(database_name, schema_name) %}
    {{ return(adapter.dispatch('get_columns_from_information_schema')(database_name, schema_name)) }}
{% endmacro %}

{% macro snowflake__get_columns_from_information_schema(database_name, schema_name) %}

    select
        upper(concat(table_catalog,'.',table_schema,'.',table_name)) as full_table_name,
        upper(table_catalog) as database_name,
        upper(table_schema) as schema_name,
        upper(table_name) as table_name,
        upper(column_name) as column_name,
        data_type
    from  {{ database_name }}.information_schema.columns
    where table_schema = '{{ schema_name }}'

{% endmacro %}

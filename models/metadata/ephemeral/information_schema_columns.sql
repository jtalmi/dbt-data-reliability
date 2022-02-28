{{
  config(
    materialized='ephemeral'
  )
}}

{% set configured_schemas = get_configured_schemas() %}

with filtered_information_schema_columns as (

    {% if configured_schemas != [] %}
        {{ query_different_schemas(get_columns_from_information_schema, configured_schemas) }}
    {% else %}
        {{ empty_table([('full_table_name', 'string'), ('database_name', 'string'), ('schema_name', 'string'), ('table_name', 'string'), ('column_name', 'string'), ('data_type', 'string')]) }}
    {% endif %}

)

select *
from filtered_information_schema_columns
where full_table_name is not null
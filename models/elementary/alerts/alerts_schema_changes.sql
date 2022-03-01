{{
  config(
    materialized = 'incremental',
    unique_key = 'alert_id'
  )
}}

with table_changes as (

    select * from {{ ref('table_changes') }}

),

column_changes as (

    select * from {{ ref('column_changes') }}

),

table_changes_alerts as (

    select
        change_id as alert_id,
        detected_at,
        database_name,
        schema_name,
        table_name,
        NULL as column_name,
        'schema_change' as alert_type,
        change as sub_type,
        change_description as alert_description
    from table_changes

),

column_changes_alerts as (

    select
        change_id as alert_id,
        detected_at,
        database_name,
        schema_name,
        table_name,
        column_name,
        'schema_change' as alert_type,
        change as sub_type,
        change_description as alert_description
    from column_changes

),

all_alerts as (

    select * from table_changes_alerts
    union all
    select * from column_changes_alerts
),

filtered_alerts as (

    select *
    from all_alerts
    where
        {{ elementary.full_table_name() }} in {{ elementary.tables_for_alert_on_schema_changes() }}
        or {{ elementary.full_schema_name() }} in {{ elementary.schemas_for_alert_on_schema_changes() }}

)

select * from filtered_alerts
{% if is_incremental() %}
    {% set row_count = elementary.get_row_count(this) %}
    {% if row_count > 0 %}
        where detected_at > (select max(detected_at) from {{ this }})
    {%- endif %}
{%- endif %}

{{ config(
    cluster_by = ["_airbyte_unique_key","_airbyte_emitted_at"],
    partition_by = {"field": "_airbyte_emitted_at", "data_type": "timestamp", "granularity": "day"},
    unique_key = "_airbyte_unique_key",
    schema = "telegram",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('messages_scd') }}
select
    _airbyte_unique_key,
    _id,
    text,
    type,
    bot_id,
    status,
    user_id,
    telegram,
    direction,
    edited_at,
    contact_id,
    created_at,
    updated_at,
    campaign_id,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_messages_hashid
from {{ ref('messages_scd') }}
-- messages from {{ source('telegram', '_airbyte_raw_messages') }}
where 1 = 1
and _airbyte_active_row = 1
{{ incremental_clause('_airbyte_emitted_at') }}


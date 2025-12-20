create view cue_full_view with (security_invoker = true) as
select
    c.id as cue_id,
    c.title as cue_title,
    c.description as cue_description,
    c.created_by as cue_created_by,
    c.created_at as cue_created_at,
    c.updated_at as cue_updated_at,
    coalesce(
        jsonb_agg(jsonb_build_object(
            'id', a.id,
            'order_index', a.order_index,
            'action_type', a.action_type,
            'semantic_instruction', a.semantic_instruction,
            'payload', a.payload,
            'created_at', a.created_at,
            'deterministic_action', jsonb_build_object(
                'description', da.description,
                'method', da.method,
                'selector', da.selector,
                'arguments', da.arguments,
                'validated', da.validated,
                'updated_at', da.updated_at
            )
        ) order by a.order_index
        ) filter (where a.id is not null),
        '[]'::jsonb
    ) as actions
from cues c
left join actions a on a.cue_id = c.id
left join deterministic_actions da on da.action_id = a.id
group by c.id;
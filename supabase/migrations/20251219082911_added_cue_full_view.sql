create extension if not exists "pg_net" with schema "extensions";

create or replace view "public"."cue_full" as  SELECT c.id AS cue_id,
    c.title AS cue_title,
    c.description AS cue_description,
    c.created_by AS cue_created_by,
    c.created_at AS cue_created_at,
    c.updated_at AS cue_updated_at,
    COALESCE(jsonb_agg(jsonb_build_object('id', a.id, 'order_index', a.order_index, 'action_type', a.action_type, 'semantic_instruction', a.semantic_instruction, 'payload', a.payload, 'created_at', a.created_at, 'deterministic_action', jsonb_build_object('description', da.description, 'method', da.method, 'selector', da.selector, 'arguments', da.arguments, 'validated', da.validated, 'updated_at', da.updated_at)) ORDER BY a.order_index) FILTER (WHERE (a.id IS NOT NULL)), '[]'::jsonb) AS actions
   FROM ((public.cues c
     LEFT JOIN public.actions a ON ((a.cue_id = c.id)))
     LEFT JOIN public.deterministic_actions da ON ((da.action_id = a.id)))
  GROUP BY c.id;




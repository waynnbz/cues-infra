-- actions.sql

-- Enum for action types
create type action_type as enum (
    'NAVIGATE',
    'TAB_SWITCH',
    'NEW_TAB',
    'CLICK',
    'INPUT_TEXT',
    'PRESS_KEY',
    'SELECT_OPTION'
);

create table actions (
    id uuid primary key default gen_random_uuid(),
    cue_id uuid not null references cues(id) on delete cascade,
    order_index int not null, -- for ordering
    action_type action_type not null,
    semantic_instruction text not null,
    payload jsonb not null, -- polymorphic payload
    created_at timestamptz not null default now()
);

-- Index to optimize queries fetching actions and ordering them
create index on actions(cue_id, order_index);

alter table actions enable row level security;

create policy "Allow cue owners to manage actions" on actions
for all
to authenticated
using (exists (
    select 1 from cues
    where cues.created_by = (select auth.uid())
    and cues.id = actions.cue_id
))
with check (exists (
    select 1 from cues
    where cues.created_by = (select auth.uid())
    and cues.id = actions.cue_id
));

-- TODO: refine this policy to restrict access to actions of public cues only
create policy "Allow anyone to read actions for public cues" on actions
for select
to anon, authenticated
using (true);
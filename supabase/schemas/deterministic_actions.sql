-- deterministic_actions.sql
create table deterministic_actions (
    action_id uuid primary key references actions(id) on delete cascade,
    description text not null,
    method text,
    selector text not null,
    arguments text[],
    validated boolean default false,
    updated_at timestamptz not null default now()
);

alter table deterministic_actions enable row level security;

create policy "Allow cue owners to manage deterministic actions" on deterministic_actions
for all
to authenticated
using (exists (
    select 1 from actions
    join cues on actions.cue_id = cues.id
    where actions.id = deterministic_actions.action_id
    and cues.created_by = (select auth.uid())
))
with check (exists (
    select 1 from actions
    join cues on actions.cue_id = cues.id
    where actions.id = deterministic_actions.action_id
    and cues.created_by = (select auth.uid())
));

-- TODO: refine this policy to restrict access to deterministic actions of public cues only
create policy "Allow anyone to read deterministic actions for public cues" on deterministic_actions
for select
to anon, authenticated
using (true);
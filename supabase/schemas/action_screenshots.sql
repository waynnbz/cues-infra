-- TODO: not sure how this works with supabase storage, need to test later
-- action_screenshots.sql
create table action_screenshots (
    id uuid primary key default gen_random_uuid(),
    action_id uuid not null references actions(id) on delete cascade,
    storage_path text not null, -- e.g., "screenshots/cue-123/action-456.png"
    created_at timestamptz not null default now()
);

alter table action_screenshots enable row level security;

create index on action_screenshots(action_id);

create policy "Allow cue owners to manage action screenshots" on action_screenshots
for all
to authenticated
using (exists (
    select 1 from actions
    join cues on actions.cue_id = cues.id
    where actions.id = action_screenshots.action_id
    and cues.created_by = (select auth.uid())
))
with check (exists (
    select 1 from actions
    join cues on actions.cue_id = cues.id
    where actions.id = action_screenshots.action_id
    and cues.created_by = (select auth.uid())
)); 

-- TODO: refine this policy to restrict access to action screenshots of public cues only
create policy "Allow anyone to read action screenshots for public cues" on action_screenshots
for select
to anon, authenticated
using (true);
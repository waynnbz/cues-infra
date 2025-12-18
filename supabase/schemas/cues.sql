-- cues.sql
create table cues (
    id uuid primary key default gen_random_uuid(),
    title text not null,
    description text,
    created_by uuid references auth.users(id),
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create index cues_created_by_created_at_idx on cues (created_by, created_at);

alter table cues enable row level security;

create policy "Allow cue owners to manage their cues" on cues
for all
to authenticated
using (created_by = (select auth.uid()))
with check (created_by = (select auth.uid()));

create policy "Allow anyone to read cues" on cues
for select
to anon, authenticated
using (true);

create policy "Allow anyone to create cues" on cues
for insert
to anon, authenticated
with check (true);

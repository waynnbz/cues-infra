-- waitlist.sql
create table waitlist (
    id bigint generated always as identity primary key,
    email text not null,
    description text,
    status text default 'pending',
    created_at timestamptz default current_timestamp,
    updated_at timestamptz default current_timestamp,
    source text,
    referral_code text,
    is_verified boolean default false,
    contact_attempts integer default 0,
    constraint waitlist_email_check check (
        email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'
    ),
    constraint waitlist_status_check check (
        status = any (array['pending', 'contacted', 'approved', 'rejected'])
    )
);

create unique index idx_waitlist_email on waitlist (lower(email));

alter table waitlist enable row level security;

create policy "Allow anyone to insert waitlist entries"
on waitlist
for insert
to anon, authenticated
with check (true);

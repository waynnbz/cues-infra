create type "public"."action_type" as enum ('NAVIGATE', 'TAB_SWITCH', 'NEW_TAB', 'CLICK', 'INPUT_TEXT', 'PRESS_KEY', 'SELECT_OPTION');


  create table "public"."action_screenshots" (
    "id" uuid not null default gen_random_uuid(),
    "action_id" uuid not null,
    "storage_path" text not null,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."action_screenshots" enable row level security;


  create table "public"."actions" (
    "id" uuid not null default gen_random_uuid(),
    "cue_id" uuid not null,
    "order_index" integer not null,
    "action_type" public.action_type not null,
    "semantic_instruction" text not null,
    "payload" jsonb not null,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."actions" enable row level security;


  create table "public"."cues" (
    "id" uuid not null default gen_random_uuid(),
    "title" text not null,
    "description" text,
    "created_by" uuid,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."cues" enable row level security;


  create table "public"."deterministic_actions" (
    "action_id" uuid not null,
    "description" text not null,
    "method" text,
    "selector" text not null,
    "arguments" text[],
    "validated" boolean default false,
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."deterministic_actions" enable row level security;


  create table "public"."waitlist" (
    "id" bigint generated always as identity not null,
    "email" text not null,
    "description" text,
    "status" text default 'pending'::text,
    "created_at" timestamp with time zone default CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone default CURRENT_TIMESTAMP,
    "source" text,
    "referral_code" text,
    "is_verified" boolean default false,
    "contact_attempts" integer default 0
      );


alter table "public"."waitlist" enable row level security;

CREATE INDEX action_screenshots_action_id_idx ON public.action_screenshots USING btree (action_id);

CREATE UNIQUE INDEX action_screenshots_pkey ON public.action_screenshots USING btree (id);

CREATE INDEX actions_cue_id_order_index_idx ON public.actions USING btree (cue_id, order_index);

CREATE UNIQUE INDEX actions_pkey ON public.actions USING btree (id);

CREATE INDEX cues_created_by_created_at_idx ON public.cues USING btree (created_by, created_at);

CREATE UNIQUE INDEX cues_pkey ON public.cues USING btree (id);

CREATE UNIQUE INDEX deterministic_actions_pkey ON public.deterministic_actions USING btree (action_id);

CREATE UNIQUE INDEX idx_waitlist_email ON public.waitlist USING btree (lower(email));

CREATE UNIQUE INDEX waitlist_pkey ON public.waitlist USING btree (id);

alter table "public"."action_screenshots" add constraint "action_screenshots_pkey" PRIMARY KEY using index "action_screenshots_pkey";

alter table "public"."actions" add constraint "actions_pkey" PRIMARY KEY using index "actions_pkey";

alter table "public"."cues" add constraint "cues_pkey" PRIMARY KEY using index "cues_pkey";

alter table "public"."deterministic_actions" add constraint "deterministic_actions_pkey" PRIMARY KEY using index "deterministic_actions_pkey";

alter table "public"."waitlist" add constraint "waitlist_pkey" PRIMARY KEY using index "waitlist_pkey";

alter table "public"."action_screenshots" add constraint "action_screenshots_action_id_fkey" FOREIGN KEY (action_id) REFERENCES public.actions(id) ON DELETE CASCADE not valid;

alter table "public"."action_screenshots" validate constraint "action_screenshots_action_id_fkey";

alter table "public"."actions" add constraint "actions_cue_id_fkey" FOREIGN KEY (cue_id) REFERENCES public.cues(id) ON DELETE CASCADE not valid;

alter table "public"."actions" validate constraint "actions_cue_id_fkey";

alter table "public"."cues" add constraint "cues_created_by_fkey" FOREIGN KEY (created_by) REFERENCES auth.users(id) not valid;

alter table "public"."cues" validate constraint "cues_created_by_fkey";

alter table "public"."deterministic_actions" add constraint "deterministic_actions_action_id_fkey" FOREIGN KEY (action_id) REFERENCES public.actions(id) ON DELETE CASCADE not valid;

alter table "public"."deterministic_actions" validate constraint "deterministic_actions_action_id_fkey";

alter table "public"."waitlist" add constraint "waitlist_email_check" CHECK ((email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'::text)) not valid;

alter table "public"."waitlist" validate constraint "waitlist_email_check";

alter table "public"."waitlist" add constraint "waitlist_status_check" CHECK ((status = ANY (ARRAY['pending'::text, 'contacted'::text, 'approved'::text, 'rejected'::text]))) not valid;

alter table "public"."waitlist" validate constraint "waitlist_status_check";

grant delete on table "public"."action_screenshots" to "anon";

grant insert on table "public"."action_screenshots" to "anon";

grant references on table "public"."action_screenshots" to "anon";

grant select on table "public"."action_screenshots" to "anon";

grant trigger on table "public"."action_screenshots" to "anon";

grant truncate on table "public"."action_screenshots" to "anon";

grant update on table "public"."action_screenshots" to "anon";

grant delete on table "public"."action_screenshots" to "authenticated";

grant insert on table "public"."action_screenshots" to "authenticated";

grant references on table "public"."action_screenshots" to "authenticated";

grant select on table "public"."action_screenshots" to "authenticated";

grant trigger on table "public"."action_screenshots" to "authenticated";

grant truncate on table "public"."action_screenshots" to "authenticated";

grant update on table "public"."action_screenshots" to "authenticated";

grant delete on table "public"."action_screenshots" to "service_role";

grant insert on table "public"."action_screenshots" to "service_role";

grant references on table "public"."action_screenshots" to "service_role";

grant select on table "public"."action_screenshots" to "service_role";

grant trigger on table "public"."action_screenshots" to "service_role";

grant truncate on table "public"."action_screenshots" to "service_role";

grant update on table "public"."action_screenshots" to "service_role";

grant delete on table "public"."actions" to "anon";

grant insert on table "public"."actions" to "anon";

grant references on table "public"."actions" to "anon";

grant select on table "public"."actions" to "anon";

grant trigger on table "public"."actions" to "anon";

grant truncate on table "public"."actions" to "anon";

grant update on table "public"."actions" to "anon";

grant delete on table "public"."actions" to "authenticated";

grant insert on table "public"."actions" to "authenticated";

grant references on table "public"."actions" to "authenticated";

grant select on table "public"."actions" to "authenticated";

grant trigger on table "public"."actions" to "authenticated";

grant truncate on table "public"."actions" to "authenticated";

grant update on table "public"."actions" to "authenticated";

grant delete on table "public"."actions" to "service_role";

grant insert on table "public"."actions" to "service_role";

grant references on table "public"."actions" to "service_role";

grant select on table "public"."actions" to "service_role";

grant trigger on table "public"."actions" to "service_role";

grant truncate on table "public"."actions" to "service_role";

grant update on table "public"."actions" to "service_role";

grant delete on table "public"."cues" to "anon";

grant insert on table "public"."cues" to "anon";

grant references on table "public"."cues" to "anon";

grant select on table "public"."cues" to "anon";

grant trigger on table "public"."cues" to "anon";

grant truncate on table "public"."cues" to "anon";

grant update on table "public"."cues" to "anon";

grant delete on table "public"."cues" to "authenticated";

grant insert on table "public"."cues" to "authenticated";

grant references on table "public"."cues" to "authenticated";

grant select on table "public"."cues" to "authenticated";

grant trigger on table "public"."cues" to "authenticated";

grant truncate on table "public"."cues" to "authenticated";

grant update on table "public"."cues" to "authenticated";

grant delete on table "public"."cues" to "service_role";

grant insert on table "public"."cues" to "service_role";

grant references on table "public"."cues" to "service_role";

grant select on table "public"."cues" to "service_role";

grant trigger on table "public"."cues" to "service_role";

grant truncate on table "public"."cues" to "service_role";

grant update on table "public"."cues" to "service_role";

grant delete on table "public"."deterministic_actions" to "anon";

grant insert on table "public"."deterministic_actions" to "anon";

grant references on table "public"."deterministic_actions" to "anon";

grant select on table "public"."deterministic_actions" to "anon";

grant trigger on table "public"."deterministic_actions" to "anon";

grant truncate on table "public"."deterministic_actions" to "anon";

grant update on table "public"."deterministic_actions" to "anon";

grant delete on table "public"."deterministic_actions" to "authenticated";

grant insert on table "public"."deterministic_actions" to "authenticated";

grant references on table "public"."deterministic_actions" to "authenticated";

grant select on table "public"."deterministic_actions" to "authenticated";

grant trigger on table "public"."deterministic_actions" to "authenticated";

grant truncate on table "public"."deterministic_actions" to "authenticated";

grant update on table "public"."deterministic_actions" to "authenticated";

grant delete on table "public"."deterministic_actions" to "service_role";

grant insert on table "public"."deterministic_actions" to "service_role";

grant references on table "public"."deterministic_actions" to "service_role";

grant select on table "public"."deterministic_actions" to "service_role";

grant trigger on table "public"."deterministic_actions" to "service_role";

grant truncate on table "public"."deterministic_actions" to "service_role";

grant update on table "public"."deterministic_actions" to "service_role";

grant delete on table "public"."waitlist" to "anon";

grant insert on table "public"."waitlist" to "anon";

grant references on table "public"."waitlist" to "anon";

grant select on table "public"."waitlist" to "anon";

grant trigger on table "public"."waitlist" to "anon";

grant truncate on table "public"."waitlist" to "anon";

grant update on table "public"."waitlist" to "anon";

grant delete on table "public"."waitlist" to "authenticated";

grant insert on table "public"."waitlist" to "authenticated";

grant references on table "public"."waitlist" to "authenticated";

grant select on table "public"."waitlist" to "authenticated";

grant trigger on table "public"."waitlist" to "authenticated";

grant truncate on table "public"."waitlist" to "authenticated";

grant update on table "public"."waitlist" to "authenticated";

grant delete on table "public"."waitlist" to "service_role";

grant insert on table "public"."waitlist" to "service_role";

grant references on table "public"."waitlist" to "service_role";

grant select on table "public"."waitlist" to "service_role";

grant trigger on table "public"."waitlist" to "service_role";

grant truncate on table "public"."waitlist" to "service_role";

grant update on table "public"."waitlist" to "service_role";


  create policy "Allow anyone to read action screenshots for public cues"
  on "public"."action_screenshots"
  as permissive
  for select
  to anon, authenticated
using (true);



  create policy "Allow cue owners to manage action screenshots"
  on "public"."action_screenshots"
  as permissive
  for all
  to authenticated
using ((EXISTS ( SELECT 1
   FROM (public.actions
     JOIN public.cues ON ((actions.cue_id = cues.id)))
  WHERE ((actions.id = action_screenshots.action_id) AND (cues.created_by = ( SELECT auth.uid() AS uid))))))
with check ((EXISTS ( SELECT 1
   FROM (public.actions
     JOIN public.cues ON ((actions.cue_id = cues.id)))
  WHERE ((actions.id = action_screenshots.action_id) AND (cues.created_by = ( SELECT auth.uid() AS uid))))));



  create policy "Allow anyone to read actions for public cues"
  on "public"."actions"
  as permissive
  for select
  to anon, authenticated
using (true);



  create policy "Allow cue owners to manage actions"
  on "public"."actions"
  as permissive
  for all
  to authenticated
using ((EXISTS ( SELECT 1
   FROM public.cues
  WHERE ((cues.created_by = ( SELECT auth.uid() AS uid)) AND (cues.id = actions.cue_id)))))
with check ((EXISTS ( SELECT 1
   FROM public.cues
  WHERE ((cues.created_by = ( SELECT auth.uid() AS uid)) AND (cues.id = actions.cue_id)))));



  create policy "Allow anyone to create cues"
  on "public"."cues"
  as permissive
  for insert
  to anon, authenticated
with check (true);



  create policy "Allow anyone to read cues"
  on "public"."cues"
  as permissive
  for select
  to anon, authenticated
using (true);



  create policy "Allow cue owners to manage their cues"
  on "public"."cues"
  as permissive
  for all
  to authenticated
using ((created_by = ( SELECT auth.uid() AS uid)))
with check ((created_by = ( SELECT auth.uid() AS uid)));



  create policy "Allow anyone to read deterministic actions for public cues"
  on "public"."deterministic_actions"
  as permissive
  for select
  to anon, authenticated
using (true);



  create policy "Allow cue owners to manage deterministic actions"
  on "public"."deterministic_actions"
  as permissive
  for all
  to authenticated
using ((EXISTS ( SELECT 1
   FROM (public.actions
     JOIN public.cues ON ((actions.cue_id = cues.id)))
  WHERE ((actions.id = deterministic_actions.action_id) AND (cues.created_by = ( SELECT auth.uid() AS uid))))))
with check ((EXISTS ( SELECT 1
   FROM (public.actions
     JOIN public.cues ON ((actions.cue_id = cues.id)))
  WHERE ((actions.id = deterministic_actions.action_id) AND (cues.created_by = ( SELECT auth.uid() AS uid))))));



  create policy "Allow anyone to insert waitlist entries"
  on "public"."waitlist"
  as permissive
  for insert
  to anon, authenticated
with check (true);




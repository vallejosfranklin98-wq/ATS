-- NBC Field & Roster — Applicant Tracking System
-- Run this once in Supabase: Project → SQL Editor → New query → paste → Run

create table if not exists applicants (
  id text primary key,
  date_applied date,
  name text not null,
  position text,
  source text,
  phone text,
  email text,
  recruiter text,
  status text,
  remarks text,
  created_at timestamptz default now()
);

create table if not exists interviews (
  id text primary key default ('INT-' || extract(epoch from now())::bigint::text),
  candidate text not null,
  position text,
  interviewer text,
  contact text,
  date date,
  time time,
  email text,
  remarks text,
  created_at timestamptz default now()
);

create table if not exists vacancies (
  id text primary key default ('VAC-' || extract(epoch from now())::bigint::text),
  position text not null,
  count integer default 1,
  deployed integer default 0,
  mrf text,
  date_needed date,
  requested_by text,
  department text,
  mrf_status text,
  status text,
  created_at timestamptz default now()
);

create table if not exists settings (
  category text not null,       -- 'status' | 'position' | 'source'
  value text not null,
  primary key (category, value)
);

-- seed default lookup lists
insert into settings (category, value) values
  ('status','Applied'),('status','Shortlisted'),('status','Initial Interview'),
  ('status','Final Interview'),('status','Job Offer'),('status','Hired'),
  ('status','On-Hold'),('status','Pooling'),('status','Withdrawn'),
  ('position','Human Resource'),('position','Biosecurity'),('position','Inventory'),
  ('position','Farm Technician'),('position','Poultry Farm Worker'),
  ('position','Hatchery Staff'),('position','Admin'),('position','Others'),
  ('source','Facebook'),('source','Email'),('source','Walk-in'),
  ('source','Job Fair'),('source','Referral'),('source','Job Street')
on conflict do nothing;

-- Row Level Security: open read/write for now since this is an internal
-- tool behind Netlify (no public signup). Tighten later if you add auth.
alter table applicants enable row level security;
alter table interviews enable row level security;
alter table vacancies enable row level security;
alter table settings enable row level security;

create policy "allow all - applicants" on applicants for all using (true) with check (true);
create policy "allow all - interviews" on interviews for all using (true) with check (true);
create policy "allow all - vacancies" on vacancies for all using (true) with check (true);
create policy "allow all - settings" on settings for all using (true) with check (true);
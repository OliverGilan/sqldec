create schema if not exists public;

create schema if not exists extensions;
create extension if not exists "uuid-ossp"      with schema extensions;

create table if not exists public.psqldec (
  v serial primary key,
  current_migration not null text,
  changed_on timestamp not null default now()
);


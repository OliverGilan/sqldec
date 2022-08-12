create schema if not exists gooch;

create schema if not exists extensions;
create extension if not exists "uuid-ossp" with schema extensions;

create table if not exists gooch.psqldec (
  v serial primary key,
  current_migration text not null,
  changed_on timestamp not null default now()
);


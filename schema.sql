
create schema if not exists extensions;
create extension if not exists "uuid-ossp" with schema extensions;

-- Needed for SQLDEC // DO NOT DELETE
create schema if not exists sqldec;
create table if not exists sqldec.version (
  v serial primary key,
  current_migration text not null,
  changed_on timestamp not null default now()
);
-- 

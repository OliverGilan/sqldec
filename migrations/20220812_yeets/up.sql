create schema if not exists "gooch";

create sequence "gooch"."psqldec_v_seq";

alter table "public"."users" drop constraint "users_pkey";

drop index if exists "public"."users_pkey";

drop table "public"."users";

create table "gooch"."psqldec" (
    "v" integer not null default nextval('gooch.psqldec_v_seq'::regclass),
    "current_migration" text not null,
    "changed_on" timestamp without time zone not null default now()
);


alter sequence "gooch"."psqldec_v_seq" owned by "gooch"."psqldec"."v";

CREATE UNIQUE INDEX psqldec_pkey ON gooch.psqldec USING btree (v);

alter table "gooch"."psqldec" add constraint "psqldec_pkey" PRIMARY KEY using index "psqldec_pkey";



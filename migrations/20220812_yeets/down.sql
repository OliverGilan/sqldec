alter table "gooch"."psqldec" drop constraint "psqldec_pkey";

drop index if exists "gooch"."psqldec_pkey";

drop table "gooch"."psqldec";

create table "public"."users" (
    "id" text not null
);


drop sequence if exists "gooch"."psqldec_v_seq";

CREATE UNIQUE INDEX users_pkey ON public.users USING btree (id);

alter table "public"."users" add constraint "users_pkey" PRIMARY KEY using index "users_pkey";

drop schema if exists "gooch";



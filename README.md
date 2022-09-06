# SQLDec

![version badge](https://img.shields.io/static/v1?label=version&message=v0.1.0&color=blue)
![license badge](https://img.shields.io/github/license/olivergilan/sqldec)

## Summary
Whenever one works with a relational database the issue arises of how to effectively implement and track changes to the schema over time. ORM's like ActiveRecord and more recently Prisma provide tools specifically to easily manage these schema changes in the form of database migrations. The idea is to have one file that acts as a _declarative schema_ which always represents the current state of the database at any given point in time. When you want to change that schema you simply edit that declarative file and automatically generate the SQL to transform the database to bring it in line with what the new schema file. You can then apply and revert these migrations to efficiently manage the state of your database's schema. 

The drawback of tools like Prisma and ActiveRecord is they require one to write the schema file using a custom DDL which I often find to be unnecessary overhead. Whenever I try to create a schema using some new graph DDL I find myself manually trying to understand how they're converting the schema into an SQL representation.

SQLDec takes the concept of declarative schema and easy migrations and allows one to do all of it with simply SQL.

## Installation
### Prerequisites 
SQLDec requires [migra](https://github.com/djrobstep/migra) to be installed and available via the commandline.

__Building from source__

SQLDec is currently written completely in Bash. As a result you can simply clone this repository and place the source files somewhere in your PATH.

## Usage
1. Initialize SQLDec in the top level of your project directory
```bash
$ sqld --name=postgres -U oliver -W <supersecurepassword> init

$ ls
migrations/
schema.sql
```

Peek into the schema file that's generated for you
```bash
$ cat schema.sql

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
```

2. In order to not provide options on every invocation you can use a config file
```bash
echo "DATABASE=postgres\nUSERNAME=oliver" > sqldec.config
```

3. Create your first migration (notice options can be left out because of config file)
```bash
$ sqld -W <supersecurepassword> create initital_migration

$ ls migrations
20220828191336_initial_migration
$ ls migrations/20220828191336_initial_migration
down.sql
up.sql
```
If you peek at the up and down migration files you'll see that the SQL commands required to make your database reflect the schema file are generated for you. NOTE: this command simply creates the migration files but does not apply them to the database.
```bash
$ cat migrations/20220828191336_initial_migration/up.sql
create schema if not exists "extensions";
create schema if not exists "sqldec";

create extension if not exists "uuid-ossp" with schema "extensions" version '1.1';

create sequence "sqldec"."version_v_seq";
create table "sqldec"."version" (
    "v" integer not null default nextval('sqldec.version_v_seq'::regclass),
    "current_migration" text not null,
    "changed_on" timestamp without time zone not null default now()
);
alter sequence "sqldec"."version_v_seq" owned by "sqldec"."version"."v";
CREATE UNIQUE INDEX version_pkey ON sqldec.version USING btree (v);
alter table "sqldec"."version" add constraint "version_pkey" PRIMARY KEY using index "version_pkey";
```

4. Apply the migration to your database
```bash
$ sqld -W <supersecurepassword> apply
```

5. Now let's make a change to our schema and create a new migration
```bash
$ echo "create table public.users(
  id serial primary key,
  name text not null
  );" >> schema.sql

$ sqld -W <supersecurepassword> create users_table

$ cat migrations/20220828213425_users_table/up.sql
create sequence "public"."users_id_seq";
create table "public"."users" (
    "id" integer not null default nextval('users_id_seq'::regclass),
    "name" text not null
);

alter sequence "public"."users_id_seq" owned by "public"."users"."id";
CREATE UNIQUE INDEX users_pkey ON public.users USING btree (id);
alter table "public"."users" add constraint "users_pkey" PRIMARY KEY using index "users_pkey";
```
Only the commands necessary to make the changes will be generated. Let's apply the migration now.
```bash
$ sqld -W <supersecurepassword> apply
```

6. If there was a mistake or for some reason we wish to revert the state of the database back to what it was previously we can revert migrations. The default is to revert the last migration applied.
```bash
$ sqld -W <supersecretpassword> revert
```
or revert more than one migration.
```bash
$ sqld -W <supersecretpassword> revert 2 
```
This doesn't change your schema file but it _does_ change the schema of your actual database/

## Reference

`sqld [options...] init <database-name>`

Initializes database, schema, and migrations directory. If schema file and migrations directory already exists (if cloned from source control for example) then init will use those existing resources to initiate the database. As part of the initialization sqld will create a shadow database for the purposes of diffing. If no schema or migrations already exist then a base versioning schema will be created within the database to track versions.

`sqld [options...] create <migration-name>`

Diffs the current database schema with the schema.sql file specified. If there is no difference then no migration scripts will be created. <migration-name> allows you to specify a human readable migration name. This name will be prefixed with a timestamp. This command simply creates the migration files but does not apply them. This allows you to modify the imperative migration scripts before applying the migration.

`sqld [options...] [--cherry-pick] apply [<migration-name>]`

Applies the latest migrations to the database. If a <migration-name> is specified then sqld will run all migrations up to and including the specified name. If no migration-name is supplied then all the latest migrations will be run. If you just want to apply a specific migration out of order then use the `--cherry-pick` flag and supply the `migration-name`.

`sqld [options...] [--cherry-pick] revert [<migration-name>|<count>]`

Reverts the latest migration on the database. If a `count` is specified sqld will revert `count` migrations. To revert a single migration out of order use the `cherry-pick` flag and supply a `migration-name`. By default only the last migration is reverted.

__Arguments__    
`-n|--name=dbname` Specifies the name of the database to connect to

`-h|--host=hostname` The hostname to use when connecting to Postgres. Defaults to `localhost`.

`-p|--port=port` The port to use when connecting to Postgres. Defaults to `5432`.

`-s|--schema=schema` The name of the schema file to use. Defaults to `schema.sql`.

`-U|--username=username` The username to use when connecting to Postgres. Defaults to `postgres`.

`-W|--password=password` The password to use when connecting to Postgres.

## Roadmap
- [ ] Make sure command reference is accurate
- [ ] Lock file for migrations scripts
- [ ] Bring interface more in line with Prisma
- [ ] Decouple logic from Postgres to support more databases
- [ ] Re-implement in Rust for fun and profit
- [ ] Add verbose mode
- [ ] Distribute on Homebrew
- [ ] Move migrations and schema to dedicated `db` directory
- [ ] Support multiple schema files
- [ ] Decouple reliance on `migra.` Either bundle their Dockerfile (then Docker would be required) or use some other diff tool.
- [ ] Usage tutorial

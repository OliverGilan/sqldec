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

SQLDec is currently written completely in Bash. As a result you can simply clone this repository and place somewhere in your PATH.

## Usage

## Reference

`sqld [options...] init <project-name>`
Initializes database, schema, and migrations directory. Project name will be used to title the database. If schema file and migrations directory already exists (if cloned from source control for example) then init will use those existing resources to initiate the database. As part of the initialization sqld will create a shadow database for the purposes of diffing. If no schema or migrations already exist then a base versioning schema will be created within the database to track versions.

`sqld [options...] create [<migration-name>]`
Diffs the current database schema with the schema.sql file specified. If there is no difference then no migration scripts will be created. <migration-name> allows you to specify a human readable migration name. If no name is specified one will be generated automatically.
 This command simply creates the migration files but does not apply them. This allows you to modify the imperative migration scripts before applying the migration.

`sqld [options...] apply [<migration-name>|<count>]`
Applies the latest migrations to the database. If a <migration-name> is specified then sqld will run all migrations up to and including the specified name. You can instead provide a <count> and sqld will run <count> migrations since the current version.

`sqld [options...] revert [<migration-name>|<count>]`
Reverts the latest migrations on the database. If <migration-name> is specified all migrations after and including <migration-name> will be reverted. Otherwise if <count> is specified the last <count> migrations will be reverted. By default only the latest migration is reverted.    

__Arguments__    
`-d|--dbname=dbname` Specifies the name of the database to connect to. If the project is already initialized with SQLD then the database name will be saved. Otherwise it must be specified.

`-h|--host=hostname` The hostname to use when connecting to Postgres. Defaults to `localhost`.

`-p|--port=port` The port to use when connecting to Postgres. Defaults to `5432`.

`-s|--schema=schema` The name of the schema file to use. Defaults to `schema.sql`.

`-U|--username=username` The username to use when connecting to Postgres. Defaults to `postgres`.

`-W|--password=password` The password to use when connecting to Postgres.

## Roadmap
- [ ] Lock file for migrations scripts
- [ ] Bring interface more in line with Prisma
- [ ] Decouple logic from Postgres to support more databases
- [ ] Re-implement in Rust for fun and profit
- [ ] Add verbose mode
- [ ] Distribute on Homebrew
- [ ] Move migrations and schema to dedicated `db` directory
- [ ] Support multiple schema files
- [ ] Decouple reliance on `migra.` Either bundle their Dockerfile (then Docker would be required) or use some other diff tool.
- [ ] Proper command reference
- [ ] Usage tutorial

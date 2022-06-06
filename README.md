# SQLDec

### Summary
Whenever one works with a relational database the issue arises of how to effectively implement and track changes to the schema over time. There are two main methodologies for accomplishing this today: diffing and imperative migrations. With the diffing approach there is usually a declarative schema that is designed to reflect the _current state_ of the database schema. To make a change one needs to only update the declarative schema and the diffing tool will compare the new schema against the database and generate the DDL required to bring the database in line with the new changes. The pros of this approach is it's easy to use and one can easily see what the current state of the schema is quite easily. The downside to this approach is automatic diffing is often not perfect and can cause data loss.
The second approach is imperative migrations where the user directly describes how the schema and data should change with each migration. This allows a lot more control over the migration but can be a little harder to implement & these migration scripts can often pile up making it difficult to see the full picture of the database schema at any given moment.
One feature of modern ORM's and database tools like Prisma and Edgedb is the ability to easily handle database migrations through a combination of diffing and manual migrations but they almost all rely on a custom schema DDL language. This project is designed to implement a similar experience but using plain SQL for the schema. 

### Installation
__Homebrew__

__Binaries__

__Building from source__

### Usage

`sqld init [options...]`
Initializes database, schema, and migrations directory. If schema file and migrations directory already exists (if cloned from source control for example) then init will use those existing resources to initiate the database. As part of the initialization sqld will create a shadow database for the purposes of diffing. If no schema or migrations already exist then a base versioning schema will be created within the database to track versions.

`sqld create [options...] [<migration-name>]`
Diffs the current database schema with the schema.sql file specified. If there is no difference then no migration scripts will be created. <migration-name> allows you to specify a human readable migration name. If no name is specified one will be generated automatically.
 This command simply creates the migration files but does not apply them. This allows you to modify the imperative migration scripts before applying the migration.

`sqld apply [options...] [<migration-name>|<count>]`
Applies the latest migrations to the database. If a <migration-name> is specified then sqld will run all migrations up to and including the specified name. You can instead provide a <count> and sqld will run <count> migrations since the current version.

`sqld rever [options...] [<migration-name>|<count>]`
Reverts the latest migrations on the database. If <migration-name> is specified all migrations after and including <migration-name> will be reverted. Otherwise if <count> is specified the last <count> migrations will be reverted. By default only the latest migration is reverted.


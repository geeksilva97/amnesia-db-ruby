# AmnesiaDB

AmnesiaDB is a simple key/value storage engine developed with a single purpose: studying internal aspects of a database.
It's supposed to be an LSM-Tree with some specific types being implemented using B+-Trees.


## Features

### Data Structures/Types

- SET: Implemented using B+-Trees
- STRING: Plain values stored by commands like `set somekey somevalue`

## Executing this project

### Installing dependencies

```bash
bundle install
```

### Running tests

```bash
bundle exec rspec
```

### Starting CLI

```bash
./amnesia-cli dbname.db
```

Once you are in the prompt you can execute the following commands: `get`, `set`, and `delete`.

```bash
> set firstName Mabel

> set lastName Pines
```

for deleting:

```bash
> delete firstName
```

for retrieving:

```bash
> get lastName
Pines
```

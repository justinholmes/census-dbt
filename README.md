Census [dbt](https://github.com/fishtown-analytics/dbt) utility package.

## Installation Instructions
Since this is a private package, it is installed via git:
```
cd /path/to/workingdir
git clone git@github.com:sutrolabs/census-dbt
```

Then, in all projects that use the package, add the following section to `packages.yml`:
```
packages:
  # ...any other definitions here...

  - local: /path/to/workingdir/census-dbt
```

Check [dbt Hub](https://hub.getdbt.com/fishtown-analytics/dbt_utils/latest/) for the latest installation instructions, or [read the docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

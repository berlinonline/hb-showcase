# Developing on a branch of a vendor package

Branch `v001-dev` on `berlinonline/honeybee`:

- cd berlinonline/honeybee
- git fetch origin v001-dev:v001-dev --verbose
- git branch --set-upstream-to=origin/v001-dev v001-dev
- cd -

Use your package and branch names accordingly.

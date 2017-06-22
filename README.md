# little-node
A light-weight (<100MB) alpine image for node that does have features essential
for using node in a CI or productive context.

- `make`, `gcc`, `python` etc. for building npm packages
- `git` for downloading git packages in the `package.json`
- `bash`, `curl` for use in scripts
- Proper user for correctly accessing a module.

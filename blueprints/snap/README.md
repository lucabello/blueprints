# {{project_name}}

[![Release](https://github.com/lucabello/{{project_name}}/actions/workflows/release.yaml/badge.svg)](https://github.com/lucabello/{{project_name}}/actions/workflows/release.yaml)
[![Just Snap badge](https://snapcraft.io/just/badge.svg)](https://snapcraft.io/just)

This is an unofficial snap for [casey/just](https://github.com/casey/just).

Upstream releases are pulled automatically on a daily basis, merged to `main` and released to `latest/edge`. After one week, they are automatically pushed to `latest/stable`.

---

You should start by substituting `{{project_name}}` everywhere and by updating the metadata in `snapcraft.yaml`.

Get a token from `snapcraft export-login`, and set it in a `SNAPCRAFT_STORE_CREDENTIALS` secret in the repository:

```bash
snapcraft export-login --snaps={{snap_name}} ~/.snapcraft-creds
gh secret set --repo={{snap_repo}} SNAPCRAFT_STORE_CREDENTIALS < ~/.snapcraft-creds
```

Each test should live in its own subfolder in `./spread/general/`, such as `./spread/general/{{test_name}}/task.yaml`.

# Fast Local Setup for Assistants
- Follow the local-development sequence in the [README](../README.md#local-development); inspect `Gemfile.lock`, `package.json`, and the sample database configuration before installing dependencies.
- Configure local development and test databases before `bin/setup` or any database task. Never assume a supplied dump or database URL is safe to execute against.
- Preserve lockfiles during setup. Use `bin/shakapacker` and `bin/shakapacker-dev-server` for the current asset pipeline.
- Distinguish empty-schema startup from a content-complete homepage; PostgreSQL data, archived SQLite data and uploaded media are separate inputs.
- Ask the owner to configure required credentials securely. Keep local overrides, dumps, media caches and secrets out of commits; stage only intended source/documentation files and review the full staged diff.
- Verify HTTP responses and browser behavior separately. Report network isolation or blocked browser access honestly instead of claiming a successful visual check.

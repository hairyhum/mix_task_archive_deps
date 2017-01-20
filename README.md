# Mix tasks to archive project dependencies

This repo contains Mix tasks to create `*.ez` archives for a project dependencies.

There are three new tasks:

- `archive.build.deps` - build archives for a project dependencies
- `archive.build.elixir` - build archives with Elixir and Elixir apps (like `mix` or `logger`)
- `archive.build.all` - build dependencies archives and a project archive

The tasks are intended to use to create no-dependency distributions of Elixir apps,
that can be run from Erlang runtime without installing Elixir and recompiling apps.

## Installation

The package can be installed by adding `mix_task_archive_deps`
to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:mix_task_archive_deps, "~> 0.1.0"}]
end
```

Alternatively the package can be installed as an archive from release:

```
mix archive.install https://github.com/hairyhum/mix_task_archive_deps/releases/download/0.1.0/mix_task_archive_deps-0.1.0.ez
```

The docs can be found at [https://hexdocs.pm/mix_task_archive_deps](https://hexdocs.pm/mix_task_archive_deps).


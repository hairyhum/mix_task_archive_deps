##
## The contents of this file are subject to the Mozilla Public License
## Version 1.1 (the "License"); you may not use this file except in
## compliance with the License. You may obtain a copy of the License
## at http://www.mozilla.org/MPL/
##
## Software distributed under the License is distributed on an "AS IS"
## basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
## the License for the specific language governing rights and
## limitations under the License.
##
## The Original Code is mix_task_archive_deps.
##
## The Initial Developer of the Original Code is Daniil Fedotov.
## Copyright (c) 2017 Daniil Fedotov.  All rights reserved.
##


defmodule Mix.Tasks.Archive.Build.Elixir do
  use Mix.Task

  @shortdoc "Archives elixir applications referenced by the project into .ez files"

  @moduledoc """
  Builds each elixir project required by the project into
  archives according to the specification of the
  [Erlang Archive Format](http://www.erlang.org/doc/man/code.html).

  This task goal is to create packages. which could
  be used from Erlang environment without Elixir installation.

  The archives will be created in the "archives" subdirectory of
  the project build directory by default, unless an argument `-o` is
  provided with the directory name.

  The task will create archives for applications, referenced by the project
  and it's dependencies, unless `-a` flag is specified.

  ## Command line options

  * `-o|--destination` - specifies output directory name.
      Defaults to BUILD_DIR/archives

  * `-a|--all_applications` - specifies if all elixir applications
      should be archived. Defaults to `false`
  """

  @switches [destination: :string, all_applications: :boolean]
  @aliases [o: :destination, a: :all_applications]
  @elixir_apps [:elixir, :eex, :ex_unit, :iex, :logger, :mix]

  @spec run(OptionParser.argv) :: :ok
  def run(argv) do
    Mix.Tasks.Loadpaths.run([])
    {opts, _} = OptionParser.parse!(argv, aliases: @aliases, strict: @switches)
    build_archives(opts)
  end

  def build_archives(opts) do
    list(opts)
    |>  Enum.each(fn({lib_dir, archive_path}) ->
          Mix.Tasks.Archive.Build.run(["-i", lib_dir,
                                       "-o", archive_path])
        end)

    :ok
  end

  def list_archives(opts) do
    list(opts)
    |> Enum.map(fn({_, archive_path}) -> archive_path end)
  end

  defp list(opts) do
    destination = Mix.Archive.Build.Helpers.destination(opts)
    all_applications = opts[:all_applications] || false

    get_required_apps(all_applications)
    |>  Enum.map(fn(elixir_app) ->
          lib_dir = :code.lib_dir(elixir_app)
          archive_name = "#{elixir_app}-#{Application.spec(elixir_app, :vsn)}.ez"
          archive_path = Path.join([destination, archive_name])
          {lib_dir, archive_path}
        end)
  end

  defp get_required_apps(true) do
    @elixir_apps
  end
  defp get_required_apps(false) do
    required_apps = get_applications()
    @elixir_apps
    |> Enum.filter(fn(app) -> Enum.member?(required_apps, app) end)
  end

  defp get_applications() do
    application = Mix.Project.config[:app]
    get_applications_recursively([application])
  end

  defp get_applications_recursively(applications) do
    Enum.flat_map(applications,
                  fn(app) ->
                    Application.load(app)
                    deps = Application.spec(app, :applications) || []
                    [app | get_applications_recursively(deps)]
                  end)
  end
end

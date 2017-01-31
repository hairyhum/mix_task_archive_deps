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


defmodule Mix.Tasks.Archive.Build.Deps do
  use Mix.Task

  @shortdoc "Archives the project dependencies into .ez files"

  @moduledoc """
  Builds each dependency into archives according to the specification of the
  [Erlang Archive Format](http://www.erlang.org/doc/man/code.html).

  Archives are prebuild packages, which can be used by both Erlang and Elixir
  without Mix or other dependency management tools.

  The archives will be created in the "archives" subdirectory of
  the project build directory by default, unless an argument `-o` is
  provided with the directory name.

  ## Command line options

  * `-o` - specifies output directory name.
      Defaults to BUILD_DIR/archives
  """

  @switches [destination: :string]
  @aliases [o: :destination]

  @spec run(OptionParser.argv) :: :ok
  def run(argv) do
    {opts, _} = OptionParser.parse!(argv, aliases: @aliases, strict: @switches)
    build_archives(opts)
  end

  def build_archives(opts) do
    list(opts)
    |>  Enum.each(fn({app_dir, archive_path}) ->
          Mix.Tasks.Archive.Build.run(["-i", app_dir, "-o", archive_path])
        end)
    :ok
  end

  def list_archives(opts) do
    list(opts)
    |> Enum.map(fn({_, archive_path}) -> archive_path end)
  end

  defp list(opts) do
    build_path = Mix.Project.build_path
    destination = Mix.Archive.Build.Helpers.destination(opts)

    ## Build delendencies archives
    deps = Mix.Dep.loaded(env: Mix.env)
    Enum.map(deps, fn(%Mix.Dep{app: app, status: status}) ->
      version = case status do
        {:ok, vsn} when vsn != nil -> vsn
        reason -> :erlang.error({:invalid_status, reason})
      end
      archive_path = Path.join([destination, "#{app}-#{version}.ez"])
      app_dir = Path.join([build_path, "lib", "#{app}"])
      {app_dir, archive_path}
    end)
  end
end
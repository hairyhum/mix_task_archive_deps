##
##
## Copyright (c) 2017, Daniil Fedotov.
## All Rights Reserved.
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
##

defmodule Mix.Tasks.Archive.Build.All do
  use Mix.Task

  @shortdoc "Archives the project and all it's dependencies into .ez files"

  @moduledoc """
  Builds each dependency required by the project and the project itself into
  archives according to the specification of the
  [Erlang Archive Format](http://www.erlang.org/doc/man/code.html).

  This task goal is to create packages. which could
  be used from Erlang environment without Elixir installation.

  The archives will be created in the "archives" subdirectory of
  the project build directory by default, unless an argument `-o` is
  provided with the directory name.

  The task will create archives for the project application,
  and all it's dependencies.

  If `-e` flag is specified, it will also archive elixir core applications
  referenced by the project and all it's dependencies.

  ## Command line options

  * `-o|--destination` - specifies output directory name.
      Defaults to BUILD_DIR/archives

  * `-e|--elixir` - specifies if all elixir applications
      should be archived. Defaults to `false`
  """


  @switches [destination: :string, elixir: :boolean]
  @aliases [o: :destination, e: :elixir, l: :list]

  @spec run(OptionParser.argv) :: :ok
  def run(argv) do
    Mix.Tasks.Loadpaths.run([])
    {opts, _} = OptionParser.parse!(argv, aliases: @aliases, strict: @switches)
    destination = Mix.Archive.Build.Helpers.destination(opts)
    Mix.Tasks.Archive.Build.Deps.build_archives(opts)

    archive_name = Mix.Local.name_for(:archive, Mix.Project.config)
    archive_path = Path.join([destination, archive_name])
    Mix.Tasks.Archive.Build.run(["-o", archive_path])

    if opts[:elixir] do
      Mix.Tasks.Archive.Build.Elixir.build_archives(opts)
    end
    :ok
  end
end
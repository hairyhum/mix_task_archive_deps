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


defmodule Mix.Tasks.Archive.Build.All.List do
  use Mix.Task

  @shortdoc "Lists .ez archives to be built with Archive.Build.All"

  @moduledoc """
  ## Command line options

  * `-o|--destination` - specifies output directory name.
      Defaults to BUILD_DIR/archives

  * `-e|--elixir` - specifies if all elixir applications
      should be archived. Defaults to `false`

  * `-s|--separator` - character to use as separator
    when listing archives
  """


  @switches [destination: :string, elixir: :boolean, separator: :string]
  @aliases [o: :destination, e: :elixir, s: :separator]

  @spec run(OptionParser.argv) :: :ok
  def run(argv) do
    Mix.Tasks.Loadpaths.run([])
    {opts, _} = OptionParser.parse!(argv, aliases: @aliases, strict: @switches)
    destination = Mix.Archive.Build.Helpers.destination(opts)
    elixir = opts[:elixir] || false
    separator = opts[:separator] || "\n"

    archive_name = Mix.Local.name_for(:archive, Mix.Project.config)
    archive_path = Path.join([destination, archive_name])

    deps_archives = Mix.Tasks.Archive.Build.Deps.list_archives(opts)

    elixir_archives = if elixir do
      Mix.Tasks.Archive.Build.Elixir.list_archives(opts)
    else
      []
    end

    [[archive_path], deps_archives, elixir_archives]
    |> Enum.concat
    |> Enum.join(separator)
    |> IO.puts

    :ok
  end
end
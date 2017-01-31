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


defmodule MixTaskArchiveDeps.Mixfile do
  use Mix.Project

  def project do
    [app: :mix_task_archive_deps,
     version: "0.3.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: "Mix task to create archives for a project dependencies and elixir itself",
     package: package(),
     deps: deps(),
     name: "MixTaskArchiveDeps",
     source_url: "https://github.com/hairyhum/mix_task_archive_deps"]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ex_doc, "~> 0.14", only: :dev}]
  end
  defp package() do
    [name: :mix_task_archive_deps,
     files: ["lib", "mix.exs", "README*", "LICENSE*"],
     maintainers: ["Daniil Fedotov"],
     licenses: ["MPL 1.1"],
     links: %{"GitHub" => "https://github.com/hairyhum/mix_task_archive_deps"}]
  end
end

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

defmodule MixTaskDepsArchive.Mixfile do
  use Mix.Project

  def project do
    [app: :mix_task_deps_archive,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: "Mix task to create archives for a project dependencies and elixit itslef",
     package: package(),
     deps: deps()]
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
    []
  end
  defp package() do
    [name: :mix_task_deps_archive,
     files: ["lib", "mix.exs", "README*", "LICENSE*"],
     maintainers: ["Daniil Fedotov"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/hairyhum/mix_task_deps_archive"}]
  end
end

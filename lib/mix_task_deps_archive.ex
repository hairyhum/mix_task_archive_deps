defmodule Mix.Tasks.Deps.Archive.Build do
  use Mix.Task

  @switches [destination: :string, compile: :boolean, include_app: :boolean]
  @aliases [o: :destination, c: :compile, a: :include_app]

  def run(argv) do
    {opts, _} = OptionParser.parse!(argv, aliases: @aliases, strict: @switches)
    build_path = Mix.Project.build_path
    destination = opts[:destination] || Path.join(build_path, "archives")
    compile = opts[:compile] || false
    include_app = opts[:include_app] || false

    if compile do
        Mix.Task.run("deps.compile")
        if include_app do
          Mix.Task.run("compile")
        end
    end

    ## Build delendencies archives
    deps = Mix.Dep.loaded(env: Mix.env)
    Enum.each(deps, fn %Mix.Dep{app: app, status: status} ->
      version = case status do
        {:ok, vsn} when vsn != nil -> vsn
        reason -> :erlang.error({:invalid_status, reason})
      end
      archive_path = Path.join([destination, "#{app}-#{version}.ez"])
      app_dir = Path.join([build_path, "lib", "#{app}"])
      Mix.Tasks.Archive.Build.run(["-i", app_dir, "-o", archive_path])
    end)

    ## Build the project application archive
    if include_app do
      archive_name = Mix.Local.name_for(:archive, Mix.Project.config)
      archive_path = Path.join([destination, archive_name])
      Mix.Tasks.Archive.Build.run(["-o", archive_path])
    end
  end
end
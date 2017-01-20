defmodule Mix.Archive.Build.Helpers do
  def destination(opts) do
    opts[:destination] || Path.join(Mix.Project.build_path, "archives")
  end
end
defmodule HangTen.Registry do
  @moduledoc false

  @registry_name :hangten_registry

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    Supervisor.init([
      {Registry, keys: :unique, name: @registry_name}
    ], strategy: :one_for_one)
  end

  def name(process_name, suffix \\"") do
    {:via, Registry, {@registry_name, process_name <> suffix}}
  end
end

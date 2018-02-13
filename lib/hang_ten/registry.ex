defmodule HangTen.Registry do
  @moduledoc false

  @name __MODULE__

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: @name)
  end

  def init(_) do
    Supervisor.init([
      {Registry, [keys: :unique, name: :hangten_registry]}
    ], strategy: :one_for_one)
  end
end

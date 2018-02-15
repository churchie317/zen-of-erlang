defmodule HangTen.Supervisor do
  @moduledoc false

  use DynamicSupervisor

  @name __MODULE__

  def start_link() do
    DynamicSupervisor.start_link(__MODULE__, [], name: @name)
  end

  def start_child(user) do
    DynamicSupervisor.start_child(__MODULE__, {HangTen.Server, user})
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end

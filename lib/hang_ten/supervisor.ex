defmodule HangTen.Supervisor do
  @moduledoc false

  use DynamicSupervisor

  def start_link() do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(user) do
    DynamicSupervisor.start_child(__MODULE__, {HangTen.User.Supervisor, user})
  end
end

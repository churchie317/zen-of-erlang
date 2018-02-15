defmodule HangTen do
  @moduledoc false

  def new(user) do
    HangTen.Supervisor.start_child(user)
  end

  def stop(user) do
    GenServer.call(via_tuple(user), :stop)
  end

  def boom!(user) do
    GenServer.call(via_tuple(user), :boom)
  end

  defp via_tuple(user) do
    {:via, Registry, {:hangten_registry, user}}
  end
end

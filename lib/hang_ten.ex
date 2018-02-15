defmodule HangTen do
  @moduledoc false

  def new(user) do
    HangTen.Supervisor.start_child(user)
  end

  def count_request(user) do
    user
    |> HangTen.Registry.name("_server")
    |> GenServer.cast(:increase_count)
  end

  def boom!(user) do
    user
    |> HangTen.Registry.name("_server")
    |> GenServer.cast(:boom)
  end
end

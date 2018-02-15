defmodule HangTen do
  @moduledoc false

  def new(user) do
    {:ok, pid} = HangTen.Supervisor.start_child(user)
    HangTen.User.new(user)
  end

  def count_request(user) do
    user
    |> HangTen.ViaTuple.from("_server")
    |> GenServer.cast(:increase_count)
  end

  def boom!(user) do
    user
    |> HangTen.ViaTuple.from("_server")
    |> GenServer.cast(:boom)
  end
end

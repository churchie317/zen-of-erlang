defmodule HangTen do
  @moduledoc false

  def new(user) do
    {:ok, pid} = HangTen.Supervisor.start_child(user)
    pid
  end

  def stop(user_pid) do
    GenServer.call(user_pid, :stop)
  end

  def boom!(user_pid) do
    GenServer.call(user_pid, :boom)
  end
end

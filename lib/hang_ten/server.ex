defmodule HangTen.Server do
  @moduledoc false

  use GenServer, restart: :transient, shutdown: 10_000

  def start_link(user) do
    GenServer.start_link(__MODULE__, user)
  end

  def init(user) do
    {:ok, user}
  end

  def handle_call(:boom, _from, _state) do
    3 / 0
  end

  def terminate(reason, state) do
    IO.puts "#{state} process shutting down: #{reason}"
  end
end

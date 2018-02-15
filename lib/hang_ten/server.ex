defmodule HangTen.Server do
  @moduledoc false

  use GenServer, restart: :transient, shutdown: 10_000

  def start_link(user) do
    name = via_tuple(user)
    GenServer.start_link(__MODULE__, user, name: name)
  end

  def init(user) do
    {:ok, user}
  end

  def handle_call(:boom, _from, _state) do
    Process.exit(self(), :boom)
  end

  def terminate(reason, state) do
    IO.puts "#{state} process shutting down: #{reason}"
  end

  defp via_tuple(user) do
    {:via, Registry, {:hangten_registry, user}}
  end
end

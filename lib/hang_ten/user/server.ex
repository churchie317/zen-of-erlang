defmodule HangTen.User.Server do
  @moduledoc false

  use GenServer, restart: :transient, shutdown: 10_000

  def start_link(user) do
    GenServer.start_link(__MODULE__, user, name: HangTen.Registry.name(user, "_server"))
  end

  def init(user) do
    {:ok, HangTen.User.get(user)}
  end

  def handle_call(:boom, _from, _user) do
    Process.exit(self(), :boom)
  end

  def handle_cast(:increase_count, user) do
    {:noreply, %HangTen.User{user | request_count: user.request_count + 1}}
  end

  def terminate(_reason, user) do
    HangTen.User.stash(user.login, user)
  end
end

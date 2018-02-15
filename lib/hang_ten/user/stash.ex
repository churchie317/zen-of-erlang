defmodule HangTen.User.Stash do
  @moduledoc false

  use GenServer

  def start_link(user) do
    GenServer.start_link(__MODULE__, user, name: HangTen.Registry.name(user, "_stash"))
  end

  def init(user) do
    {:ok, HangTen.User.new(user)}
  end

  def handle_call(:get_user, _from, user) do
    {:reply, user, user}
  end

  def handle_cast({:set_user, user}, _user) do
    {:noreply, user}
  end
end

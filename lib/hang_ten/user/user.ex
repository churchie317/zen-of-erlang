defmodule HangTen.User do
  @moduledoc false

  defstruct login: "", request_count: 0

  def new(user) do
    %HangTen.User{login: user}
  end

  def get(user) do
    user
    |> HangTen.Registry.name("_stash")
    |> GenServer.call(:get_user)
  end

  def stash(user, state) do
    user
    |> HangTen.Registry.name("_stash")
    |> GenServer.cast({:set_user, state})
  end
end

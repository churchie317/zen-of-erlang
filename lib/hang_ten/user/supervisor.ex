defmodule HangTen.User.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link(user) do
    Supervisor.start_link(__MODULE__, user, name: HangTen.Registry.name(user, "_supervisor"))
  end

  def init(user) do
    children = [
      {HangTen.User.Stash, user},
      {HangTen.User.Timer, user},
      {HangTen.User.SubSupervisor, user}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

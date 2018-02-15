defmodule HangTen.User.SubSupervisor do
  @moduledoc false

  use Supervisor

  def start_link(user) do
    Supervisor.start_link(__MODULE__, user)
  end

  def init(user) do
    Supervisor.init([
      {HangTen.User.Server, user}
    ], strategy: :one_for_one)
  end
end

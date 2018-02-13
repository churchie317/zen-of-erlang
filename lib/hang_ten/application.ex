defmodule HangTen.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    {:ok, _registry_pid} = HangTen.Registry.start_link()
    {:ok, _sup_pid} = HangTen.Supervisor.start_link()
  end
end

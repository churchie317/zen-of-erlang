defmodule HangTen.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    HangTen.Supervisor.start_link()
  end
end

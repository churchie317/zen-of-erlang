defmodule HangTen.ViaTuple do
  @moduledoc false

  def from(user, process_name) do
    {:via, Registry, {:hangten_registry, user <> process_name}}
  end
end

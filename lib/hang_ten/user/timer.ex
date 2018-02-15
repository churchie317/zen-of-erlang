defmodule HangTen.User.Timer do
  @moduledoc false
  alias __MODULE__

  @inactive_timeout 900_000 ## 15 minutes
  @absolute_timeout 3_600_000 ## 60 minutes
  @stop_msg :stop

  use GenServer

  defstruct [:login, :inactivity_timer]

  def start_link(user) do
    GenServer.start_link(__MODULE__, user)
  end

  def init(user) do
    send_shutdown_msg(@absolute_timeout)
    {:ok, %Timer{login: user, inactivity_timer: send_shutdown_msg(@inactive_timeout)}}
  end

  def handle_cast(_, %Timer{inactivity_timer: timer_ref} = state) do
    Process.cancel_timer(timer_ref)
    {:noreply, %Timer{state | inactivity_timer: send_shutdown_msg(@inactive_timeout)}}
  end

  def handle_info(@stop_msg, %Timer{login: user}) do
    HangTen.Supervisor.stop_child(user)
    {:noreply, :noop}
  end
  def handle_info(_, state), do: {:noreply, state}

  defp send_shutdown_msg(time) do
    Process.send_after(self(), @stop_msg, time)
  end
end

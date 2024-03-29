defmodule IslandsEngine.GameSupervisor do
  use Supervisor

  alias IslandsEngine.Game

  # Server Callbacks

  def init(:ok) do
    Supervisor.init([Game], strategy: :simple_one_for_one)
  end

  # Client API

  # we need only one process supervisor, so we gave to it the current module name
  def start_link(_options) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_game(name) do
    Supervisor.start_child(__MODULE__, [name])
  end

  def stop_game(name) do
    Supervisor.terminate_child(__MODULE__, pid_from_name(name))
  end

  @doc """
  Return the game process pid from the provided name
  """
  defp pid_from_name(name) do
    name
    |> Game.via_tuple()
    |> GenServer.whereis()
  end
end

defmodule Conduit.Storage do
  alias Commanded.EventStore.Adapters.InMemory
  alias Ecto.Adapters.SQL.Sandbox

  @doc """
  Clear the event store and read store databases
  """
  def reset! do
    Application.stop(:conduit)
    Application.stop(:commanded)

    reset_eventstore()

    {:ok, _} = Application.ensure_all_started(:conduit)

    reset_readstore()
  end

  defp reset_eventstore do
    {:ok, _event_store} = InMemory.start_link()
  end

  def reset_readstore do
    :ok = Sandbox.checkout(Conduit.Repo)

    Sandbox.mode(Conduit.Repo, {:shared, self()})
  end
end

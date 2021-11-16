defmodule Conduit.Storage do
  alias Ecto.Adapters.SQL.Sandbox

  @doc """
  Clear the event store and read store databases
  """
  def reset! do
    Application.stop(:conduit)

    {:ok, _} = Application.ensure_all_started(:conduit)

    reset_readstore()
  end

  def reset_readstore do
    :ok = Sandbox.checkout(Conduit.Repo)

    Sandbox.mode(Conduit.Repo, {:shared, self()})
  end
end

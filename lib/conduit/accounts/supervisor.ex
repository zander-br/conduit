defmodule Conduit.Accounts.Supervisor do
  use Supervisor

  alias Conduit.Accounts.Projectors.User, as: UserProjector

  def start_link(init_args) do
    Supervisor.start_link(__MODULE__, init_args, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [UserProjector]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

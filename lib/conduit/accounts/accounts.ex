defmodule Conduit.Accounts do
  @moduledoc """
  The boundary for the Accounts system.
  """

  alias Conduit.Accounts.Commands.RegisterUser
  alias Conduit.Accounts.Projections.User
  alias Conduit.Accounts.Queries.{UserByEmail, UserByUsername}
  alias Conduit.App, as: ConduitApp
  alias Conduit.Repo
  alias Conduit.Router

  @doc """
  Register a new user.
  """
  def register_user(attrs \\ %{}) do
    id = UUID.uuid4()

    register_user =
      attrs
      |> RegisterUser.new()
      |> RegisterUser.assign_id(id)
      |> RegisterUser.downcase_username()
      |> RegisterUser.downcase_email()
      |> RegisterUser.hash_password()

    with :ok <- Router.dispatch(register_user, application: ConduitApp, consistency: :strong) do
      get(User, id)
    else
      reply -> reply
    end
  end

  @doc """
  Get an existing user by their username, or return `nil` if not registered
  """
  def user_by_username(username) do
    username
    |> String.downcase()
    |> UserByUsername.new()
    |> Repo.one()
  end

  @doc """
  Get an existing user by their email address, or return `nil` if not registered
  """
  def user_by_email(email) when is_binary(email) do
    email
    |> String.downcase()
    |> UserByEmail.new()
    |> Repo.one()
  end

  @doc """
  Get a single user by their ID
  """
  def user_by_id(id) when is_binary(id) do
    Repo.get(User, id)
  end

  defp get(schema, id) do
    case Repo.get(schema, id) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end
end

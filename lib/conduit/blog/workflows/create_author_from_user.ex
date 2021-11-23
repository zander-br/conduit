defmodule Conduit.Blog.Workflows.CreateAuthorFromUser do
  use Commanded.Event.Handler,
    application: Conduit.App,
    name: "Blog.Workflows.CreateAuthorFromUser",
    consistency: :strong

  alias Conduit.Accounts.Events.UserRegistered
  alias Conduit.Blog

  def handle(%UserRegistered{user_id: user_id, username: username}, _metadata) do
    with {:ok, _author} <- Blog.create_author(%{user_id: user_id, username: username}) do
      :ok
    else
      reply -> reply
    end
  end
end

defmodule Conduit.Blog.Commands.CreateAuthor do
  defstruct author_id: "", user_id: "", username: ""

  use ExConstructor
  use Vex.Struct

  alias Conduit.Blog.Commands.CreateAuthor

  validates(:author_id, uuid: true)
  validates(:user_id, uuid: true)

  validates(:username,
    presence: [message: "can't be empty"],
    format: [with: ~r/^[a-z0-9]+$/, allow_nil: true, allow_blank: true, message: "is invalid"],
    string: true
  )

  @doc """
  Assign a unique identity
  """
  def assign_id(%CreateAuthor{} = create_author, id) do
    %CreateAuthor{create_author | author_id: id}
  end
end

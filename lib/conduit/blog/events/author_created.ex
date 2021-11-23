defmodule Conduit.Blog.Events.AuthorCreated do
  @derive Jason.Encoder
  defstruct [:author_id, :user_id, :username]
end

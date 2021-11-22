defmodule Conduit.Blog.Supervisor do
  use Supervisor

  alias Conduit.Blog.Projectors.Article, as: ArticleProjector
  alias Conduit.Blog.Workflows.CreateAuthorFromUser

  def start_link(init_args) do
    Supervisor.start_link(__MODULE__, init_args, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [ArticleProjector, CreateAuthorFromUser]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

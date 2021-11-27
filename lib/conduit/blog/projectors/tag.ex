defmodule Conduit.Blog.Projectors.Tag do
  use Commanded.Projections.Ecto,
    application: Conduit.App,
    repo: Conduit.Repo,
    name: "Blog.Projectors.Tag",
    consistency: :strong

  alias Conduit.Blog.Events.ArticlePublished
  alias Conduit.Blog.Projections.Tag
  alias Ecto.Multi

  project(%ArticlePublished{tag_list: tag_list}, fn multi ->
    Enum.reduce(tag_list, multi, fn tag, multi ->
      Multi.insert(multi, "tag-#{tag}", %Tag{name: tag},
        on_conflict: :nothing,
        conflict_target: :name
      )
    end)
  end)
end

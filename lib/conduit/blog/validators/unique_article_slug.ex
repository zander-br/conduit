defmodule Conduit.Blog.Validators.UniqueArticleSlug do
  use Vex.Validator

  alias Conduit.Blog
  alias Vex.Validators.By

  def validate(value, _options) do
    By.validate(value,
      function: fn value -> !article_exists?(value) end,
      message: "has already been taken"
    )
  end

  defp article_exists?(slug) do
    case Blog.article_by_slug(slug) do
      nil -> false
      _ -> true
    end
  end
end

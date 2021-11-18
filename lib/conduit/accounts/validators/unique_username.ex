defmodule Conduit.Accounts.Validators.UniqueUsername do
  use Vex.Validator

  alias Conduit.Accounts
  alias Vex.Validators.By

  def validate(value, _options) do
    By.validate(value,
      function: fn value -> !username_registered?(value) end,
      message: "has already been taken"
    )
  end

  defp username_registered?(username) do
    case Accounts.user_by_username(username) do
      nil -> false
      _ -> true
    end
  end
end

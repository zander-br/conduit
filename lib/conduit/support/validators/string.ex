defmodule Conduit.Support.Validators.String do
  use Vex.Validator

  alias Vex.Validators.By

  def validate(nil, _options), do: :ok
  def validate("", _options), do: :ok

  def validate(value, _options) do
    By.validate(value, function: &String.valid?/1)
  end
end

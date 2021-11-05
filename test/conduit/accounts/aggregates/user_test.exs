defmodule Conduit.Accounts.Aggregates.UserTest do
  use Conduit.AggregateCase, aggregate: Conduit.Accounts.Aggregates.User

  alias Conduit.Accounts.Events.UserRegistered

  describe "register user" do
    @tag :unit
    test "should succed when valid" do
      user_uuid = UUID.uuid4()

      assert_events(:register_user, user_uuid: user_uuid), [
        %UserRegistered{
          user_uuid: user_uuid,
          email: "jake@jake.jake",
          username: "jake",
          hashed_password: "jakejake",
        }
      ]
    end
  end
end

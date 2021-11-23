defmodule Conduit.Accounts.Aggregates.UserTest do
  use Conduit.AggregateCase, aggregate: Conduit.Accounts.Aggregates.User

  alias Conduit.Accounts.Events.UserRegistered

  describe "register user" do
    @tag :unit
    test "should succeed when valid" do
      user_id = UUID.uuid4()

      assert_events(build(:register_user, user_id: user_id), [
        %UserRegistered{
          user_id: user_id,
          email: "jake@jake.jake",
          username: "jake",
          hashed_password: "jakejake"
        }
      ])
    end
  end
end

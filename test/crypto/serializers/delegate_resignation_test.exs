defmodule ArkEcosystem.Crypto.Serializers.DelegateResignationTest do
  use ExUnit.Case, async: false
  alias ArkEcosystem.Crypto.Serializer

  @tag :skip
  test "should be ok" do
    transaction = File.read!("test/fixtures/transactions/delegate_resignation.json")
      |> Jason.decode!(%{ :keys => :atoms })
      |> ArkEcosystem.Crypto.Utils.Underscorer.underscore

    actual = Serializer.serialize(transaction)
    assert(actual == transaction.serialized)
  end

end

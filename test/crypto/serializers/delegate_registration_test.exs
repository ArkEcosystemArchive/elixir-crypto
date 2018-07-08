defmodule ArkEcosystem.Crypto.Serializers.DelegateRegistrationTest do
  use ExUnit.Case, async: false
  alias ArkEcosystem.Crypto.Serializer

  test "should be ok" do
    transaction = File.read!("test/fixtures/transactions/delegate_registration.json")
      |> Jason.decode!(%{ :keys => :atoms })

    actual = Serializer.serialize(transaction)
    assert(actual == transaction.serialized)
  end

end

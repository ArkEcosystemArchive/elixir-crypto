defmodule ArkEcosystem.Crypto.Serializers.MultiPaymentTest do
  use ExUnit.Case, async: false
  alias ArkEcosystem.Crypto.Serializer

  @tag :skip
  test "should be ok" do
    transaction = File.read!("test/fixtures/transactions/multi_payment.json")
      |> Jason.decode!(%{ :keys => :atoms })

    actual = Serializer.serialize(transaction)
    assert(actual == transaction.serialized)
  end

end

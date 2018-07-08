defmodule ArkEcosystem.Crypto.Serializers.MultiPaymentTest do
  use ExUnit.Case, async: false
  alias ArkEcosystem.Crypto.Serializer

  @tag :skip
  test "should be ok" do
    transaction = File.read!("test/fixtures/transactions/multi_payment.json")
      |> Jason.decode!(%{ :keys => :atoms })

    ArkEcosystem.Crypto.Configuration.Network.set(
      ArkEcosystem.Crypto.Networks.Devnet
    )

    actual = Serializer.serialize(transaction)
    assert(actual == transaction.serialized)
  end

end

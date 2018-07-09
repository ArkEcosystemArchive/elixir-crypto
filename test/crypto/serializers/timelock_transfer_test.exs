defmodule ArkEcosystem.Crypto.Serializers.TimelockTransferTest do
  use ExUnit.Case, async: false
  alias ArkEcosystem.Crypto.Serializer

  @tag :skip
  test "should be ok" do
    transaction = File.read!("test/fixtures/transactions/timelock_transfer.json")
      |> Jason.decode!(%{ :keys => :atoms })

    ArkEcosystem.Crypto.Configuration.Network.set(
      ArkEcosystem.Crypto.Networks.Devnet
    )

    actual = Serializer.serialize(transaction)
    assert(actual == transaction.serialized)
  end

end

defmodule ArkEcosystem.Crypto.Deserializer.TransferTest do
  use ExUnit.Case, async: false
  alias ArkEcosystem.Crypto.Deserializer

  test "should be ok" do
    transaction = File.read!("test/fixtures/transactions/transfer.json")
      |> Jason.decode!(%{ :keys => :atoms })

    actual = Deserializer.deserialize(transaction)

    assert(actual.version == transaction.version)
    assert(actual.network == transaction.network)
    assert(actual.type == transaction.type)
    assert(actual.timestamp == transaction.timestamp)
    assert(actual.sender_public_key == transaction.senderPublicKey)
    assert(actual.fee == transaction.fee)
    assert(actual.amount == transaction.amount)
    assert(actual.expiration == transaction.expiration)
    assert(actual.recipient_id == transaction.recipientId)
    assert(actual.signature == transaction.signature)
    assert(actual.id == transaction.id)
  end


end

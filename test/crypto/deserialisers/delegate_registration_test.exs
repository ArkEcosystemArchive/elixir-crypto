defmodule ArkEcosystem.Crypto.Deserialiser.DelegateRegistrationTest do
  use ExUnit.Case, async: false
  alias ArkEcosystem.Crypto.Deserialiser
  import Mock

  test "should be ok" do
    transaction = File.read!("test/fixtures/transactions/delegate_registration.json")
      |> Jason.decode!(%{ :keys => :atoms })

    actual = Deserialiser.deserialise(transaction)

    assert(actual.version == transaction.version)
    assert(actual.network == transaction.network)
    assert(actual.type == transaction.type)
    assert(actual.timestamp == transaction.timestamp)
    assert(actual.sender_public_key == transaction.senderPublicKey)
    assert(actual.fee == transaction.fee)
    assert(actual.asset.delegate.username == transaction.asset.delegate.username)
    assert(actual.signature == transaction.signature)
    assert(actual.amount == transaction.amount)
    assert(actual.id == transaction.id)
  end


end

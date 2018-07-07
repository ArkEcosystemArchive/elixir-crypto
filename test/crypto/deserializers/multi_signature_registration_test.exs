defmodule ArkEcosystem.Crypto.Deserializer.MultiSignatureRegistrationTest do
  use ExUnit.Case, async: false
  alias ArkEcosystem.Crypto.Deserializer
  import Mock

  test "should be ok" do
    transaction = File.read!("test/fixtures/transactions/multi_signature_registration.json")
      |> Jason.decode!(%{ :keys => :atoms })

    actual = Deserializer.deserialize(transaction)
    assert(actual.version == transaction.version)
    assert(actual.network == transaction.network)
    assert(actual.type == transaction.type)
    assert(actual.timestamp == transaction.timestamp)
    assert(actual.sender_public_key == transaction.senderPublicKey)
    assert(actual.fee == transaction.fee)
    assert(actual.amount == transaction.amount)
    assert(actual.signature == transaction.signature)
    assert(actual.sign_signature == transaction.signSignature)
    assert(actual.signatures == transaction.signatures)
    assert(actual.asset.multisignature.keysgroup == transaction.asset.multisignature.keysgroup)
    assert(actual.asset.multisignature.min == transaction.asset.multisignature.min)
    assert(actual.asset.multisignature.lifetime == transaction.asset.multisignature.lifetime)

    assert(actual.id == transaction.id)
  end

end

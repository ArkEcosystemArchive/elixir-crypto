defmodule ArkEcosystem.Crypto.Transactions.Deserializers.MultiSignatureRegistrationTest do
  use ExUnit.Case, async: false
  alias ArkEcosystem.Crypto.Transactions.Deserializer
  alias ArkEcosystem.Test.TestHelper

  test "should be ok if signed with a passphrase" do
    fixture = TestHelper.read_transaction_fixture("multi_signature_registration", "passphrase")
    actual = Deserializer.deserialize(fixture)

    assert(actual.version == 1)
    assert(actual.network == 23)
    assert(actual.type == fixture.data.type)
    assert(actual.timestamp == fixture.data.timestamp)
    assert(actual.sender_public_key == fixture.data.senderPublicKey)
    assert(actual.fee == fixture.data.fee)
    assert(actual.amount == fixture.data.amount)
    assert(actual.id == fixture.data.id)
    assert(actual.signature == fixture.data.signature)
    assert(actual.sign_signature == fixture.data.signSignature)
    assert(actual.signatures == fixture.data.signatures)
    assert(actual.asset.multisignature.keysgroup == fixture.data.asset.multisignature.keysgroup)
    assert(actual.asset.multisignature.min == fixture.data.asset.multisignature.min)
    assert(actual.asset.multisignature.lifetime == fixture.data.asset.multisignature.lifetime)
  end
end

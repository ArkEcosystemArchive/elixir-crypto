defmodule ArkEcosystem.Crypto.Transactions.Deserializers.SecondSignatureRegistrationTest do
  use ExUnit.Case, async: false
  alias ArkEcosystem.Crypto.Transactions.Deserializer
  alias ArkEcosystem.Crypto.Transactions.Transaction
  alias ArkEcosystem.Crypto.Identities.Address
  alias ArkEcosystem.Test.TestHelper

  test "should be ok if signed with a passphrase" do
    fixture =
      TestHelper.read_transaction_fixture("second_signature_registration", "second-passphrase")

    actual = Deserializer.deserialize(fixture)

    assert(actual.version == 1)
    assert(actual.network == 30)
    assert(actual.type == fixture.data.type)
    assert(actual.timestamp == fixture.data.timestamp)
    assert(actual.sender_public_key == fixture.data.senderPublicKey)
    assert(actual.fee == fixture.data.fee)
    assert(actual.signature == fixture.data.signature)
    assert(actual.amount == fixture.data.amount)
    assert(actual.id == fixture.data.id)
    assert(actual.asset.signature.public_key == fixture.data.asset.signature.publicKey)
    assert(Transaction.verify(actual) == true)

    # special case as the type 1 transaction itself has no recipientId
    assert(actual.recipient_id == Address.from_public_key(fixture.data.senderPublicKey, 30))
  end
end

defmodule ArkEcosystem.Crypto.Deserializers.VoteTest do
  use ExUnit.Case, async: false
  alias ArkEcosystem.Crypto.Deserializer
  alias ArkEcosystem.Test.TestHelper

  test "should be ok if signed with a passphrase" do
    fixture = TestHelper.read_fixture("vote", "passphrase")
    actual = Deserializer.deserialize(fixture)

    assert(actual.version == 1)
    assert(actual.network == 30)
    assert(actual.type == fixture.data.type)
    assert(actual.timestamp == fixture.data.timestamp)
    assert(actual.sender_public_key == fixture.data.senderPublicKey)
    assert(actual.fee == fixture.data.fee)
    assert(actual.signature == fixture.data.signature)
    assert(actual.amount == fixture.data.amount)
    assert(actual.recipient_id == fixture.data.recipientId)
    assert(actual.id == fixture.data.id)
    assert(actual.asset.votes == fixture.data.asset.votes)
  end

  test "should be ok if signed with a second passphrase" do
    fixture = TestHelper.read_fixture("vote", "second-passphrase")
    actual = Deserializer.deserialize(fixture)

    assert(actual.version == 1)
    assert(actual.network == 30)
    assert(actual.type == fixture.data.type)
    assert(actual.timestamp == fixture.data.timestamp)
    assert(actual.sender_public_key == fixture.data.senderPublicKey)
    assert(actual.fee == fixture.data.fee)
    assert(actual.signature == fixture.data.signature)
    assert(actual.sign_signature == fixture.data.signSignature)
    assert(actual.amount == fixture.data.amount)
    assert(actual.recipient_id == fixture.data.recipientId)
    assert(actual.id == fixture.data.id)
    assert(actual.asset.votes == fixture.data.asset.votes)
  end

end

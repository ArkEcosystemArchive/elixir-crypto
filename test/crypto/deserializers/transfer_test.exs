defmodule ArkEcosystem.Crypto.Deserializers.TransferTest do
  use ExUnit.Case, async: false
  alias ArkEcosystem.Crypto.Deserializer
  alias ArkEcosystem.Test.TestHelper

  test "should be ok if signed with a passphrase" do
    fixture = TestHelper.read_transaction_fixture("transfer", "passphrase")
    actual = Deserializer.deserialize(fixture)

    assert(actual.version == 1)
    assert(actual.network == 30)
    assert(actual.type == fixture.data.type)
    assert(actual.timestamp == fixture.data.timestamp)
    assert(actual.sender_public_key == fixture.data.senderPublicKey)
    assert(actual.fee == fixture.data.fee)
    assert(actual.amount == fixture.data.amount)
    assert(actual.expiration == 0)
    assert(actual.recipient_id == fixture.data.recipientId)
    assert(actual.signature == fixture.data.signature)
    assert(actual.id == fixture.data.id)
  end

  test "should be ok if signed with a second passphrase" do
    fixture = TestHelper.read_transaction_fixture("transfer", "second-passphrase")
    actual = Deserializer.deserialize(fixture)

    assert(actual.version == 1)
    assert(actual.network == 30)
    assert(actual.type == fixture.data.type)
    assert(actual.timestamp == fixture.data.timestamp)
    assert(actual.sender_public_key == fixture.data.senderPublicKey)
    assert(actual.fee == fixture.data.fee)
    assert(actual.amount == fixture.data.amount)
    assert(actual.expiration == 0)
    assert(actual.recipient_id == fixture.data.recipientId)
    assert(actual.signature == fixture.data.signature)
    assert(actual.id == fixture.data.id)
  end

  test "should be ok if signed with a passphrase and vendor field" do
    fixture = TestHelper.read_transaction_fixture("transfer", "passphrase-with-vendor-field")
    actual = Deserializer.deserialize(fixture)

    assert(actual.version == 1)
    assert(actual.network == 30)
    assert(actual.type == fixture.data.type)
    assert(actual.timestamp == fixture.data.timestamp)
    assert(actual.sender_public_key == fixture.data.senderPublicKey)
    assert(actual.fee == fixture.data.fee)
    assert(actual.amount == fixture.data.amount)
    assert(actual.expiration == 0)
    assert(actual.recipient_id == fixture.data.recipientId)
    assert(actual.signature == fixture.data.signature)
    assert(actual.vendor_field == fixture.data.vendorField)
    assert(actual.id == fixture.data.id)
  end

  test "should be ok if signed with a second passphrase and vendor field" do
    fixture = TestHelper.read_transaction_fixture("transfer", "second-passphrase-with-vendor-field")
    actual = Deserializer.deserialize(fixture)

    assert(actual.version == 1)
    assert(actual.network == 30)
    assert(actual.type == fixture.data.type)
    assert(actual.timestamp == fixture.data.timestamp)
    assert(actual.sender_public_key == fixture.data.senderPublicKey)
    assert(actual.fee == fixture.data.fee)
    assert(actual.amount == fixture.data.amount)
    assert(actual.expiration == 0)
    assert(actual.recipient_id == fixture.data.recipientId)
    assert(actual.signature == fixture.data.signature)
    assert(actual.sign_signature == fixture.data.signSignature)
    assert(actual.vendor_field == fixture.data.vendorField)
    assert(actual.id == fixture.data.id)
  end

  test "should be ok if signed with a passphrase and vendor field hex" do
    fixture = TestHelper.read_transaction_fixture("transfer", "passphrase-with-vendor-field-hex")
    actual = Deserializer.deserialize(fixture)

    assert(actual.version == 1)
    assert(actual.network == 30)
    assert(actual.type == fixture.data.type)
    assert(actual.timestamp == fixture.data.timestamp)
    assert(actual.sender_public_key == fixture.data.senderPublicKey)
    assert(actual.fee == fixture.data.fee)
    assert(actual.vendor_field_hex == fixture.data.vendorFieldHex)
    assert(actual.amount == fixture.data.amount)
    assert(actual.expiration == 0)
    assert(actual.recipient_id == fixture.data.recipientId)
    assert(actual.signature == fixture.data.signature)
    assert(actual.id == fixture.data.id)
  end

  test "should be ok if signed with a second passphrase and vendor field hex" do
    fixture = TestHelper.read_transaction_fixture("transfer", "second-passphrase-with-vendor-field-hex")
    actual = Deserializer.deserialize(fixture)

    assert(actual.version == 1)
    assert(actual.network == 30)
    assert(actual.type == fixture.data.type)
    assert(actual.timestamp == fixture.data.timestamp)
    assert(actual.sender_public_key == fixture.data.senderPublicKey)
    assert(actual.fee == fixture.data.fee)
    assert(actual.vendor_field_hex == fixture.data.vendorFieldHex)
    assert(actual.amount == fixture.data.amount)
    assert(actual.expiration == 0)
    assert(actual.recipient_id == fixture.data.recipientId)
    assert(actual.signature == fixture.data.signature)
    assert(actual.sign_signature == fixture.data.signSignature)
    assert(actual.id == fixture.data.id)
  end

end

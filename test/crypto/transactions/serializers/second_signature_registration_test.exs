defmodule ArkEcosystem.Crypto.Transactions.Serializers.SecondSignatureRegistrationTest do
  use ExUnit.Case, async: false
  alias ArkEcosystem.Crypto.Transactions.Serializer
  alias ArkEcosystem.Test.TestHelper

  setup_all do
    ArkEcosystem.Crypto.Configuration.Network.set(
      ArkEcosystem.Crypto.Networks.Devnet
    )

    :ok
  end

  test "should be ok" do
    fixture = TestHelper.read_transaction_fixture("second_signature_registration", "second-passphrase")
    actual = Serializer.serialize(fixture.data, %{ underscore: true })

    assert(actual == fixture.serialized)
  end

end

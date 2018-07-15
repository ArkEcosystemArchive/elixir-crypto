defmodule ArkEcosystem.Crypto.Serializers.TransferTest do
  use ExUnit.Case, async: false
  alias ArkEcosystem.Crypto.Serializer
  alias ArkEcosystem.Test.TestHelper

  setup_all do
    ArkEcosystem.Crypto.Configuration.Network.set(
      ArkEcosystem.Crypto.Networks.Devnet
    )

    :ok
  end

  test "should be ok" do
    fixture = TestHelper.read_fixture("transfer", "passphrase")
    actual = Serializer.serialize(fixture.data, %{ underscore: true })

    assert(actual == fixture.serialized)
  end

end

defmodule ArkEcosystem.Crypto.Identities.WIFTest do
  use ExUnit.Case
  alias ArkEcosystem.Crypto.Identities.WIF
  alias ArkEcosystem.Test.TestHelper

  setup_all do
    ArkEcosystem.Crypto.Configuration.Network.set(ArkEcosystem.Crypto.Networks.Devnet)

    :ok
  end

  test "should be able to calculate the WIF from passphrase" do
    fixture = TestHelper.read_fixture("identity")
    actual = WIF.from_passphrase(fixture.passphrase)

    assert(actual == fixture.data.wif)
  end
end

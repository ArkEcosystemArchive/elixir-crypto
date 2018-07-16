defmodule ArkEcosystem.Crypto.Identities.PrivateKeyTest do
  use ExUnit.Case
  alias ArkEcosystem.Crypto.Identities.PrivateKey
  alias ArkEcosystem.Test.TestHelper

  setup_all do
    ArkEcosystem.Crypto.Configuration.Network.set(ArkEcosystem.Crypto.Networks.Devnet)

    :ok
  end

  test "should be able to calculate the private key from passphrase" do
    fixture = TestHelper.read_fixture("identity")
    actual = PrivateKey.from_passphrase(fixture.passphrase)

    assert(actual == fixture.data.privateKey)
  end

  test "should be able to calculate the private key from hex" do
    fixture = TestHelper.read_fixture("identity")
    actual = PrivateKey.from_hex(fixture.data.privateKey)

    assert(Base.encode16(actual, case: :lower) == fixture.data.privateKey)
  end
end

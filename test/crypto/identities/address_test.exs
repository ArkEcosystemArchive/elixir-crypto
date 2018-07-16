defmodule ArkEcosystem.Crypto.Identities.AddressTest do
  use ExUnit.Case
  alias ArkEcosystem.Crypto.Identities.Address
  alias ArkEcosystem.Test.TestHelper

  setup_all do
    ArkEcosystem.Crypto.Configuration.Network.set(
      ArkEcosystem.Crypto.Networks.Devnet
    )

    :ok
  end

  test "should be able to calculate the address from passphrase" do
    fixture = TestHelper.read_fixture("identity")

    actual = Address.from_passphrase(fixture.passphrase)

    assert(actual == fixture.data.address)
  end

  test "should be able to calculate the address from public key" do
    fixture = TestHelper.read_fixture("identity")

    actual = Address.from_public_key(fixture.data.publicKey)

    assert(actual == fixture.data.address)
  end

  test "should be able to calculate the address from private key" do
    fixture = TestHelper.read_fixture("identity")

    actual = Address.from_private_key(fixture.data.privateKey)

    assert(actual == fixture.data.address)
  end
end

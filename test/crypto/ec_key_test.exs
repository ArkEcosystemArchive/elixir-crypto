defmodule ArkEcosystem.Crypto.EcKeyTest do
  use ExUnit.Case
  alias ArkEcosystem.Crypto.Utils.EcKey
  alias ArkEcosystem.Test.TestHelper

  setup_all do
    ArkEcosystem.Crypto.Configuration.Network.set(
      ArkEcosystem.Crypto.Networks.Devnet
    )

    :ok
  end

  test "should be able to calculate the address from passphrase" do
    fixture = TestHelper.read_fixture("identity")

    actual = EcKey.secret_to_address(fixture.passphrase)

    assert(actual == fixture.data.address)
  end

  test "should be able to calculate the address from public key" do
    fixture = TestHelper.read_fixture("identity")

    actual = EcKey.public_key_to_address(fixture.data.publicKey)

    assert(actual == fixture.data.address)
  end

  test "should be able to calculate the address from private key" do
    fixture = TestHelper.read_fixture("identity")

    actual = EcKey.private_key_to_address(fixture.data.privateKey)

    assert(actual == fixture.data.address)
  end

end

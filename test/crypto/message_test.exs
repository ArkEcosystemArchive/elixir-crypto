defmodule ArkEcosystem.Crypto.MessageTest do
  use ExUnit.Case, async: false
  alias ArkEcosystem.Crypto.Message
  alias ArkEcosystem.Test.TestHelper

  test "should be able to sign a message" do
    fixture = TestHelper.read_fixture("message")
    actual = Message.sign(fixture.data.message, fixture.passphrase)

    assert(actual == fixture.data)
  end

  test "should be able to verify a message" do
    fixture = TestHelper.read_fixture("message")

    actual = Message.verify(
      fixture.data.message,
      fixture.data.signature,
      fixture.data.publickey
    )

    assert(actual == true)
  end

end

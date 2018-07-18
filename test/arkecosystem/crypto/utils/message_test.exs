defmodule ArkEcosystem.Crypto.Utils.MessageTest do
  use ExUnit.Case, async: false
  alias ArkEcosystem.Crypto.Utils.Message
  alias ArkEcosystem.Test.TestHelper

  test "should be able to sign a message" do
    fixture = TestHelper.read_fixture("message")
    actual = Message.sign(fixture.data.message, fixture.passphrase)

    assert(actual == fixture.data)
  end

  test "should be able to verify a message" do
    fixture = TestHelper.read_fixture("message")

    actual =
      Message.verify(
        fixture.data.message,
        fixture.data.signature,
        fixture.data.publickey
      )

    assert(actual == true)
  end

  test "should return params of a message" do
    fixture = TestHelper.read_fixture("message")

    actual =
      Message.to_params(
        fixture.data.message,
        fixture.data.signature,
        fixture.data.publickey
      )

    assert(actual == fixture.data)
  end

  test "should return json of a message" do
    fixture = TestHelper.read_fixture("message")

    actual =
      Message.to_json(
        fixture.data.message,
        fixture.data.signature,
        fixture.data.publickey
      )

    assert(actual == Jason.encode!(fixture.data))
  end
end

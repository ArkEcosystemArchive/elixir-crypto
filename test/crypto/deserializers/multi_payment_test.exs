defmodule ArkEcosystem.Crypto.Deserializers.MultiPaymentTest do
  use ExUnit.Case, async: false
  alias ArkEcosystem.Crypto.Deserializer
  alias ArkEcosystem.Test.TestHelper

  @tag :skip
  test "should be ok if signed with a passphrase" do
    fixture = TestHelper.read_fixture("multi_payment", "passphrase")
    actual = Deserializer.deserialize(fixture)

    assert(actual.id == fixture.data.id)
  end

end

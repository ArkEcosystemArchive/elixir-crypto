defmodule ArkEcosystem.Crypto.Transactions.Deserializers.TimelockTransferTest do
  use ExUnit.Case, async: false
  alias ArkEcosystem.Crypto.Transactions.Deserializer
  alias ArkEcosystem.Test.TestHelper

  @tag :skip
  test "should be ok if signed with a passphrase" do
    fixture = TestHelper.read_transaction_fixture("timelock_transfer", "passphrase")
    actual = Deserializer.deserialize(fixture)

    assert(actual.id == fixture.data.id)
  end
end

defmodule ArkEcosystem.Crypto.Transactions.TransactionTest do
  use ExUnit.Case, async: false
  alias ArkEcosystem.Crypto.Transactions.{Deserializer, Transaction}
  alias ArkEcosystem.Test.TestHelper

  test "should return params if signed with a passphrase" do
    fixture = TestHelper.read_transaction_fixture("transfer", "passphrase")

    actual =
      fixture
      |> Deserializer.deserialize()
      |> Transaction.to_params()

    assert(actual == fixture.data)
  end

  test "should return params if signed with a second passphrase" do
    fixture = TestHelper.read_transaction_fixture("transfer", "second-passphrase")

    actual =
      fixture
      |> Deserializer.deserialize()
      |> Transaction.to_params()

    assert(actual == fixture.data)
  end

  test "should return json if signed with a passphrase" do
    fixture = TestHelper.read_transaction_fixture("transfer", "passphrase")

    actual =
      fixture
      |> Deserializer.deserialize()
      |> Transaction.to_json()

    assert(actual == Jason.encode!(fixture.data))
  end

  test "should return json if signed with a second passphrase" do
    fixture = TestHelper.read_transaction_fixture("transfer", "second-passphrase")

    actual =
      fixture
      |> Deserializer.deserialize()
      |> Transaction.to_json()

    assert(actual == Jason.encode!(fixture.data))
  end
end

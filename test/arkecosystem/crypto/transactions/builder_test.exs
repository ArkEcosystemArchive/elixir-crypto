defmodule ArkEcosystem.Crypto.Transactions.BuilderTest do
  use ExUnit.Case, async: false
  alias ArkEcosystem.Crypto.Transactions.Transaction
  alias ArkEcosystem.Crypto.Transactions.Builder
  alias ArkEcosystem.Crypto.Identities.PublicKey

  import Mock

  setup_with_mocks([]) do
    {
      :ok,
      [
        amount: 133_380_000_000,
        recipient_id: "AXoXnFi4z1Z6aFvjEYkDVCtBGW2PaRiM25",
        vendor_field: "This is a transaction from Elixir",
        passphrase: "this is a top secret passphrase",
        second_passphrase: "this is a top secret second passphrase",
        delegate: "034151a3ec46b5670a682b0a63394f863587d1bc97483b1b6c70eb58e7f0aed192"
      ]
    }
  end

  test "should build transfer and verify", context do
    transaction =
      Builder.build_transfer(
        context[:recipient_id],
        context[:amount],
        context[:vendor_field],
        context[:passphrase]
      )

    assert(Transaction.verify(transaction) == true)
  end

  test "should build transfer and verfiy with second passphrase", context do
    transaction =
      Builder.build_transfer(
        context[:recipient_id],
        context[:amount],
        context[:vendor_field],
        context[:passphrase],
        context[:second_passphrase]
      )

    second_public_key = PublicKey.from_passphrase(context[:second_passphrase])

    assert(Transaction.verify(transaction) == true)
    assert(Transaction.second_verify(transaction, second_public_key) == true)
  end

  test "should build vote and verify", context do
    votes = ["+" <> context[:delegate]]

    transaction =
      Builder.build_vote(
        votes,
        context[:passphrase]
      )

    assert(Transaction.verify(transaction) == true)
  end

  test "should build vote and verify with second passphrase", context do
    votes = ["+" <> context[:delegate]]

    transaction =
      Builder.build_vote(
        votes,
        context[:passphrase],
        context[:second_passphrase]
      )

    second_public_key = PublicKey.from_passphrase(context[:second_passphrase])

    assert(Transaction.verify(transaction) == true)
    assert(Transaction.second_verify(transaction, second_public_key) == true)
  end

  test "should build second signature registration and verify", context do
    transaction =
      Builder.build_second_signature_registration(
        context[:passphrase],
        context[:second_passphrase]
      )

    second_public_key = PublicKey.from_passphrase(context[:second_passphrase])

    assert(Transaction.verify(transaction) == true)
    assert(Transaction.second_verify(transaction, second_public_key) == true)
  end

  test "should build delegate registration and verify", context do
    transaction =
      Builder.build_delegate_registration(
        "Moo",
        context[:passphrase]
      )

    assert(Transaction.verify(transaction) == true)
  end

  test "should build delegate registration and verify with second passphrase", context do
    transaction =
      Builder.build_delegate_registration(
        "Moo",
        context[:passphrase],
        context[:second_passphrase]
      )

    second_public_key = PublicKey.from_passphrase(context[:second_passphrase])

    assert(Transaction.verify(transaction) == true)
    assert(Transaction.second_verify(transaction, second_public_key) == true)
  end
end

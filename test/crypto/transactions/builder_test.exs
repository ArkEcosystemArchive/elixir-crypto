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
        amount: 133380000000,
        recipient_id: "AXoXnFi4z1Z6aFvjEYkDVCtBGW2PaRiM25",
        vendor_field: "This is a transaction from Elixir",
        secret: "this is a top secret passphrase",
        second_secret: "this is a top secret second passphrase",
        delegate: "034151a3ec46b5670a682b0a63394f863587d1bc97483b1b6c70eb58e7f0aed192"
      ]
    }
  end

  test "should build transfer and verify", context do
    transaction = Builder.build_transfer(
      context[:recipient_id],
      context[:amount],
      context[:vendor_field],
      context[:secret]
    )

    assert(Transaction.verify(transaction) == true)
  end

  test "should build transfer and verfiy with second secret", context do
    transaction = Builder.build_transfer(
      context[:recipient_id],
      context[:amount],
      context[:vendor_field],
      context[:secret],
      context[:second_secret]
    )

    second_public_key_address = PublicKey.from_passphrase(context[:second_secret])

    assert(Transaction.verify(transaction) == true)
    assert(Transaction.second_verify(transaction, second_public_key_address) == true)
  end

  test "should build vote and verify", context do
    votes = ["+" <> context[:delegate]]

    transaction = Builder.build_vote(
      votes, context[:secret]
    )

    assert(Transaction.verify(transaction) == true)
  end

  test "should build vote and verify with second secret", context do
    votes = ["+" <> context[:delegate]]

    transaction = Builder.build_vote(
      votes, context[:secret], context[:second_secret]
    )

    second_public_key_address = PublicKey.from_passphrase(context[:second_secret])

    assert(Transaction.verify(transaction) == true)
    assert(Transaction.second_verify(transaction, second_public_key_address) == true)
  end

  test "should build second signature registration and verify", context do
    transaction = Builder.build_second_signature_registration(
      context[:secret], context[:second_secret]
    )

    second_public_key_address = PublicKey.from_passphrase(context[:second_secret])

    assert(Transaction.verify(transaction) == true)
    assert(Transaction.second_verify(transaction, second_public_key_address) == true)
  end

  test "should build delegate registration and verify", context do
    transaction = Builder.build_delegate_registration(
      "Moo", context[:secret]
    )

    assert(Transaction.verify(transaction) == true)
  end

  test "should build delegate registration and verify with second secret", context do
    transaction = Builder.build_delegate_registration(
      "Moo", context[:secret], context[:second_secret]
    )

    second_public_key_address = PublicKey.from_passphrase(context[:second_secret])

    assert(Transaction.verify(transaction) == true)
    assert(Transaction.second_verify(transaction, second_public_key_address) == true)
  end

end
